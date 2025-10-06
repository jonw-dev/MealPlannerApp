//
//  MainTabView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @StateObject private var subscriptionManager = RevenueCatManager.shared

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                MealsView()
                    .tabItem { Label("Meals", systemImage: "fork.knife") }
                    .tag(0)

                WeeklyPlanViewV2()
                    .tabItem { Label("Meal Plan", systemImage: "calendar") }
                    .tag(1)

                ShopListView()
                    .tabItem { Label("Shopping", systemImage: "cart") }
                    .tag(2)

                ItemsView()
                    .tabItem { Label("Items", systemImage: "list.bullet") }
                    .tag(3)

                SettingsView()
                    .tabItem { Label("Settings", systemImage: "gearshape") }
                    .badge(subscriptionManager.isPremium ? nil : "!")
                    .tag(4)
            }
            .tint(AppTheme.primary)
            .toolbarBackground(.ultraThinMaterial, for: .tabBar)
        }
        .task {
            await subscriptionManager.checkSubscription()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                selectedTab = 0 // triggers re-render for glass material
            }
        }
    }
}
