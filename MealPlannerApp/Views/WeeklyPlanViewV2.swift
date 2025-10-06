//
//  WeeklyPlanViewV2.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 03/02/2025.
//
//  This is the upgraded version with multiple meals per day support

import SwiftUI
import SwiftData

struct WeeklyPlanViewV2: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var scheduledMeals: [ScheduledMeal]
    @Query private var meals: [Meal]
    @Query private var settings: [MealPlanSettings]
    @ObservedObject private var subscriptionManager = RevenueCatManager.shared
    
    @State private var showingMealPicker = false
    @State private var showingDatePicker = false
    @State private var showingPaywall = false
    @State private var mealPickerDate = Date()
    @State private var showingDeleteAlert = false
    @State private var mealToDelete: (scheduledMeal: ScheduledMeal, date: Date)?
    @State private var showingShareOptions = false
    
    private let calendar = Calendar.current
    private var dates: [Date] {
        settings.first?.dateRange ?? []
    }
    
    private var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Premium badge if subscribed
                if subscriptionManager.isPremium {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        Text("Premium")
                            .font(.caption)
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .foregroundColor(AppTheme.primary)
                    .padding(.horizontal)
                }
                
                // Date and duration selection
                HStack {
                    Button {
                        showingDatePicker = true
                    } label: {
                        HStack {
                            Image(systemName: "calendar")
                                .foregroundColor(AppTheme.primary)
                            Text(dateFormatter.string(from: settings.first?.selectedDate ?? Date()))
                                .foregroundColor(AppTheme.primary)
                        }
                        .padding(8)
                        .background(AppTheme.primary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                    Spacer()
                    
                    Menu {
                        Picker("Days", selection: .init(
                            get: { settings.first?.numberOfDays ?? 7 },
                            set: { newValue in
                                if let settings = settings.first {
                                    settings.numberOfDays = newValue
                                    try? modelContext.save()
                                } else {
                                    modelContext.insert(MealPlanSettings(numberOfDays: newValue))
                                    try? modelContext.save()
                                }
                            }
                        )) {
                            ForEach(1...14, id: \.self) { days in
                                Text("\(days) \(days == 1 ? "Day" : "Days")").tag(days)
                            }
                        }
                    } label: {
                        Text("\(settings.first?.numberOfDays ?? 7) \(settings.first?.numberOfDays == 1 ? "Day" : "Days")")
                            .foregroundColor(AppTheme.primary)
                            .padding(8)
                            .background(AppTheme.primary.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal)
                
                // Meal plan list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(dates, id: \.self) { date in
                            DayRowViewV2(
                                date: date,
                                scheduledMeals: scheduledMealsFor(date: date),
                                onAddMeal: {
                                    handleAddMeal(for: date)
                                },
                                onDeleteMeal: { scheduledMeal in
                                    mealToDelete = (scheduledMeal: scheduledMeal, date: date)
                                    showingDeleteAlert = true
                                }
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("Meal Plan")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if subscriptionManager.isPremium {
                            showingShareOptions = true
                        } else {
                            showingPaywall = true
                        }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(AppTheme.primary)
                    }
                }
            }
            .background(AppTheme.background)
            .sheet(isPresented: $showingMealPicker) {
                MealSelectionSheet(selectedDate: mealPickerDate) { meal in
                    addMealToSchedule(meal, for: mealPickerDate)
                    showingMealPicker = false
                }
            }
            .sheet(isPresented: $showingDatePicker) {
                NavigationStack {
                    DatePickerView(selectedDate: .init(
                        get: { settings.first?.selectedDate ?? Date() },
                        set: { newDate in
                            if let settings = settings.first {
                                settings.selectedDate = newDate
                            } else {
                                modelContext.insert(MealPlanSettings(selectedDate: newDate))
                            }
                            try? modelContext.save()
                        }
                    ), scheduledMeals: scheduledMeals)
                }
                .presentationDetents([.medium])
            }
            .sheet(isPresented: $showingPaywall) {
                RevenueCatPaywallView()
            }
            .confirmationDialog("Share Meal Plan", isPresented: $showingShareOptions) {
                Button("Share as Text") {
                    shareMealPlanAsText()
                }
                Button("Share Detailed Version") {
                    shareMealPlanDetailed()
                }
                Button("Export as CSV") {
                    shareMealPlanAsCSV()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Choose how you'd like to share your meal plan")
            }
            .alert("Remove Meal", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    mealToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let mealToDelete = mealToDelete {
                        withAnimation {
                            modelContext.delete(mealToDelete.scheduledMeal)
                            try? modelContext.save()
                            self.mealToDelete = nil
                        }
                    }
                }
            } message: {
                if let mealToDelete = mealToDelete {
                    Text("Are you sure you want to remove '\(mealToDelete.scheduledMeal.meal.name)' from \(weekdayFormatter.string(from: mealToDelete.date))?")
                }
            }
            .onAppear {
                if settings.isEmpty {
                    modelContext.insert(MealPlanSettings())
                    try? modelContext.save()
                }
                
                // Clean up any orphaned scheduled meals on app start
                cleanupOrphanedScheduledMeals()
                
                Task {
                    await subscriptionManager.checkSubscription()
                }
            }
        }
    }
    
    private func scheduledMealsFor(date: Date) -> [ScheduledMeal] {
        scheduledMeals
            .filter { calendar.isDate($0.date, inSameDayAs: date) }
            .filter { scheduledMeal in
                // Filter out any scheduled meals with broken meal references
                // This prevents crashes if a meal was deleted but scheduled meals weren't cleaned up
                do {
                    let _ = scheduledMeal.meal.name // Test if meal reference is valid
                    return true
                } catch {
                    // If accessing the meal throws an error, delete this orphaned scheduled meal
                    print("⚠️ Found orphaned scheduled meal, removing it")
                    modelContext.delete(scheduledMeal)
                    try? modelContext.save()
                    return false
                }
            }
            .sorted { $0.mealTime < $1.mealTime }
    }
    
    private func handleAddMeal(for date: Date) {
        // First check if user can plan for this date (7-day limit for free users)
        if !subscriptionManager.canPlanForDate(date) {
            showingPaywall = true
            return
        }
        
        // Then check if they can add multiple meals
        let currentCount = scheduledMealsFor(date: date).count
        
        if subscriptionManager.canAddMultipleMeals(for: date, currentMealCount: currentCount) {
            mealPickerDate = date
            showingMealPicker = true
        } else {
            // Show paywall
            showingPaywall = true
        }
    }
    
    private func addMealToSchedule(_ meal: Meal, for date: Date) {
        let scheduledMeal = ScheduledMeal(date: date, meal: meal, mealTime: date)
        modelContext.insert(scheduledMeal)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save scheduled meal: \(error)")
        }
    }
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    // MARK: - Sharing Methods
    
    private func shareMealPlanAsText() {
        ShareManager.shareMealPlanWithDeepLink(scheduledMeals: scheduledMeals, dateRange: dates, includeDetails: false)
    }
    
    private func shareMealPlanDetailed() {
        ShareManager.shareMealPlanWithDeepLink(scheduledMeals: scheduledMeals, dateRange: dates, includeDetails: true)
    }
    
    private func shareMealPlanAsCSV() {
        let csv = ShareManager.generateMealPlanCSV(scheduledMeals: scheduledMeals, dateRange: dates)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fileName = "meal-plan-\(dateFormatter.string(from: Date())).csv"
        ShareManager.shareFile(csv, fileName: fileName)
    }
    
    private func cleanupOrphanedScheduledMeals() {
        // Find and remove any scheduled meals with broken meal references
        var orphanedCount = 0
        
        for scheduledMeal in scheduledMeals {
            do {
                // Try to access the meal - if this fails, the reference is broken
                let _ = scheduledMeal.meal.name
            } catch {
                // Found an orphaned scheduled meal
                print("⚠️ Removing orphaned scheduled meal")
                modelContext.delete(scheduledMeal)
                orphanedCount += 1
            }
        }
        
        if orphanedCount > 0 {
            do {
                try modelContext.save()
                print("✅ Cleaned up \(orphanedCount) orphaned scheduled meal(s)")
            } catch {
                print("❌ Failed to save cleanup: \(error)")
            }
        }
    }
}

