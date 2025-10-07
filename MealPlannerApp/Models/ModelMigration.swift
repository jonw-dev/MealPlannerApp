//
//  ModelMigration.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 03/02/2025.
//

import Foundation
import SwiftData

/// Migration helper for updating models
struct ModelMigration {
    
    /// Migrates existing meals to add default category if missing and handle ingredient model changes
    static func migrateExistingData(context: ModelContext) throws {
        // Fetch all meals
        let mealDescriptor = FetchDescriptor<Meal>()
        let meals = try context.fetch(mealDescriptor)
        
        // Update any meals that might not have category set
        for meal in meals {
            if meal.category.isEmpty {
                meal.category = "Other"
            }
            
            // Note: Ingredient migration from ShoppingItem to MealIngredient
            // is handled automatically by SwiftData when the app detects the schema change.
            // Existing meals may lose their ingredients due to the model change.
            // Users should re-add ingredients to any affected meals.
        }
        
        // Fetch all scheduled meals
        let scheduledDescriptor = FetchDescriptor<ScheduledMeal>()
        let scheduledMeals = try context.fetch(scheduledDescriptor)
        
        // Update mealTime if needed (though it has a default now)
        for _ in scheduledMeals {
            // mealTime should have default value from the model
            // No action needed if it has default initializer
        }
        
        // Save changes
        try context.save()
    }
}

