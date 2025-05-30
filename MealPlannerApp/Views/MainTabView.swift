//
//  MainTabView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            MealsView()
                .tabItem {
                    Label("Meals", systemImage: "fork.knife")
                }
                .tint(AppTheme.primary)
            
            WeeklyPlanView()
                .tabItem {
                    Label("Meal Plan", systemImage: "calendar")
                }
                .tint(AppTheme.primary)
            
            ShopListView()
                .tabItem {
                    Label("Shopping", systemImage: "cart")
                }
                .tint(AppTheme.primary)
            
            ItemsView()
                .tabItem {
                    Label("Items", systemImage: "list.bullet")
                }
                .tint(AppTheme.primary)
        }
        .accentColor(AppTheme.primary)
        .background(AppTheme.background)
    }
}
