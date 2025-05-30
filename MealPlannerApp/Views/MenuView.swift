//
//  MenuView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

struct MenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ScheduledMeal.date) private var scheduledMeals: [ScheduledMeal]
    @State private var selectedDate = Date()
    @State private var numberOfDays = 7
    @State private var showingCalendar = false
    
    var dateRange: [Date] {
        (0..<numberOfDays).map { Calendar.current.date(byAdding: .day, value: $0, to: selectedDate)! }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                DatePicker("Start Date", selection: $selectedDate, displayedComponents: .date)
                    .onTapGesture { showingCalendar.toggle() }
                
                Picker("Days", selection: $numberOfDays) {
                    Text("7").tag(7)
                    Text("14").tag(14)
                    Text("21").tag(21)
                }
                .pickerStyle(.segmented)
                
                List(dateRange, id: \.self) { date in
                    NavigationLink {
                        MealSelectionView(selectedDate: date)
                    } label: {
                        HStack {
                            Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            Text(date.formatted(.dateTime.day().month(.abbreviated)))
                            Spacer()
                            if scheduledMeals.contains(where: { $0.date == date }) {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.red)
                            }
                        }
                    }
                }
                
                Button("Generate Shopping List") {
                    generateShoppingList()
                }
                .padding()
            }
        }
    }
    
    private func generateShoppingList() {
        // Group ingredients by name and category to combine duplicates
        let groupedIngredients = Dictionary(grouping: scheduledMeals.flatMap { $0.meal.ingredients }) { $0.name }
        
        for (name, items) in groupedIngredients {
            if let firstItem = items.first {
                let shoppingItem = ShoppingListItem(
                    name: name,
                    count: items.count,
                    category: firstItem.category
                )
                modelContext.insert(shoppingItem)
            }
        }
    }
}
