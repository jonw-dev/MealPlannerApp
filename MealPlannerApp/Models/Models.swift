//
//  Models.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftData
import SwiftUI

@Model
class MealPlanSettings {
    var selectedDate: Date
    var numberOfDays: Int
    
    init(selectedDate: Date = Date(), numberOfDays: Int = 7) {
        self.selectedDate = selectedDate
        self.numberOfDays = numberOfDays
    }
    
    var dateRange: [Date] {
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: selectedDate)
        return (0..<numberOfDays).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startDate)
        }
    }
}

enum MealCategory: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    case dessert = "Dessert"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch: return "sun.max.fill"
        case .dinner: return "moon.stars.fill"
        case .snack: return "leaf.fill"
        case .dessert: return "birthday.cake.fill"
        case .other: return "fork.knife"
        }
    }
}

// New model for meal ingredients that are independent of the shopping items library
@Model
class MealIngredient: Identifiable {
    var id: UUID
    var name: String
    var category: String
    var customEmoji: String?
    
    init(name: String, category: String, customEmoji: String? = nil) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.customEmoji = customEmoji
    }
    
    // Copy constructor from ShoppingItem
    convenience init(from shoppingItem: ShoppingItem) {
        self.init(
            name: shoppingItem.name,
            category: shoppingItem.category,
            customEmoji: shoppingItem.customEmoji
        )
    }
    
    var displayEmoji: String {
        if let custom = customEmoji {
            return custom
        }
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
            return "🛒"
        }
    }
}

@Model
class Meal: Identifiable {
    var id: UUID
    var name: String
    var descriptionn: String
    var imageData: Data?
    var category: String = "Other" // Store as String for SwiftData compatibility, with default
    @Relationship(deleteRule: .cascade) var ingredients: [MealIngredient] // Changed to MealIngredient with cascade delete
    
    init(name: String, descriptionn: String, imageData: Data? = nil, ingredients: [MealIngredient] = [], category: MealCategory = .other) {
        self.id = UUID()
        self.name = name
        self.descriptionn = descriptionn
        self.imageData = imageData
        self.ingredients = ingredients
        self.category = category.rawValue
    }
    
    var mealCategory: MealCategory {
        get { MealCategory(rawValue: category) ?? .other }
        set { category = newValue.rawValue }
    }
}

@Model
class ScheduledMeal: Identifiable {
    var id: UUID
    var date: Date
    var mealTime: Date = Date() // Time of day for this meal (used for sorting multiple meals), with default
    @Relationship var meal: Meal
    
    init(date: Date, meal: Meal, mealTime: Date? = nil) {
        self.id = UUID()
        self.date = date
        self.mealTime = mealTime ?? date
        self.meal = meal
    }
}
