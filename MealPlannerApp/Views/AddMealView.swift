//
//  AddMealView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

struct AddMealView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var descriptionn = ""
    @State private var imageData: Data?
    @State private var showingImagePicker = false
    @State private var showingIngredientPicker = false
    @State private var selectedIngredients: [ShoppingItem] = []
    @State private var selectedCategory: MealCategory = .other

    var body: some View {
        NavigationStack {
            Form {
                TextField("Meal Name", text: $name)
                TextField("Description", text: $descriptionn)
                
                Section("Category") {
                    Picker("Meal Type", selection: $selectedCategory) {
                        ForEach(MealCategory.allCases, id: \.self) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                if let imageData = imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                       .resizable()
                       .scaledToFit()
                       .frame(maxHeight: 200)
                }

                Button("Add Image") {
                    showingImagePicker.toggle()
                }
               .sheet(isPresented: $showingImagePicker) {
                   ImagePicker(imageData: $imageData)
               }

                Section("Ingredients") {
                    ForEach(selectedIngredients) { ingredient in
                        Text(ingredient.name)
                    }

                    Button("Add Ingredients") {
                        showingIngredientPicker.toggle()
                    }
                   .sheet(isPresented: $showingIngredientPicker) {
                       IngredientPickerView(selectedIngredients: $selectedIngredients)
                   }
                }
            }
           .navigationTitle("New Meal")
           .toolbar {
               ToolbarItem(placement: .cancellationAction) {
                   Button("Cancel") { dismiss() }
               }
               ToolbarItem(placement: .confirmationAction) {
                   Button("Save") {
                       let newMeal = Meal(
                        name: name,
                        descriptionn: descriptionn,
                        imageData: imageData,
                        ingredients: selectedIngredients,
                        category: selectedCategory
                       )
                       modelContext.insert(newMeal)
                       
                       // Explicitly save the context to ensure persistence
                       do {
                           try modelContext.save()
                           dismiss()
                       } catch {
                           print("Failed to save meal: \(error)")
                           // You might want to show an alert to the user here
                       }
                   }
                   .disabled(name.isEmpty || selectedIngredients.isEmpty)
               }
           }
        }
    }
}
