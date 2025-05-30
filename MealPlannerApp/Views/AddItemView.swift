import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Binding var newItemName: String
    @Binding var selectedCategory: String
    @Binding var selectedEmoji: String?
    var onAdd: ((ShoppingItem) -> Void)?
    
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
    
    @State private var showingEmojiPicker = false
    
    private var defaultEmoji: String {
        let tempItem = ShoppingItem(name: newItemName, category: selectedCategory)
        return tempItem.displayEmoji
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Item Name", text: $newItemName)
                        .textInputAutocapitalization(.words)
                    
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                Section {
                    HStack {
                        Text("Emoji")
                        Spacer()
                        Text(selectedEmoji ?? defaultEmoji)
                            .font(.title2)
                        Button {
                            showingEmojiPicker = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .foregroundColor(AppTheme.primary)
                        }
                    }
                } footer: {
                    Text("Tap the pencil to customize the emoji")
                }
            }
            .navigationTitle("New Item")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        resetFields()
                        dismiss()
                    }
                    .foregroundColor(AppTheme.secondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addItem()
                    }
                    .disabled(newItemName.isEmpty)
                    .foregroundColor(AppTheme.primary)
                }
            }
            .sheet(isPresented: $showingEmojiPicker) {
                NavigationStack {
                    EmojiPickerView(selectedEmoji: $selectedEmoji)
                }
                .presentationDetents([.medium])
            }
        }
        .presentationDetents([.medium])
    }
    
    private func addItem() {
        let item = ShoppingItem(
            name: newItemName,
            category: selectedCategory,
            customEmoji: selectedEmoji
        )
        modelContext.insert(item)
        onAdd?(item)
        resetFields()
        dismiss()
    }
    
    private func resetFields() {
        newItemName = ""
        selectedCategory = "Produce"
        selectedEmoji = nil
    }
} 