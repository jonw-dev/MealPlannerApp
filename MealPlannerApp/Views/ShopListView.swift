//
//  ShopListView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

struct ShopListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingListItem.name) private var shoppingList: [ShoppingListItem]
    @Query private var scheduledMeals: [ScheduledMeal]
    @Query private var settings: [MealPlanSettings]
    @ObservedObject private var subscriptionManager = RevenueCatManager.shared
    @State private var showingAddItems = false
    @State private var selectedItems: Set<ShoppingItem.ID> = []
    @State private var showingShareOptions = false
    @State private var showingPaywall = false
    
    private var mealPlanDateRange: (start: Date, end: Date)? {
        guard let settings = settings.first,
              !settings.dateRange.isEmpty else { return nil }
        
        let calendar = Calendar.current
        return (
            calendar.startOfDay(for: settings.dateRange.first!),
            calendar.startOfDay(for: settings.dateRange.last!)
        )
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if shoppingList.isEmpty {
                    ContentUnavailableView(
                        "No Items",
                        systemImage: "cart",
                        description: Text("Add items manually or generate from your meal plan")
                    )
                    .foregroundColor(AppTheme.secondary)
                } else {
                    List {
                        ForEach(shoppingList) { item in
                            HStack(spacing: 12) {
                                Button(action: { toggleCheckmark(for: item) }) {
                                    Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isChecked ? AppTheme.primary : AppTheme.secondary)
                                }
                                .buttonStyle(.plain)
                                
                                Text(item.displayEmoji)
                                    .font(.title2)
                                
                                Text(item.name)
                                    .font(AppTheme.bodyStyle)
                                    .foregroundColor(AppTheme.primary)
                                    .strikethrough(item.isChecked)
                                
                                Spacer()
                                
                                HStack(spacing: 8) {
                                    Button(action: { decrementCount(for: item) }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(item.count > 1 ? AppTheme.primary : AppTheme.secondary)
                                            .font(.title3)
                                    }
                                    .buttonStyle(.plain)
                                    .disabled(item.count <= 1)
                                    
                                    if !item.formattedCount.isEmpty {
                                        Text(item.formattedCount)
                                            .font(AppTheme.captionStyle)
                                            .foregroundColor(AppTheme.secondary)
                                    }
                                    
                                    Button(action: { incrementCount(for: item) }) {
                                        Image(systemName: "plus.circle.fill")
                                            .foregroundColor(AppTheme.primary)
                                            .font(.title3)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            .listRowBackground(AppTheme.cardBackground)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        modelContext.delete(item)
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if subscriptionManager.isPremium {
                            showingShareOptions = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(AppTheme.primary)
                    }
                    .disabled(shoppingList.isEmpty)
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Button(action: generateFromMealPlan) {
                            Label("Generate from Meal Plan", systemImage: "calendar")
                        }
                        
                        Button(action: clearList) {
                            Label("Clear List", systemImage: "trash")
                                .foregroundColor(AppTheme.accent)
                        }
                        
                        Button(action: { showingAddItems.toggle() }) {
                            Label("Add Items Manually", systemImage: "plus")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddItems) {
                NavigationStack {
                    ItemSelectionView(selectedItems: $selectedItems)
                        .navigationTitle("Add Items")
                        .toolbarRole(.navigationStack)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    selectedItems.removeAll()
                                    showingAddItems = false
                                }
                                .foregroundColor(AppTheme.secondary)
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    addSelectedItems()
                                    showingAddItems = false
                                }
                                .disabled(selectedItems.isEmpty)
                                .foregroundColor(AppTheme.primary)
                            }
                        }
                }
            }
            .sheet(isPresented: $showingPaywall) {
                RevenueCatPaywallView()
            }
            .confirmationDialog("Share Shopping List", isPresented: $showingShareOptions) {
                Button("Share Simple List") {
                    shareSimpleList()
                }
                Button("Share Detailed List") {
                    shareDetailedList()
                }
                Button("Export as CSV") {
                    shareAsCSV()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Choose how you'd like to share your shopping list")
            }
            .background(AppTheme.background)
        }
    }
    
    private func toggleCheckmark(for item: ShoppingListItem) {
        item.isChecked.toggle()
    }
    
    private func incrementCount(for item: ShoppingListItem) {
        item.count += 1
    }
    
    private func decrementCount(for item: ShoppingListItem) {
        if item.count > 1 {
            item.count -= 1
        }
    }
    
    private func addSelectedItems() {
        for itemID in selectedItems {
            if let item = try? modelContext.fetch(FetchDescriptor<ShoppingItem>(predicate: #Predicate<ShoppingItem> { item in
                item.id == itemID
            })).first {
                // Check if item already exists in shopping list
                if let existingItem = shoppingList.first(where: { $0.name == item.name }) {
                    existingItem.count += 1
                } else {
                    let shoppingItem = ShoppingListItem(
                        name: item.name,
                        count: 1,
                        category: item.category
                    )
                    modelContext.insert(shoppingItem)
                }
            }
        }
        selectedItems.removeAll()
    }
    
    private func clearList() {
        for item in shoppingList {
            modelContext.delete(item)
        }
    }
    
    // MARK: - Sharing Methods
    
    private func shareSimpleList() {
        ShareManager.shareShoppingListWithDeepLink(items: shoppingList, includeDetails: false)
    }
    
    private func shareDetailedList() {
        ShareManager.shareShoppingListWithDeepLink(items: shoppingList, includeDetails: true)
    }
    
    private func shareAsCSV() {
        let csv = ShareManager.generateShoppingListCSV(items: shoppingList)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fileName = "shopping-list-\(dateFormatter.string(from: Date())).csv"
        ShareManager.shareFile(csv, fileName: fileName)
    }
    
    private func generateFromMealPlan() {
        // Clear existing list
        clearList()
        
        guard let dateRange = mealPlanDateRange else { return }
        
        // Get all ingredients from scheduled meals within the meal plan range
        let ingredients = scheduledMeals
            .filter { meal in
                let mealDate = Calendar.current.startOfDay(for: meal.date)
                return mealDate >= dateRange.start && mealDate <= dateRange.end
            }
            .flatMap { $0.meal.ingredients }
        
        // Create shopping list items with counts
        let groupedIngredients = Dictionary(grouping: ingredients) { $0.name }
        
        for (name, items) in groupedIngredients {
            if let firstItem = items.first {
                let shoppingItem = ShoppingListItem(
                    name: name,
                    count: items.count,
                    category: firstItem.category
                )
                modelContext.insert(shoppingItem)
            }
        }
    }
}

