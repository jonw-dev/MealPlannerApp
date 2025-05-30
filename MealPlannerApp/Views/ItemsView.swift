//
//  ItemsView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

struct ItemsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingItem.category) private var items: [ShoppingItem]
    @State private var showingAddItem = false
    @State private var newItemName = ""
    @State private var selectedCategory = "Produce"
    @State private var editingItem: ShoppingItem?
    @State private var searchText = ""
    @State private var showingAddEmojiPicker = false
    @State private var showingEditEmojiPicker = false
    @State private var selectedEmoji: String?
    @State private var selectedCategoryFilter: String?
    @State private var showingEditItem = false
    
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
                // Search bar in a sticky header
                VStack(spacing: 8) {
                    TextField("Search items", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    if selectedCategoryFilter == category {
                                        selectedCategoryFilter = nil
                                    } else {
                                        selectedCategoryFilter = category
                                    }
                                }) {
                                    Text(category)
                                        .font(.caption)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(selectedCategoryFilter == category ? AppTheme.primary : AppTheme.primary.opacity(0.1))
                                        )
                                        .foregroundColor(selectedCategoryFilter == category ? .white : AppTheme.primary)
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
                    ForEach(groupedItems.keys.sorted(), id: \.self) { category in
                        if let items = groupedItems[category] {
                            Section(header: Text(category).foregroundColor(AppTheme.primary)) {
                                ForEach(items) { item in
                                    Button {
                                        editingItem = item
                                    } label: {
                                        HStack {
                                            Text(item.displayEmoji)
                                                .font(.title2)
                                            
                                            Text(item.name)
                                                .font(AppTheme.bodyStyle)
                                                .foregroundColor(AppTheme.primary)
                                            
                                            Spacer()
                                            
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(AppTheme.secondary)
                                                .font(.caption)
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                    .listRowBackground(AppTheme.cardBackground)
                                }
                                .onDelete { indexSet in
                                    deleteItems(from: items, at: indexSet)
                                }
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Items")
            .toolbar {
                Button("Add Item", systemImage: "plus") {
                    selectedEmoji = nil
                    showingAddItem = true
                }
                .foregroundColor(AppTheme.primary)
            }
            .sheet(isPresented: $showingAddItem) {
                AddItemView(
                    newItemName: $newItemName,
                    selectedCategory: $selectedCategory,
                    selectedEmoji: $selectedEmoji
                )
            }
            .sheet(item: $editingItem) { item in
                NavigationStack {
                    Form {
                        Section {
                            TextField("Item Name", text: Binding(
                                get: { item.name },
                                set: { item.name = $0 }
                            ))
                            .textInputAutocapitalization(.words)
                            
                            Picker("Category", selection: Binding(
                                get: { item.category },
                                set: { item.category = $0 }
                            )) {
                                ForEach(categories, id: \.self) { category in
                                    Text(category).tag(category)
                                }
                            }
                        }
                        
                        Section {
                            HStack {
                                Text("Emoji")
                                Spacer()
                                Text(item.displayEmoji)
                                    .font(.title2)
                                Button {
                                    showingEditEmojiPicker = true
                                } label: {
                                    Image(systemName: "pencil.circle.fill")
                                        .foregroundColor(AppTheme.primary)
                                }
                            }
                        } footer: {
                            Text("Tap the pencil to customize the emoji")
                        }
                    }
                    .navigationTitle("Edit Item")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                editingItem = nil
                            }
                            .foregroundColor(AppTheme.secondary)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                editingItem = nil
                            }
                            .foregroundColor(AppTheme.primary)
                        }
                    }
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingAddEmojiPicker) {
                NavigationStack {
                    EmojiPickerView(selectedEmoji: $selectedEmoji)
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingEditEmojiPicker) {
                if let item = editingItem {
                    NavigationStack {
                        EmojiPickerView(selectedEmoji: Binding(
                            get: { item.customEmoji },
                            set: { item.customEmoji = $0 }
                        ))
                    }
                    .presentationDetents([.medium])
                }
            }
            .background(AppTheme.background)
        }
    }
    
    private func deleteItems(from items: [ShoppingItem], at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
    }
    
    private func resetNewItemFields() {
        newItemName = ""
        selectedCategory = "Produce"
        selectedEmoji = nil
    }
}

