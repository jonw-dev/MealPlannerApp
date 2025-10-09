import SwiftUI
import SwiftData

struct IngredientPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedIngredients: [ShoppingItem]
    @Query(sort: \ShoppingItem.category) private var items: [ShoppingItem]
    @State private var searchText = ""
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var selectedCategory = "Produce"
    @State private var selectedEmoji: String?
    @State private var selectedCategoryFilter: String?
    
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
    
    var filteredItems: [ShoppingItem] {
        var filtered = items
        if !searchText.isEmpty {
            filtered = filtered.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        if let category = selectedCategoryFilter {
            filtered = filtered.filter { $0.category == category }
        }
        return filtered
    }
    
    var groupedItems: [String: [ShoppingItem]] {
        Dictionary(grouping: filteredItems) { $0.category }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search and filter bar
                VStack(spacing: 8) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppTheme.secondary)
                        TextField("Search items", text: $searchText)
                            .textFieldStyle(.plain)
                    }
                    .padding(8)
                    .background(AppTheme.cardBackground)
                    .cornerRadius(8)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    if selectedCategoryFilter == category {
                                        selectedCategoryFilter = nil
                                    } else {
                                        selectedCategoryFilter = category
                                    }
                                } label: {
                                    Text(category)
                                        .font(AppTheme.captionStyle)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            selectedCategoryFilter == category ?
                                            AppTheme.primary :
                                            AppTheme.secondary.opacity(0.2)
                                        )
                                        .foregroundColor(
                                            selectedCategoryFilter == category ?
                                            .white :
                                            AppTheme.primary
                                        )
                                        .cornerRadius(16)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding()
                .background(AppTheme.background)
                
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
                                                .font(AppTheme.bodyStyle)
                                                .foregroundColor(AppTheme.primary)
                                            
                                            Spacer()
                                            
                                            if selectedIngredients.contains(where: { $0.id == item.id }) {
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
            .navigationTitle("Select Items")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.secondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView(
                    newItemName: $newItemName,
                    selectedCategory: $selectedCategory,
                    selectedEmoji: $selectedEmoji,
                    onAdd: { item in
                        selectedIngredients.append(item)
                    }
                )
            }
            .background(AppTheme.background)
        }
    }
    
    private func toggleSelection(for item: ShoppingItem) {
        if let index = selectedIngredients.firstIndex(where: { $0.id == item.id }) {
            selectedIngredients.remove(at: index)
        } else {
            selectedIngredients.append(item)
        }
    }
} 