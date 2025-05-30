//
//  MealPlannerAppApp.swift
//  SimpleMealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

@main
struct SimpleMealPlannerApp: App {
    let modelContainer: ModelContainer
    @State private var showLaunchScreen = true
    
    init() {
        do {
            modelContainer = try ModelContainer(for: ShoppingItem.self, Meal.self, ScheduledMeal.self, ShoppingListItem.self, MealPlanSettings.self)
            let context = modelContainer.mainContext
            
            // Check if this is the first launch
            let defaults = UserDefaults.standard
            let hasLaunchedBefore = defaults.bool(forKey: "hasLaunchedBefore")
            
            // Only populate if no shopping items exist or if it's the first launch
            let descriptor = FetchDescriptor<ShoppingItem>()
            let isEmpty = (try? context.fetch(descriptor).isEmpty) ?? true
            
            if !hasLaunchedBefore || isEmpty {
                // Create default items
                for item in DefaultItems.items {
                    let shoppingItem = ShoppingItem(name: item.name, category: item.category, customEmoji: item.emoji)
                    context.insert(shoppingItem)
                }
                
                // Save that we've launched before
                defaults.set(true, forKey: "hasLaunchedBefore")
            }
            
            // Create initial meal plan settings if none exist
            let settingsDescriptor = FetchDescriptor<MealPlanSettings>()
            if try context.fetch(settingsDescriptor).isEmpty {
                context.insert(MealPlanSettings())
            }
        } catch {
            fatalError("Could not initialize ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                MainTabView()
                    .opacity(showLaunchScreen ? 0 : 1)
                
                if showLaunchScreen {
                    LaunchScreen()
                }
            }
            .onAppear {
                // Dismiss launch screen after a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        showLaunchScreen = false
                    }
                }
            }
        }
        .modelContainer(modelContainer)
    }
    
    private func parseQuantityAndUnit(from string: String) -> (Double, String) {
        // Common cases
        if string.contains("pack") {
            return (1.0, "pack")
        }
        if string.contains("box") {
            return (1.0, "box")
        }
        if string.contains("bag") {
            return (1.0, "bag")
        }
        if string.contains("can") {
            return (1.0, "can")
        }
        if string.contains("case") {
            return (1.0, "case")
        }
        if string.contains("bunch") {
            return (1.0, "bunch")
        }
        if string.contains("head") {
            return (1.0, "head")
        }
        if string.contains("piece") {
            return (1.0, "piece")
        }
        if string.contains("loaf") {
            return (1.0, "loaf")
        }
        if string.contains("dozen") {
            return (12.0, "unit")
        }
        
        // Handle numeric quantities
        let components = string.components(separatedBy: .whitespaces)
        if let first = components.first, let quantity = Double(first) {
            if components.count > 1 {
                let unit = components.dropFirst().joined(separator: " ")
                return (quantity, unit)
            }
            return (quantity, "unit")
        }
        
        // Handle fractions like "1/2"
        if string.contains("/") {
            let parts = string.components(separatedBy: "/")
            if parts.count == 2,
               let numerator = Double(parts[0]),
               let denominator = Double(parts[1]) {
                return (numerator / denominator, "unit")
            }
        }
        
        // Default case
        return (1.0, "unit")
    }
}
