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

@Model
class Meal: Identifiable {
    var id: UUID
    var name: String
    var descriptionn: String
    var imageData: Data?
    var category: String = "Other" // Store as String for SwiftData compatibility, with default
    @Relationship(deleteRule: .nullify) var ingredients: [ShoppingItem]
    
    init(name: String, descriptionn: String, imageData: Data? = nil, ingredients: [ShoppingItem] = [], category: MealCategory = .other) {
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