struct ItemSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingItem.category) private var items: [ShoppingItem]
    @Binding var selectedItems: Set<ShoppingItem.ID>
    @State private var searchText = ""
    @State private var selectedCategory: String?
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var selectedItemCategory = "Produce"
    @State private var selectedEmoji: String?
    
    var filteredItems: [ShoppingItem] {
        var filtered = items
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        return filtered
    }
    
    var groupedItems: [String: [ShoppingItem]] {
        Dictionary(grouping: filteredItems) { $0.category }
    }
    
    let categories = [
        // Food Categories
        "Produce",
        "Meat & Seafood",
        "Dairy & Eggs",
        "Pantry",
        "Grains & Pasta",
        "Canned Goods",
        "Frozen Foods",
        "Condiments",
        "Spices & Herbs",
        "Baking",
        "Beverages",
        "Snacks",
        // Household Categories
        "Cleaning Supplies",
        "Paper & Plastic",
        "Household Essentials",
        "Personal Care",
        "Pet Supplies",
        "Baby Items"
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar in a sticky header
            VStack(spacing: 8) {
                TextField("Search items", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                } else {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(selectedCategory == category ? AppTheme.primary : AppTheme.primary.opacity(0.1))
                                    )
                                    .foregroundColor(selectedCategory == category ? .white : AppTheme.primary)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.vertical, 8)
            .background(AppTheme.background)
            
            // Add "Add searched item" button when no results found
            if !searchText.isEmpty && !filteredItems.contains(where: { $0.name.localizedCaseInsensitiveContains(searchText) }) {
                Button {
                    newItemName = searchText
                    showingAddItem = true
                } label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add \"\(searchText)\" to Items")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppTheme.cardBackground)
                    .foregroundColor(AppTheme.primary)
                }
            }
            
            // List of items
            List {
                ForEach(categories, id: \.self) { category in
                    if let items = groupedItems[category], !items.isEmpty {
                        Section(header: Text(category).foregroundColor(AppTheme.primary)) {
                            ForEach(items) { item in
                                Button {
                                    toggleSelection(for: item)
                                } label: {
                                    HStack {
                                        Text(item.displayEmoji)
                                            .font(.title2)
                                        Text(item.name)
                                            .foregroundColor(AppTheme.primary)
                                        Spacer()
                                        if selectedItems.contains(item.id) {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(AppTheme.primary)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                }
                                .buttonStyle(.plain)
                                .listRowBackground(AppTheme.cardBackground)
                            }
                        }
                    }
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationTitle("Add Items")
        .sheet(isPresented: $showingAddItem) {
            AddItemView(
                newItemName: $newItemName,
                selectedCategory: $selectedItemCategory,
                selectedEmoji: $selectedEmoji,
                onAdd: { item in
                    selectedItems.insert(item.id)
                }
            )
        }
    }
    
    private func toggleSelection(for item: ShoppingItem) {
        if selectedItems.contains(item.id) {
            selectedItems.remove(item.id)
        } else {
            selectedItems.insert(item.id)
        }
    }
}