struct DayRowViewV2: View {
    @Environment(\.modelContext) private var modelContext
    
    let date: Date
    let scheduledMeals: [ScheduledMeal]
    let onAddMeal: () -> Void
    let onDeleteMeal: (ScheduledMeal) -> Void
    
    @ObservedObject private var subscriptionManager = RevenueCatManager.shared
    @State private var showingMealDetail: Meal?
    @State private var showingChangeMeal: ScheduledMeal?
    
    private let calendar = Calendar.current
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
    
    private let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weekdayFormatter.string(from: date))
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(AppTheme.secondary)
                    Text(dayFormatter.string(from: date))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(AppTheme.primary)
                }
                
                Spacer()
                
                // Show premium badge if date is locked for free users
                if !subscriptionManager.isPremium && !subscriptionManager.canPlanForDate(date) {
                    HStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.caption2)
                        Text("Premium")
                            .font(.caption2)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange.opacity(0.15))
                    .cornerRadius(8)
                } else if scheduledMeals.isEmpty {
                    Text("No meals")
                        .font(.caption)
                        .foregroundColor(AppTheme.secondary)
                } else {
                    Text("\(scheduledMeals.count) meal\(scheduledMeals.count == 1 ? "" : "s")")
                        .font(.caption)
                        .foregroundColor(AppTheme.primary)
                }
            }
            
            // Meals list
            if !scheduledMeals.isEmpty {
                VStack(spacing: 8) {
                    ForEach(scheduledMeals) { scheduledMeal in
                        SwipeableMealCard(
                            meal: scheduledMeal.meal,
                            onTap: {
                                showingMealDetail = scheduledMeal.meal
                            },
                            onDelete: {
                                onDeleteMeal(scheduledMeal)
                            },
                            onChange: {
                                showingChangeMeal = scheduledMeal
                            }
                        )
                    }
                }
            }
            
            // Add meal button - only show if less than 5 meals
            if scheduledMeals.count < 5 {
                Button(action: onAddMeal) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(scheduledMeals.isEmpty ? "Add Meal" : "Add Another Meal")
                        
                        // Show lock icon if date is beyond 7 days (free users) or if trying to add multiple meals
                        if !subscriptionManager.isPremium {
                            let isDateLocked = !subscriptionManager.canPlanForDate(date)
                            let isMultipleMealsLocked = scheduledMeals.count >= 1
                            
                            if isDateLocked || isMultipleMealsLocked {
                                Image(systemName: "lock.fill")
                                    .font(.caption)
                            }
                        }
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(scheduledMeals.isEmpty ? AppTheme.primary : AppTheme.primary.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(AppTheme.primary.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [5]))
                    )
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .sheet(item: $showingMealDetail) { meal in
            NavigationStack {
                MealDetailView(meal: meal)
            }
        }
        .sheet(item: $showingChangeMeal) { scheduledMeal in
            ChangeMealSheet(scheduledMeal: scheduledMeal, onMealChanged: { newMeal in
                changeMeal(scheduledMeal: scheduledMeal, to: newMeal)
            })
        }
    }
    
    private func changeMeal(scheduledMeal: ScheduledMeal, to newMeal: Meal) {
        scheduledMeal.meal = newMeal
        
        // Save the change
        do {
            try modelContext.save()
        } catch {
            print("Failed to save meal change: \(error)")
        }
    }
}

