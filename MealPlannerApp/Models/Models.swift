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

@Model
class Meal: Identifiable {
    var id: UUID
    var name: String
    var descriptionn: String
    var imageData: Data?
    @Relationship(deleteRule: .nullify) var ingredients: [ShoppingItem]
    
    init(name: String, descriptionn: String, imageData: Data? = nil, ingredients: [ShoppingItem] = []) {
        self.id = UUID()
        self.name = name
        self.descriptionn = descriptionn
        self.imageData = imageData
        self.ingredients = ingredients
    }
}

@Model
class ScheduledMeal: Identifiable {
    var id: UUID
    var date: Date
    @Relationship var meal: Meal
    
    init(date: Date, meal: Meal) {
        self.id = UUID()
        self.date = date
        self.meal = meal
    }
}