struct EmojiPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedEmoji: String?
    
    let itemEmojis: [(category: String, emojis: [String])] = [
        // Food Categories
        ("Fruits & Vegetables", [
            "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒", "🍑", "🥭", "🍍", "🥝", "🍅",
            "🫒", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🥜", "🫘", "🌰"
        ]),
        ("Prepared Foods", [
            "🍞", "🥐", "🥖", "🫓", "🥨", "🥯", "🥞", "🧇", "🧀", "🍖", "🍗", "🥩", "🥓", "🍔", "🍟", "🍕",
            "🌭", "🥪", "🌮", "🌯", "🫔", "🥙", "🧆", "🥚", "🍳", "🥘", "🍲", "🫕", "🥣", "🥗", "🍿", "🧈"
        ]),
        ("Beverages", [
            "☕", "🫖", "🍵", "🧃", "🥤", "🧋", "🍶", "🍺", "🍻", "🥂", "🍷", "🥃", "🍸", "🍹", "🧉", "🥛",
            "🥤", "🧃", "🧊"
        ]),
        ("Snacks & Sweets", [
            "🍿", "🥨", "🥜", "🌰", "🍪", "🍩", "🍫", "🍬", "🍭", "🍮", "🍯", "🍡", "🍧", "🍨", "🎂", "🧁",
            "🥮", "🍰"
        ]),
        // Household Categories
        ("Cleaning & Laundry", [
            "🧼", "🧽", "🧹", "🧴", "🪣", "🧺", "🪮", "🪥", "🚿", "💧", "✨", "🌟", "💫", "🧪"
        ]),
        ("Bathroom & Personal Care", [
            "🧻", "🪒", "🧴", "🧼", "🪥", "💊", "🩹", "🧪", "🧬", "🔬", "🪮", "🪞", "🛁", "🚿"
        ]),
        ("Kitchen & Storage", [
            "🔪", "🍽️", "🍴", "🥄", "🥢", "🫙", "🥫", "🧂", "🧊", "♨️", "🫕", "🍳", "📦", "🗑️"
        ]),
        ("Pet Supplies", [
            "🐕", "🐈", "🦮", "🐠", "🐟", "🐦", "🦜", "🐹", "🐰", "🦴", "🪹", "🧶", "🪆", "🧸"
        ]),
        ("Baby Items", [
            "👶", "🍼", "🧸", "🪆", "👕", "🧦", "🧴", "🎀", "📏", "🪮", "🎈", "🎊"
        ]),
        ("Paper & Packaging", [
            "📦", "🛍️", "🗑️", "📰", "📄", "🧻", "🥫", "🫙", "🥡", "🥤"
        ]),
        ("Miscellaneous", [
            "🏪", "🏬", "🛒", "🛍️", "📝", "⭐", "❄️", "🔥", "✨", "💫", "🌟", "🔋", "💡", "📎", "✂️", "📌"
        ])
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(itemEmojis, id: \.category) { category in
                        Section {
                            Text(category.category)
                                .font(.headline)
                                .foregroundColor(AppTheme.primary)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 12) {
                                ForEach(category.emojis, id: \.self) { emoji in
                                    Button {
                                        selectedEmoji = emoji
                                        dismiss()
                                    } label: {
                                        Text(emoji)
                                            .font(.title)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Divider()
                            .padding(.vertical, 8)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Choose Emoji")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                if selectedEmoji != nil {
                    ToolbarItem(placement: .automatic) {
                        Button("Reset") {
                            selectedEmoji = nil
                            dismiss()
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
    }
} 