struct SwipeableMealCard: View {
    let meal: Meal
    let onTap: () -> Void
    let onDelete: () -> Void
    let onChange: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    @State private var dragStartX: CGFloat = 0
    @State private var dragStartY: CGFloat = 0
    
    private let buttonWidth: CGFloat = 80
    private let swipeThreshold: CGFloat = 20 // Minimum horizontal movement to trigger swipe
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Action buttons (hidden behind, revealed when swiping)
            HStack(spacing: 0) {
                Button {
                    withAnimation {
                        offset = 0
                    }
                    onChange()
                } label: {
                    VStack {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.title3)
                        Text("Change")
                            .font(.caption2)
                    }
                    .foregroundColor(.white)
                    .frame(width: buttonWidth)
                }
                .frame(maxHeight: .infinity)
                .background(Color.orange)
                
                Button {
                    withAnimation {
                        offset = 0
                    }
                    onDelete()
                } label: {
                    VStack {
                        Image(systemName: "trash")
                            .font(.title3)
                        Text("Delete")
                            .font(.caption2)
                    }
                    .foregroundColor(.white)
                    .frame(width: buttonWidth)
                }
                .frame(maxHeight: .infinity)
                .background(Color.red)
            }
            
            // Main meal card (sits on top, covers buttons)
            MealCardView(meal: meal)
                .background(AppTheme.cardBackground)
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translationX = value.translation.width
                            let translationY = value.translation.height
                            
                            // Determine if this is a horizontal or vertical swipe
                            if !isSwiping && abs(translationX) < swipeThreshold && abs(translationY) < swipeThreshold {
                                // Not enough movement yet, don't do anything
                                return
                            }
                            
                            // If we haven't determined swipe direction yet
                            if !isSwiping && offset == 0 {
                                // Check if horizontal movement is greater than vertical
                                if abs(translationX) > abs(translationY) {
                                    // This is a horizontal swipe
                                    isSwiping = true
                                } else {
                                    // This is a vertical scroll, don't interfere
                                    return
                                }
                            }
                            
                            // Only handle horizontal swipe if we've committed to swiping
                            if isSwiping || offset != 0 {
                                // Only allow left swipe (negative translation)
                                if translationX < 0 {
                                    offset = max(translationX, -buttonWidth * 2)
                                } else if offset < 0 {
                                    // Allow dragging back to close
                                    offset = min(translationX + (-buttonWidth * 2), 0)
                                }
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                if offset < -buttonWidth {
                                    offset = -buttonWidth * 2
                                } else {
                                    offset = 0
                                }
                                isSwiping = false
                            }
                        }
                )
                .onTapGesture {
                    if offset != 0 {
                        // Close swipe if open
                        withAnimation {
                            offset = 0
                        }
                    } else {
                        // Normal tap
                        onTap()
                    }
                }
                .contextMenu {
                    Button {
                        onChange()
                    } label: {
                        Label("Change Meal", systemImage: "arrow.triangle.2.circlepath")
                    }
                    
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MealCardView: View {
    let meal: Meal
    
    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            Image(systemName: meal.mealCategory.icon)
                .font(.title3)
                .foregroundColor(AppTheme.primary)
                .frame(width: 40, height: 40)
                .background(AppTheme.primary.opacity(0.1))
                .clipShape(Circle())
            
            // Meal info
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(AppTheme.primary)
                
                HStack(spacing: 4) {
                    Text(meal.mealCategory.rawValue)
                        .font(.caption)
                        .foregroundColor(AppTheme.secondary)
                    
                    if !meal.ingredients.isEmpty {
                        Text("•")
                            .foregroundColor(AppTheme.secondary)
                        Text("\(meal.ingredients.count) ingredients")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondary)
                    }
                }
            }
            
            Spacer()
            
            // Meal image or placeholder
            if let imageData = meal.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppTheme.secondary.opacity(0.1))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "fork.knife")
                            .font(.caption)
                            .foregroundColor(AppTheme.secondary)
                    )
            }
        }
        .padding(12)
        .background(AppTheme.primary.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ChangeMealSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Meal.name) private var meals: [Meal]
    @State private var selectedMeal: Meal?
    
    let scheduledMeal: ScheduledMeal
    let onMealChanged: (Meal) -> Void
    
    var body: some View {
        NavigationStack {
            List(meals) { meal in
                Button {
                    if meal.id != scheduledMeal.meal.id {
                        selectedMeal = meal
                    }
                } label: {
                    HStack {
                        MealCardView(meal: meal)
                        
                        Spacer()
                        
                        // Show different icons based on state
                        if let selected = selectedMeal {
                            // A meal is selected
                            if meal.id == selected.id {
                                // This is the newly selected meal
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                    .font(.title3)
                            } else if meal.id == scheduledMeal.meal.id {
                                // This is the current meal that will be removed
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title3)
                            }
                        } else {
                            // No meal selected yet, show current meal with checkmark
                            if meal.id == scheduledMeal.meal.id {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(AppTheme.primary)
                                    .font(.title3)
                            }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
            .navigationTitle("Change Meal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppTheme.secondary)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Change") {
                        if let newMeal = selectedMeal {
                            onMealChanged(newMeal)
                            dismiss()
                        }
                    }
                    .disabled(selectedMeal == nil)
                    .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
}

#Preview {
    WeeklyPlanViewV2()
        .modelContainer(for: [Meal.self, ScheduledMeal.self, ShoppingItem.self, MealPlanSettings.self], inMemory: true)
}

