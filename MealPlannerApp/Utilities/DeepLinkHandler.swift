//
//  DeepLinkHandler.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 06/10/2025.
//

import Foundation
import SwiftData

class DeepLinkHandler: ObservableObject {
    @Published var pendingImport: ImportData?
    @Published var showImportAlert = false
    
    enum ImportData {
        case mealPlan(MealPlanImportData)
        case shoppingList(ShoppingListImportData)
        case meal(MealImportData)
    }
    
    struct MealPlanImportData: Codable {
        let meals: [MealData]
        let dateRange: [TimeInterval]
        
        struct MealData: Codable {
            let name: String
            let description: String
            let category: String
            let ingredients: [String]
            let date: TimeInterval
            let mealTime: TimeInterval
        }
    }
    
    struct ShoppingListImportData: Codable {
        let items: [ItemData]
        
        struct ItemData: Codable {
            let name: String
            let category: String
            let count: Int
        }
    }
    
    struct MealImportData: Codable {
        let name: String
        let description: String
        let category: String
        let ingredients: [String]
    }
    
    // MARK: - URL Handling
    
    func handleURL(_ url: URL) -> Bool {
        guard url.scheme == "simplemeal" else { return false }
        
        let host = url.host()
        
        switch host {
        case "meal-plan":
            return handleMealPlanURL(url)
        case "shopping-list":
            return handleShoppingListURL(url)
        case "meal":
            return handleMealURL(url)
        default:
            return false
        }
    }
    
    private func handleMealPlanURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let dataParam = queryItems.first(where: { $0.name == "data" })?.value,
              let data = Data(base64Encoded: dataParam) else {
            return false
        }
        
        do {
            let decoder = JSONDecoder()
            let importData = try decoder.decode(MealPlanImportData.self, from: data)
            
            DispatchQueue.main.async {
                self.pendingImport = .mealPlan(importData)
                self.showImportAlert = true
            }
            
            return true
        } catch {
            print("Error decoding meal plan: \(error)")
            return false
        }
    }
    
    private func handleShoppingListURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let dataParam = queryItems.first(where: { $0.name == "data" })?.value,
              let data = Data(base64Encoded: dataParam) else {
            return false
        }
        
        do {
            let decoder = JSONDecoder()
            let importData = try decoder.decode(ShoppingListImportData.self, from: data)
            
            DispatchQueue.main.async {
                self.pendingImport = .shoppingList(importData)
                self.showImportAlert = true
            }
            
            return true
        } catch {
            print("Error decoding shopping list: \(error)")
            return false
        }
    }
    
    private func handleMealURL(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let dataParam = queryItems.first(where: { $0.name == "data" })?.value,
              let data = Data(base64Encoded: dataParam) else {
            return false
        }
        
        do {
            let decoder = JSONDecoder()
            let importData = try decoder.decode(MealImportData.self, from: data)
            
            DispatchQueue.main.async {
                self.pendingImport = .meal(importData)
                self.showImportAlert = true
            }
            
            return true
        } catch {
            print("Error decoding meal: \(error)")
            return false
        }
    }
    
    // MARK: - URL Generation
    
    static func generateMealPlanURL(scheduledMeals: [ScheduledMeal]) -> URL? {
        let mealData = scheduledMeals.map { scheduledMeal in
            MealPlanImportData.MealData(
                name: scheduledMeal.meal.name,
                description: scheduledMeal.meal.descriptionn,
                category: scheduledMeal.meal.mealCategory.rawValue,
                ingredients: scheduledMeal.meal.ingredients.map { $0.name },
                date: scheduledMeal.date.timeIntervalSince1970,
                mealTime: scheduledMeal.mealTime.timeIntervalSince1970
            )
        }
        
        let dateRange = Array(Set(scheduledMeals.map { $0.date }))
            .sorted()
            .map { $0.timeIntervalSince1970 }
        
        let importData = MealPlanImportData(meals: mealData, dateRange: dateRange)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(importData)
            let base64 = data.base64EncodedString()
            
            var components = URLComponents()
            components.scheme = "simplemeal"
            components.host = "meal-plan"
            components.queryItems = [URLQueryItem(name: "data", value: base64)]
            
            return components.url
        } catch {
            print("Error encoding meal plan: \(error)")
            return nil
        }
    }
    
    static func generateShoppingListURL(items: [ShoppingListItem]) -> URL? {
        let itemData = items.map { item in
            ShoppingListImportData.ItemData(
                name: item.name,
                category: item.category,
                count: item.count
            )
        }
        
        let importData = ShoppingListImportData(items: itemData)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(importData)
            let base64 = data.base64EncodedString()
            
            var components = URLComponents()
            components.scheme = "simplemeal"
            components.host = "shopping-list"
            components.queryItems = [URLQueryItem(name: "data", value: base64)]
            
            return components.url
        } catch {
            print("Error encoding shopping list: \(error)")
            return nil
        }
    }
    
    static func generateMealURL(meal: Meal) -> URL? {
        let importData = MealImportData(
            name: meal.name,
            description: meal.descriptionn,
            category: meal.mealCategory.rawValue,
            ingredients: meal.ingredients.map { $0.name }
        )
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(importData)
            let base64 = data.base64EncodedString()
            
            var components = URLComponents()
            components.scheme = "simplemeal"
            components.host = "meal"
            components.queryItems = [URLQueryItem(name: "data", value: base64)]
            
            return components.url
        } catch {
            print("Error encoding meal: \(error)")
            return nil
        }
    }
    
    // MARK: - Import to Database
    
    func importMealPlan(_ data: MealPlanImportData, modelContext: ModelContext) {
        for mealData in data.meals {
            // Create ingredients as ShoppingItems
            let ingredients = mealData.ingredients.map { name in
                ShoppingItem(name: name, category: "Pantry")
            }
            
            // Create meal category
            let category = MealCategory(rawValue: mealData.category) ?? .other
            
            // Create meal
            let meal = Meal(
                name: mealData.name,
                descriptionn: mealData.description,
                imageData: nil,
                ingredients: ingredients,
                category: category
            )
            
            // Create scheduled meal with correct parameter order and types
            let scheduledMeal = ScheduledMeal(
                date: Date(timeIntervalSince1970: mealData.date),
                meal: meal,
                mealTime: Date(timeIntervalSince1970: mealData.mealTime)
            )
            
            // Insert ingredients first
            for ingredient in ingredients {
                modelContext.insert(ingredient)
            }
            
            modelContext.insert(meal)
            modelContext.insert(scheduledMeal)
        }
        
        try? modelContext.save()
    }
    
    func importShoppingList(_ data: ShoppingListImportData, modelContext: ModelContext) {
        for itemData in data.items {
            let item = ShoppingListItem(
                name: itemData.name,
                count: itemData.count,
                category: itemData.category,
                isChecked: false
            )
            
            modelContext.insert(item)
        }
        
        try? modelContext.save()
    }
    
    func importMeal(_ data: MealImportData, modelContext: ModelContext) {
        // Create ingredients as ShoppingItems
        let ingredients = data.ingredients.map { name in
            ShoppingItem(name: name, category: "Pantry")
        }
        
        // Create meal category
        let category = MealCategory(rawValue: data.category) ?? .other
        
        // Create meal
        let meal = Meal(
            name: data.name,
            descriptionn: data.description,
            imageData: nil,
            ingredients: ingredients,
            category: category
        )
        
        // Insert ingredients first
        for ingredient in ingredients {
            modelContext.insert(ingredient)
        }
        
        modelContext.insert(meal)
        
        try? modelContext.save()
    }
}

