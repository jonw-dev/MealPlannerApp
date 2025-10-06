//
//  ShareManager.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 03/02/2025.
//

import SwiftUI
import UIKit

class ShareManager {
    
    // MARK: - Meal Plan Sharing
    
    /// Generate a formatted text representation of the meal plan
    static func generateMealPlanText(scheduledMeals: [ScheduledMeal], dateRange: [Date]) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        var text = "🍽️ MY MEAL PLAN\n"
        text += "═══════════════════════════════\n\n"
        
        // Group meals by date
        for date in dateRange {
            let mealsForDate = scheduledMeals
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .sorted { $0.mealTime < $1.mealTime }
            
            text += "📅 \(dateFormatter.string(from: date))\n"
            
            if mealsForDate.isEmpty {
                text += "   No meals planned\n"
            } else {
                for (index, scheduledMeal) in mealsForDate.enumerated() {
                    let meal = scheduledMeal.meal
                    let categoryIcon = getCategoryIcon(meal.mealCategory)
                    
                    text += "   \(categoryIcon) \(meal.name)"
                    if index < mealsForDate.count - 1 {
                        text += "\n"
                    }
                }
                text += "\n"
            }
            text += "\n"
        }
        
        text += "═══════════════════════════════\n"
        text += "Created with Meal Planner App 📱\n"
        
        return text
    }
    
    /// Generate a detailed meal plan with ingredients
    static func generateDetailedMealPlanText(scheduledMeals: [ScheduledMeal], dateRange: [Date]) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        var text = "🍽️ MY MEAL PLAN (DETAILED)\n"
        text += "═══════════════════════════════\n\n"
        
        for date in dateRange {
            let mealsForDate = scheduledMeals
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .sorted { $0.mealTime < $1.mealTime }
            
            if !mealsForDate.isEmpty {
                text += "📅 \(dateFormatter.string(from: date))\n"
                text += "───────────────────────────────\n"
                
                for scheduledMeal in mealsForDate {
                    let meal = scheduledMeal.meal
                    let categoryIcon = getCategoryIcon(meal.mealCategory)
                    
                    text += "\(categoryIcon) \(meal.name.uppercased())\n"
                    
                    if !meal.descriptionn.isEmpty {
                        text += "   \(meal.descriptionn)\n"
                    }
                    
                    if !meal.ingredients.isEmpty {
                        text += "   Ingredients:\n"
                        for ingredient in meal.ingredients {
                            text += "   • \(ingredient.name)\n"
                        }
                    }
                    text += "\n"
                }
            }
        }
        
        text += "═══════════════════════════════\n"
        text += "Created with Meal Planner App 📱\n"
        
        return text
    }
    
    // MARK: - Shopping List Sharing
    
    /// Generate a formatted shopping list text
    static func generateShoppingListText(items: [ShoppingListItem]) -> String {
        var text = "🛒 MY SHOPPING LIST\n"
        text += "═══════════════════════════════\n\n"
        
        // Group by category
        let grouped = Dictionary(grouping: items) { $0.category }
        let sortedCategories = grouped.keys.sorted()
        
        for category in sortedCategories {
            if let categoryItems = grouped[category], !categoryItems.isEmpty {
                text += "📦 \(category.uppercased())\n"
                text += "───────────────────────────────\n"
                
                for item in categoryItems.sorted(by: { $0.name < $1.name }) {
                    let checkbox = item.isChecked ? "✅" : "☐"
                    let countText = item.count > 1 ? " (x\(item.count))" : ""
                    text += "\(checkbox) \(item.name)\(countText)\n"
                }
                text += "\n"
            }
        }
        
        let totalItems = items.reduce(0) { $0 + $1.count }
        let purchasedItems = items.filter { $0.isChecked }.reduce(0) { $0 + $1.count }
        
        text += "═══════════════════════════════\n"
        text += "Progress: \(purchasedItems)/\(totalItems) items\n"
        text += "Created with Meal Planner App 📱\n"
        
        return text
    }
    
    /// Generate a simple shopping list (just item names)
    static func generateSimpleShoppingListText(items: [ShoppingListItem]) -> String {
        var text = "🛒 SHOPPING LIST\n\n"
        
        // Group by category
        let grouped = Dictionary(grouping: items) { $0.category }
        let sortedCategories = grouped.keys.sorted()
        
        for category in sortedCategories {
            if let categoryItems = grouped[category], !categoryItems.isEmpty {
                text += "\(category):\n"
                
                for item in categoryItems.sorted(by: { $0.name < $1.name }) {
                    let countText = item.count > 1 ? " (x\(item.count))" : ""
                    text += "• \(item.name)\(countText)\n"
                }
                text += "\n"
            }
        }
        
        return text
    }
    
    // MARK: - CSV Export
    
    /// Generate CSV format for shopping list
    static func generateShoppingListCSV(items: [ShoppingListItem]) -> String {
        var csv = "Item,Category,Count,Checked\n"
        
        for item in items.sorted(by: { $0.category < $1.category }) {
            let checked = item.isChecked ? "Yes" : "No"
            csv += "\"\(item.name)\",\"\(item.category)\",\(item.count),\(checked)\n"
        }
        
        return csv
    }
    
    /// Generate CSV format for meal plan
    static func generateMealPlanCSV(scheduledMeals: [ScheduledMeal], dateRange: [Date]) -> String {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        var csv = "Date,Meal,Category,Description,Ingredients\n"
        
        for date in dateRange {
            let mealsForDate = scheduledMeals
                .filter { calendar.isDate($0.date, inSameDayAs: date) }
                .sorted { $0.mealTime < $1.mealTime }
            
            for scheduledMeal in mealsForDate {
                let meal = scheduledMeal.meal
                let dateStr = dateFormatter.string(from: date)
                let ingredients = meal.ingredients.map { $0.name }.joined(separator: "; ")
                
                csv += "\"\(dateStr)\",\"\(meal.name)\",\"\(meal.mealCategory.rawValue)\",\"\(meal.descriptionn)\",\"\(ingredients)\"\n"
            }
        }
        
        return csv
    }
    
    // MARK: - Share Sheet Presentation
    
    /// Present share sheet for text content
    static func shareText(_ text: String, title: String = "Share") {
        let activityVC = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            
            // For iPad
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = rootViewController.view
                popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                          y: rootViewController.view.bounds.midY,
                                          width: 0, height: 0)
                popover.permittedArrowDirections = []
            }
            
            rootViewController.present(activityVC, animated: true)
        }
    }
    
    /// Present share sheet for file (CSV)
    static func shareFile(_ content: String, fileName: String) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            try content.write(to: tempURL, atomically: true, encoding: .utf8)
            
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                
                // For iPad
                if let popover = activityVC.popoverPresentationController {
                    popover.sourceView = rootViewController.view
                    popover.sourceRect = CGRect(x: rootViewController.view.bounds.midX,
                                              y: rootViewController.view.bounds.midY,
                                              width: 0, height: 0)
                    popover.permittedArrowDirections = []
                }
                
                rootViewController.present(activityVC, animated: true)
            }
        } catch {
            print("Error creating file: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    
    private static func getCategoryIcon(_ category: MealCategory) -> String {
        switch category {
        case .breakfast: return "🌅"
        case .lunch: return "☀️"
        case .dinner: return "🌙"
        case .snack: return "🥤"
        case .dessert: return "🍰"
        case .other: return "🍽️"
        }
    }
}

