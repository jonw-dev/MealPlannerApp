import Foundation
import SwiftData

@Model
class ShoppingListItem: Identifiable {
    var id: UUID
    var name: String
    var count: Int
    var category: String
    var isChecked: Bool
    
    init(name: String, count: Int = 1, category: String = "Pantry", isChecked: Bool = false) {
        self.id = UUID()
        self.name = name
        self.count = count
        self.category = category
        self.isChecked = isChecked
    }
    
    var formattedCount: String {
        count > 1 ? "x\(count)" : ""
    }
    
    var displayEmoji: String {
        // Look up emoji from DefaultItems
        if let defaultItem = DefaultItems.items.first(where: { $0.name == name && $0.category == category }) {
            return defaultItem.emoji
        }
        // Default emoji based on category if no match found
        switch category {
        case "Produce":
            return "🥬"
        case "Meat & Seafood":
            return "🍖"
        case "Dairy & Eggs":
            return "🥛"
        case "Pantry":
            return "🥫"
        case "Grains & Pasta":
            return "🌾"
        case "Canned Goods":
            return "🥫"
        case "Frozen Foods":
            return "🧊"
        case "Condiments":
            return "🫗"
        case "Spices & Herbs":
            return "🌿"
        case "Baking":
            return "🥖"
        case "Beverages":
            return "🥤"
        case "Snacks":
            return "🍿"
        case "Cleaning Supplies":
            return "🧼"
        case "Paper & Plastic":
            return "🧻"
        case "Household Essentials":
            return "🏠"
        case "Personal Care":
            return "🧴"
        case "Pet Supplies":
            return "🐾"
        case "Baby Items":
            return "🍼"
        default:
            return "��"
        }
    }
} 