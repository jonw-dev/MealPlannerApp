//
//  MealSelectionView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

struct MealSelectionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Meal.name) private var meals: [Meal]
    @State private var searchText = ""
    @State private var selectedMeal: Meal?
    let selectedDate: Date
    
    var filteredMeals: [Meal] {
        guard !searchText.isEmpty else { return meals }
        return meals.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredMeals) { meal in
                HStack {
                    Text(meal.name)
                    Spacer()
                    if selectedMeal == meal {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedMeal = meal
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Select Meal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        if let selectedMeal = selectedMeal {
                            let scheduledMeal = ScheduledMeal(date: selectedDate, meal: selectedMeal)
                            modelContext.insert(scheduledMeal)
                            
                            // Explicitly save the context to ensure persistence
                            do {
                                try modelContext.save()
                                dismiss()
                            } catch {
                                print("Failed to save scheduled meal: \(error)")
                                // You might want to show an alert to the user here
                            }
                        } else {
                            dismiss()
                        }
                    }
                    .disabled(selectedMeal == nil)
                }
            }
        }
    }
}
