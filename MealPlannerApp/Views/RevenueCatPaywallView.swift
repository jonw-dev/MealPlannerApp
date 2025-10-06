//
//  RevenueCatPaywallView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 03/02/2025.
//

import SwiftUI
import RevenueCat

struct RevenueCatPaywallView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var revenueCatManager = RevenueCatManager.shared
    
    @State private var offerings: Offering?
    @State private var selectedPackage: Package?
    @State private var isLoading = true
    @State private var showingError = false
    @State private var errorMessage = ""
    @State private var isPurchasing = false
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Premium Gradient Background with Animation
            AnimatedGradientBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Close Button
                    HStack {
                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding()
                    }
                    
                    // Premium Hero Section
                    VStack(spacing: 20) {
                        // Animated Premium Badge
                        ZStack {
                            // Outer glow rings
                            ForEach(0..<3) { index in
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            colors: [Color.yellow.opacity(0.3), Color.orange.opacity(0.1)],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 2
                                    )
                                    .frame(width: 130 + CGFloat(index * 20), height: 130 + CGFloat(index * 20))
                                    .opacity(0.4 - Double(index) * 0.1)
                            }
                            
                            // Main crown container
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                Color.yellow.opacity(0.4),
                                                Color.orange.opacity(0.3)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 110, height: 110)
                                    .blur(radius: 20)
                                
                                Circle()
                                    .fill(.ultraThickMaterial)
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 45))
                                    .foregroundStyle(
                                        LinearGradient(
                                            colors: [.yellow, .orange, .yellow],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .symbolEffect(.pulse, value: isLoading)
                            }
                        }
                        .padding(.top, 10)
                        
                        VStack(spacing: 12) {
                            Text("Unlock Premium")
                                .font(.system(size: 40, weight: .black, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [AppTheme.primary, AppTheme.primary.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("Take your meal planning to the next level")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    .padding(.vertical, 20)
                    
                    // Premium Features Section
                    VStack(spacing: 16) {
                        Text("What's Included")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                        
                        VStack(spacing: 14) {
                            EnhancedFeatureCard(
                                icon: "calendar.badge.plus",
                                title: "Extended Planning",
                                description: "Plan up to 30 days ahead with unlimited flexibility",
                                gradient: [.blue, .cyan],
                                accentColor: .blue
                            )
                            
                            EnhancedFeatureCard(
                                icon: "fork.knife.circle.fill",
                                title: "Multiple Meals Per Day",
                                description: "Add up to 5 meals daily for complete nutrition tracking",
                                gradient: [.green, .mint],
                                accentColor: .green
                            )
                            
                            EnhancedFeatureCard(
                                icon: "square.and.arrow.up.circle.fill",
                                title: "Share & Export",
                                description: "Share meal plans with family and export shopping lists",
                                gradient: [.purple, .pink],
                                accentColor: .purple
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 8)
                    
                    // Subscription Plans Section
                    if let offerings = offerings, !offerings.availablePackages.isEmpty {
                        VStack(spacing: 16) {
                            Text("Choose Your Plan")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.primary)
                                .padding(.top, 20)
                                .padding(.bottom, 8)
                            
                            VStack(spacing: 14) {
                                ForEach(offerings.availablePackages, id: \.identifier) { package in
                                    PremiumSubscriptionCard(
                                        package: package,
                                        isSelected: selectedPackage?.identifier == package.identifier
                                    ) {
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                                            selectedPackage = package
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    } else if isLoading {
                        VStack(spacing: 16) {
                            ProgressView()
                                .scaleEffect(1.3)
                                .tint(AppTheme.primary)
                            Text("Loading premium plans...")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 50)
                    }
                    
                    // Premium CTA Button
                    if selectedPackage != nil {
                        Button {
                            purchaseSubscription()
                        } label: {
                            ZStack {
                                // Background gradient with glow
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                AppTheme.primary,
                                                AppTheme.primary.opacity(0.85)
                                            ],
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: AppTheme.primary.opacity(0.5), radius: 20, x: 0, y: 10)
                                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                                
                                // Content
                                HStack(spacing: 14) {
                                    if isPurchasing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(1.1)
                                    } else {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 20, weight: .semibold))
                                        
                                        Text("Subscribe Now")
                                            .font(.system(size: 19, weight: .bold))
                                        
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 16, weight: .bold))
                                    }
                                }
                                .foregroundColor(.white)
                            }
                            .frame(height: 62)
                            .frame(maxWidth: .infinity)
                        }
                        .disabled(isPurchasing)
                        .padding(.horizontal, 20)
                        .padding(.top, 24)
                        .scaleEffect(isPurchasing ? 0.98 : 1.0)
                        .animation(.spring(response: 0.3), value: isPurchasing)
                    }
                    
                    // Trust & Security Footer
                    VStack(spacing: 16) {
                        // Restore Purchases Button
                        Button {
                            restorePurchases()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.counterclockwise")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("Restore Purchases")
                                    .font(.system(size: 15, weight: .semibold))
                            }
                            .foregroundColor(AppTheme.primary)
                        }
                        .padding(.top, 20)
                        .disabled(isPurchasing)
                        
                        // Trust Badges
                        HStack(spacing: 20) {
                            TrustBadge(icon: "lock.shield.fill", text: "Secure")
                            TrustBadge(icon: "arrow.clockwise", text: "Cancel Anytime")
                            TrustBadge(icon: "checkmark.seal.fill", text: "No Hidden Fees")
                        }
                        .padding(.horizontal, 20)
                        
                        // Legal Text
                        VStack(spacing: 8) {
                            Text("Subscription automatically renews unless cancelled.")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            
                            Text("Cancel anytime in Settings. Terms apply.")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary.opacity(0.8))
                        }
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                        .padding(.bottom, 30)
                    }
                }
            }
        }
        .alert("Error", isPresented: $showingError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            loadOfferings()
            animateGradient = true
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadOfferings() {
        isLoading = true
        
        Task {
            do {
                let offerings = try await Purchases.shared.offerings()
                self.offerings = offerings.current
                
                // Auto-select best value (annual)
                if let packages = offerings.current?.availablePackages {
                    if let annual = packages.first(where: { $0.packageType == .annual }) {
                        selectedPackage = annual
                    } else {
                        selectedPackage = packages.first
                    }
                }
                
                print("✅ Loaded offerings: \(offerings.current?.availablePackages.count ?? 0) packages")
            } catch {
                print("❌ Error loading offerings: \(error)")
                errorMessage = "Unable to load subscription options. Please try again later."
                showingError = true
            }
            
            isLoading = false
        }
    }
    
    private func purchaseSubscription() {
        guard let package = selectedPackage else { return }
        
        isPurchasing = true
        
        Task {
            do {
                try await revenueCatManager.purchase(package: package)
                
                // Success - dismiss paywall
                await MainActor.run {
                    isPurchasing = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    
                    if let error = error as? RevenueCat.ErrorCode {
                        switch error {
                        case .purchaseCancelledError:
                            // User cancelled, no need to show error
                            break
                        default:
                            errorMessage = error.localizedDescription
                            showingError = true
                        }
                    } else {
                        errorMessage = "Purchase failed. Please try again."
                        showingError = true
                    }
                }
            }
        }
    }
    
    private func restorePurchases() {
        isPurchasing = true
        
        Task {
            do {
                try await revenueCatManager.restorePurchases()
                
                await MainActor.run {
                    isPurchasing = false
                    dismiss()
                }
            } catch {
                await MainActor.run {
                    isPurchasing = false
                    errorMessage = "No purchases found to restore."
                    showingError = true
                }
            }
        }
    }
}

