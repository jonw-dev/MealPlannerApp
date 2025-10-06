//
//  RevenueCatManager.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 03/02/2025.
//

import Foundation
import RevenueCat
import SwiftUI

@MainActor
class RevenueCatManager: NSObject, ObservableObject {
    @Published var isPremium: Bool = false
    @Published var subscriptionStatus: SubscriptionStatus = .free
    @Published var isLoading: Bool = false
    
    static let shared = RevenueCatManager()
    
    // Your product identifiers from App Store Connect
    enum ProductID: String {
        case weekly = "03"     // £0.79 - Weekly
        case monthly = "02"    // £2.49 - Monthly
        case annual = "01"     // £19.99 - Annual
    }
    
    enum SubscriptionStatus {
        case free
        case weekly
        case monthly
        case annual
    }
    
    private override init() {
        super.init()
        
        // Set up delegate to listen for purchase updates
        Purchases.shared.delegate = self
        
        // Initial check
        Task {
            await checkSubscription()
        }
    }
    
    // MARK: - Subscription Checking
    
    func checkSubscription() async {
        do {
            let customerInfo = try await Purchases.shared.customerInfo()
            
            // Debug logging
            print("📊 === Customer Info Debug ===")
            print("📊 Active Subscriptions: \(customerInfo.activeSubscriptions)")
            print("📊 All Entitlements: \(customerInfo.entitlements.all.keys)")
            print("📊 Active Entitlements: \(customerInfo.entitlements.active.keys)")
            
            // Check all entitlements (in case it's not named "premium")
            for (key, entitlement) in customerInfo.entitlements.all {
                print("📊 Entitlement '\(key)': isActive = \(entitlement.isActive)")
            }
            
            // Check if user has ANY active entitlement OR active subscription
            let hasActiveEntitlement = !customerInfo.entitlements.active.isEmpty
            let hasActiveSubscription = !customerInfo.activeSubscriptions.isEmpty
            
            // Also check for "Premium" or "premium" entitlement specifically
            let hasPremiumEntitlement = customerInfo.entitlements["Premium"]?.isActive == true || 
                                       customerInfo.entitlements["premium"]?.isActive == true
            
            if hasActiveEntitlement || hasActiveSubscription || hasPremiumEntitlement {
                isPremium = true
                
                // Determine which subscription type
                if customerInfo.activeSubscriptions.contains(ProductID.annual.rawValue) {
                    subscriptionStatus = .annual
                } else if customerInfo.activeSubscriptions.contains(ProductID.monthly.rawValue) {
                    subscriptionStatus = .monthly
                } else if customerInfo.activeSubscriptions.contains(ProductID.weekly.rawValue) {
                    subscriptionStatus = .weekly
                } else {
                    subscriptionStatus = .annual // Default if we can't determine
                }
            } else {
                isPremium = false
                subscriptionStatus = .free
            }
            
            print("✅ Premium Status: \(isPremium)")
            print("✅ Subscription: \(subscriptionStatus)")
            print("📊 === End Debug ===")
        } catch {
            print("❌ Error checking subscription: \(error)")
            isPremium = false
            subscriptionStatus = .free
        }
    }
    
    // MARK: - Purchase Methods
    
    func purchase(package: Package) async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let result = try await Purchases.shared.purchase(package: package)
            
            // Check if user now has access
            if result.customerInfo.entitlements["premium"]?.isActive == true {
                await checkSubscription()
                print("✅ Purchase successful!")
            }
        } catch {
            print("❌ Purchase error: \(error)")
            throw error
        }
    }
    
    func restorePurchases() async throws {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let customerInfo = try await Purchases.shared.restorePurchases()
            
            if customerInfo.entitlements["premium"]?.isActive == true {
                await checkSubscription()
                print("✅ Purchases restored!")
            } else {
                print("ℹ️ No active purchases to restore")
                throw PurchaseError.noPurchasesToRestore
            }
        } catch {
            print("❌ Restore error: \(error)")
            throw error
        }
    }
    
    // MARK: - Feature Access
    
    func canAddMultipleMeals(for date: Date, currentMealCount: Int) -> Bool {
        if isPremium {
            return currentMealCount < 5 // Premium: up to 5 meals per day
        } else {
            return currentMealCount < 1 // Free: only 1 meal per day
        }
    }
    
    func maxMealsPerDay() -> Int {
        return isPremium ? 5 : 1
    }
    
    func canPlanForDate(_ date: Date) -> Bool {
        if isPremium {
            return true // Premium: unlimited date planning
        } else {
            // Free: only 7 days from today
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            let targetDate = calendar.startOfDay(for: date)
            
            guard let daysDifference = calendar.dateComponents([.day], from: today, to: targetDate).day else {
                return false
            }
            
            return daysDifference >= 0 && daysDifference < 7
        }
    }
    
    func maxPlanningDays() -> Int {
        return isPremium ? 30 : 7
    }
    
    // MARK: - User Info
    
    func getUserID() -> String? {
        return Purchases.shared.appUserID
    }
    
    // MARK: - Error Types
    
    enum PurchaseError: LocalizedError {
        case noPurchasesToRestore
        case purchaseCancelled
        case unknown
        
        var errorDescription: String? {
            switch self {
            case .noPurchasesToRestore:
                return "No active purchases found to restore."
            case .purchaseCancelled:
                return "Purchase was cancelled."
            case .unknown:
                return "An unknown error occurred."
            }
        }
    }
}

// MARK: - PurchasesDelegate
extension RevenueCatManager: PurchasesDelegate {
    nonisolated func purchases(_ purchases: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        // This is called automatically when purchase status changes
        print("🔔 Customer info updated - refreshing subscription status")
        
        Task { @MainActor in
            await checkSubscription()
        }
    }
}

