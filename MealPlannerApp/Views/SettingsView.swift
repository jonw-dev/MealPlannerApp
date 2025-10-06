//
//  SettingsView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 03/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject private var subscriptionManager = RevenueCatManager.shared
    @State private var showingPaywall = false
    @State private var showingRestoreAlert = false
    @State private var restoreMessage = ""
    
    var body: some View {
        NavigationStack {
            Form {
                // Subscription Section
                Section {
                    if subscriptionManager.isPremium {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Premium")
                                    .font(.headline)
                                    .foregroundColor(AppTheme.primary)
                                Text("Active - \(subscriptionStatusText)")
                                    .font(.caption)
                                    .foregroundColor(.green)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                                .font(.title2)
                        }
                        
                        Button {
                            openSubscriptionManagement()
                        } label: {
                            HStack {
                                Text("Manage Subscription")
                                Spacer()
                                Image(systemName: "arrow.up.right.square")
                                    .foregroundColor(AppTheme.secondary)
                            }
                        }
                        
                        Button {
                            Task {
                                await restorePurchases()
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.caption)
                                .foregroundColor(AppTheme.primary)
                        }
                    } else {
                        Button {
                            showingPaywall = true
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Upgrade to Premium")
                                        .font(.headline)
                                        .foregroundColor(AppTheme.primary)
                                    Text("Unlock all features")
                                        .font(.caption)
                                        .foregroundColor(AppTheme.secondary)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(AppTheme.secondary)
                            }
                        }
                        
                        Button {
                            Task {
                                await restorePurchases()
                            }
                        } label: {
                            Text("Restore Purchases")
                                .font(.caption)
                                .foregroundColor(AppTheme.primary)
                        }
                    }
                } header: {
                    Text("Subscription")
                }
                
                // Premium Features Section
                Section {
                    FeatureItem(
                        icon: "plus.square.on.square",
                        title: "Multiple Meals Per Day",
                        isUnlocked: subscriptionManager.isPremium
                    )
                    
                    FeatureItem(
                        icon: "calendar",
                        title: "Extended Planning (14+ days)",
                        isUnlocked: subscriptionManager.isPremium
                    )
                    
                    FeatureItem(
                        icon: "tag.fill",
                        title: "Meal Categories",
                        isUnlocked: subscriptionManager.isPremium
                    )
                    
                    FeatureItem(
                        icon: "square.and.arrow.up",
                        title: "Export & Share Meal Plans",
                        isUnlocked: subscriptionManager.isPremium
                    )
                } header: {
                    Text("Premium Features")
                }
                
                
                // App Info Section
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(AppTheme.secondary)
                    }
                    
                    Link(destination: URL(string: "https://yourwebsite.com/privacy")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(AppTheme.secondary)
                        }
                    }
                    
                    Link(destination: URL(string: "https://yourwebsite.com/terms")!) {
                        HStack {
                            Text("Terms of Service")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(AppTheme.secondary)
                        }
                    }
                } header: {
                    Text("About")
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                RevenueCatPaywallView()
            }
            .alert("Restore Purchases", isPresented: $showingRestoreAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(restoreMessage)
            }
        }
    }
    
    var subscriptionStatusText: String {
        switch subscriptionManager.subscriptionStatus {
        case .weekly:
            return "Weekly"
        case .monthly:
            return "Monthly"
        case .annual:
            return "Annual"
        case .free:
            return "Free"
        }
    }
    
    func restorePurchases() async {
        do {
            try await subscriptionManager.restorePurchases()
            restoreMessage = "Purchases restored successfully!"
            showingRestoreAlert = true
        } catch {
            restoreMessage = "No purchases to restore."
            showingRestoreAlert = true
        }
    }
    
    func openSubscriptionManagement() {
        // Open App Store subscription management
        if let url = URL(string: "https://apps.apple.com/account/subscriptions") {
            UIApplication.shared.open(url)
        }
    }
}

struct FeatureItem: View {
    let icon: String
    let title: String
    let isUnlocked: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(isUnlocked ? AppTheme.primary : AppTheme.secondary.opacity(0.5))
                .frame(width: 30)
            
            Text(title)
                .foregroundColor(isUnlocked ? AppTheme.primary : AppTheme.secondary)
            
            Spacer()
            
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
            } else {
                Image(systemName: "lock.fill")
                    .foregroundColor(AppTheme.secondary.opacity(0.5))
                    .font(.caption)
            }
        }
    }
}

#Preview {
    SettingsView()
}