// MARK: - Animated Gradient Background
struct AnimatedGradientBackground: View {
    @State private var animate = false
    
    var body: some View {
        ZStack {
            // Base gradient
            LinearGradient(
                colors: [
                    AppTheme.primary.opacity(0.08),
                    AppTheme.background,
                    AppTheme.background,
                    AppTheme.secondary.opacity(0.05)
                ],
                startPoint: animate ? .topLeading : .bottomLeading,
                endPoint: animate ? .bottomTrailing : .topTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    animate = true
                }
            }
            
            // Subtle mesh gradient overlay
            RadialGradient(
                colors: [
                    AppTheme.primary.opacity(0.1),
                    Color.clear,
                    AppTheme.secondary.opacity(0.05)
                ],
                center: .topTrailing,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()
        }
    }
}

// MARK: - Enhanced Feature Card
struct EnhancedFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    let gradient: [Color]
    let accentColor: Color
    
    var body: some View {
        HStack(spacing: 16) {
            // Premium Icon Container
            ZStack {
                // Glow effect
                RoundedRectangle(cornerRadius: 14)
                    .fill(
                        LinearGradient(
                            colors: gradient.map { $0.opacity(0.3) },
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 56, height: 56)
                    .blur(radius: 8)
                
                // Main container
                RoundedRectangle(cornerRadius: 14)
                    .fill(.ultraThickMaterial)
                    .frame(width: 56, height: 56)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                LinearGradient(
                                    colors: gradient.map { $0.opacity(0.5) },
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1.5
                            )
                    )
                
                Image(systemName: icon)
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer(minLength: 8)
            
            // Premium checkmark
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 28, height: 28)
                
                Image(systemName: "checkmark")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(accentColor)
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThickMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }
}

