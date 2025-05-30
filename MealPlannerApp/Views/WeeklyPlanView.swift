import SwiftUI
import SwiftData

struct WeeklyPlanView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var scheduledMeals: [ScheduledMeal]
    @Query private var meals: [Meal]
    @Query private var settings: [MealPlanSettings]
    @State private var showingMealPicker = false
    @State private var showingDatePicker = false
    @State private var mealPickerDate = Date()
    @State private var showingDeleteAlert = false
    @State private var mealToDelete: (scheduledMeal: ScheduledMeal, date: Date)?
    
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
                                } else {
                                    modelContext.insert(MealPlanSettings(numberOfDays: newValue))
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
                List {
                    ForEach(dates, id: \.self) { date in
                        DayRowView(
                            date: date,
                            meal: scheduledMealFor(date: date)?.meal,
                            onAddMeal: {
                                mealPickerDate = date
                                showingMealPicker = true
                            }
                        )
                        .listRowBackground(AppTheme.cardBackground)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if let scheduledMeal = scheduledMealFor(date: date) {
                                Button(role: .destructive) {
                                    mealToDelete = (scheduledMeal: scheduledMeal, date: date)
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            }
            .navigationTitle("Meal Plan")
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
                        }
                    ), scheduledMeals: scheduledMeals)
                }
                .presentationDetents([.medium])
            }
            .alert("Remove Meal", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) {
                    mealToDelete = nil
                }
                Button("Delete", role: .destructive) {
                    if let mealToDelete = mealToDelete {
                        withAnimation {
                            modelContext.delete(mealToDelete.scheduledMeal)
                            self.mealToDelete = nil
                        }
                    }
                }
            } message: {
                if let mealToDelete = mealToDelete {
                    Text("Are you sure you want to remove this meal from \(weekdayFormatter.string(from: mealToDelete.date))?")
                }
            }
            .onAppear {
                if settings.isEmpty {
                    modelContext.insert(MealPlanSettings())
                }
            }
        }
    }
    
    private func scheduledMealFor(date: Date) -> ScheduledMeal? {
        scheduledMeals.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func addMealToSchedule(_ meal: Meal, for date: Date) {
        if let existingSchedule = scheduledMealFor(date: date) {
            modelContext.delete(existingSchedule)
        }
        
        let scheduledMeal = ScheduledMeal(date: date, meal: meal)
        modelContext.insert(scheduledMeal)
    }
    
    private let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
}

struct DayRowView: View {
    let date: Date
    let meal: Meal?
    let onAddMeal: () -> Void
    
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
        HStack(spacing: 16) {
            // Date column
            VStack(spacing: 4) {
                Text(weekdayFormatter.string(from: date))
                    .font(AppTheme.captionStyle)
                    .foregroundColor(AppTheme.secondary)
                Text(dayFormatter.string(from: date))
                    .font(AppTheme.headlineStyle)
                    .foregroundColor(AppTheme.primary)
            }
            .frame(width: 50)
            
            if let meal = meal {
                // Meal info
                Button(action: onAddMeal) {
                    MealRowView(meal: meal)
                        .cardStyle()
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                // Add meal button
                Button(action: onAddMeal) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Meal")
                    }
                    .foregroundColor(AppTheme.primary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppTheme.primary.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}

struct MealSelectionSheet: View {
    @Environment(\.dismiss) private var dismiss
    let selectedDate: Date
    let onMealSelected: (Meal) -> Void
    @Query(sort: \Meal.name) private var meals: [Meal]
    
    var body: some View {
        NavigationStack {
            List(meals) { meal in
                Button {
                    onMealSelected(meal)
                } label: {
                    MealRowView(meal: meal)
                }
            }
            .navigationTitle("Select Meal")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
} 