// MARK: - Trust Badge
struct TrustBadge: View {
    let icon: String
    let text: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(AppTheme.primary)
            
            Text(text)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Premium Subscription Card
struct PremiumSubscriptionCard: View {
    let package: Package
    let isSelected: Bool
    let action: () -> Void
    
    var isBestValue: Bool {
        package.packageType == .annual
    }
    
    var isPopular: Bool {
        package.packageType == .monthly
    }
    
    var title: String {
        switch package.packageType {
        case .annual:
            return "Annual Plan"
        case .monthly:
            return "Monthly Plan"
        case .weekly:
            return "Weekly Plan"
        default:
            return package.storeProduct.localizedTitle
        }
    }
    
    var pricePerMonth: String? {
        guard package.packageType == .annual else { return nil }
        let price = package.storeProduct.price
        let monthly = price / 12
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = package.storeProduct.priceFormatter?.locale ?? .current
        return formatter.string(from: monthly as NSDecimalNumber)
    }
    
    var savings: String? {
        switch package.packageType {
        case .annual:
            return "Save 60%"
        case .monthly:
            return nil
        case .weekly:
            return nil
        default:
            return nil
        }
    }
    
    var badge: (text: String, colors: [Color])? {
        if isBestValue {
            return ("BEST VALUE", [.green, .mint])
        } else if isPopular {
            return ("POPULAR", [.blue, .cyan])
        }
        return nil
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                // Premium Badge
                if let badge = badge {
                    ZStack {
                        // Badge background
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: badge.colors,
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(height: 32)
                        
                        HStack(spacing: 6) {
                            if isBestValue {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 11, weight: .bold))
                            } else {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 11, weight: .bold))
                            }
                            
                            Text(badge.text)
                                .font(.system(size: 12, weight: .black))
                                .tracking(0.5)
                        }
                        .foregroundColor(.white)
                    }
                }
                
                HStack(spacing: 18) {
                    // Enhanced Radio Button
                    ZStack {
                        Circle()
                            .fill(isSelected ? AppTheme.primary.opacity(0.1) : Color.clear)
                            .frame(width: 32, height: 32)
                        
                        Circle()
                            .strokeBorder(
                                isSelected ? AppTheme.primary : Color.secondary.opacity(0.4),
                                lineWidth: 2.5
                            )
                            .frame(width: 26, height: 26)
                        
                        if isSelected {
                            Circle()
                                .fill(AppTheme.primary)
                                .frame(width: 14, height: 14)
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(title)
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(.primary)
                        
                        if let pricePerMonth = pricePerMonth {
                            HStack(spacing: 6) {
                                Text("Just \(pricePerMonth)")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(AppTheme.primary)
                                
                                Text("per month")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            Text(billingText)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text(package.localizedPriceString)
                            .font(.system(size: 24, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [AppTheme.primary, AppTheme.primary.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        if let savings = savings {
                            Text(savings)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                                .background(
                                    Capsule()
                                        .fill(Color.green)
                                )
                        }
                    }
                }
                .padding(22)
            }
            .background(
                ZStack {
                    // Main background
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.ultraThickMaterial)
                    
                    // Border
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(
                            isSelected
                                ? LinearGradient(
                                    colors: [AppTheme.primary, AppTheme.primary.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                : LinearGradient(
                                    colors: [Color.primary.opacity(0.12), Color.primary.opacity(0.08)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                            lineWidth: isSelected ? 2.5 : 1.5
                        )
                    
                    // Glow effect when selected
                    if isSelected {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.primary.opacity(0.05))
                    }
                }
                .shadow(
                    color: isSelected ? AppTheme.primary.opacity(0.25) : Color.black.opacity(0.08),
                    radius: isSelected ? 18 : 10,
                    x: 0,
                    y: isSelected ? 8 : 4
                )
            )
        }
        .buttonStyle(.plain)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.spring(response: 0.35, dampingFraction: 0.7), value: isSelected)
    }
    
    private var billingText: String {
        switch package.packageType {
        case .annual:
            return "Billed annually"
        case .monthly:
            return "Billed monthly"
        case .weekly:
            return "Billed weekly"
        default:
            return "One-time purchase"
        }
    }
}

// MARK: - Helper Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    RevenueCatPaywallView()
}