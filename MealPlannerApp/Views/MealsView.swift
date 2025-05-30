//
//  MealsView.swift
//  MealPlannerApp
//
//  Created by jon richardson-williams on 28/01/2025.
//

import SwiftUI
import SwiftData

struct MealsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Meal.name) private var meals: [Meal]
    @State private var showingAddMeal = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(meals) { meal in
                    NavigationLink {
                        MealDetailView(meal: meal)
                    } label: {
                        MealRowView(meal: meal)
                    }
                }
                .onDelete(perform: deleteMeals)
            }
            .navigationTitle("Meals")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddMeal.toggle()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddMeal) {
                AddMealView()
            }
        }
    }
    
    private func deleteMeals(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(meals[index])
        }
    }
}

struct MealRowView: View {
    let meal: Meal
    
    var body: some View {
        HStack(spacing: 12) {
            if let imageData = meal.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppTheme.secondary.opacity(0.1))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(AppTheme.secondary)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(meal.name)
                    .font(AppTheme.headlineStyle)
                    .foregroundColor(AppTheme.primary)
                Text(meal.descriptionn)
                    .font(AppTheme.captionStyle)
                    .foregroundColor(AppTheme.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

struct MealDetailView: View {
    @Bindable var meal: Meal
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                MealImageView(imageData: meal.imageData)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(meal.name)
                        .font(AppTheme.titleStyle)
                        .foregroundColor(AppTheme.primary)
                    
                    Text(meal.descriptionn)
                        .font(AppTheme.bodyStyle)
                        .foregroundColor(AppTheme.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                IngredientsSection(ingredients: meal.ingredients)
            }
            .padding(.vertical)
        }
        .background(AppTheme.background)
        .navigationTitle("Meal Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                NavigationLink {
                    EditMealView(meal: meal)
                } label: {
                    Text("Edit")
                        .foregroundColor(AppTheme.primary)
                }
            }
        }
    }
}

struct MealImageView: View {
    let imageData: Data?
    
    var body: some View {
        if let imageData = imageData,
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 250)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(radius: 5)
        } else {
            RoundedRectangle(cornerRadius: 16)
                .fill(AppTheme.secondary.opacity(0.1))
                .frame(height: 200)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(AppTheme.secondary)
                )
        }
    }
}

struct IngredientsSection: View {
    let ingredients: [ShoppingItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredients")
                .font(AppTheme.headlineStyle)
                .foregroundColor(AppTheme.primary)
            
            if ingredients.isEmpty {
                Text("No ingredients added yet.")
                    .font(AppTheme.bodyStyle)
                    .foregroundColor(AppTheme.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(AppTheme.secondary.opacity(0.1))
                    .cornerRadius(10)
            } else {
                ForEach(ingredients) { ingredient in
                    IngredientRow(ingredient: ingredient)
                }
            }
        }
        .padding()
        .background(AppTheme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
        .padding(.horizontal)
    }
}

struct IngredientRow: View {
    let ingredient: ShoppingItem
    
    var body: some View {
        HStack {
            Text(ingredient.displayEmoji)
                .font(.title2)
            Text(ingredient.name)
                .font(AppTheme.bodyStyle)
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

struct EditMealView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var meal: Meal
    @State private var showingImagePicker = false
    @State private var showingAddIngredients = false
    @State private var selectedItems: Set<ShoppingItem.ID> = []
    
    var body: some View {
        Form {
            Section {
                MealImageView(imageData: meal.imageData)
                    .listRowInsets(EdgeInsets())
                
                Button {
                    showingImagePicker = true
                } label: {
                    HStack {
                        Image(systemName: "photo")
                        Text(meal.imageData == nil ? "Add Image" : "Change Image")
                    }
                    .foregroundColor(AppTheme.primary)
                }
            }
            .listRowBackground(AppTheme.cardBackground)
            
            Section {
                TextField("Name", text: $meal.name)
                    .font(AppTheme.bodyStyle)
                TextField("Description", text: $meal.descriptionn, axis: .vertical)
                    .font(AppTheme.bodyStyle)
                    .lineLimit(3...6)
            } header: {
                Text("Details")
                    .foregroundColor(AppTheme.primary)
            }
            .listRowBackground(AppTheme.cardBackground)
            
            Section {
                if meal.ingredients.isEmpty {
                    Text("No ingredients added yet.")
                        .font(AppTheme.bodyStyle)
                        .foregroundColor(AppTheme.secondary)
                } else {
                    ForEach(meal.ingredients) { ingredient in
                        HStack {
                            Text(ingredient.displayEmoji)
                                .font(.title2)
                            Text(ingredient.name)
                                .font(AppTheme.bodyStyle)
                            Spacer()
                        }
                    }
                    .onDelete { indexSet in
                        meal.ingredients.remove(atOffsets: indexSet)
                    }
                }
                
                Button {
                    showingAddIngredients = true
                } label: {
                    Label("Add Ingredients", systemImage: "plus")
                        .foregroundColor(AppTheme.primary)
                }
            } header: {
                Text("Ingredients")
                    .foregroundColor(AppTheme.primary)
            }
            .listRowBackground(AppTheme.cardBackground)
        }
        .navigationTitle("Edit Meal")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(AppTheme.secondary)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
                .foregroundColor(AppTheme.primary)
            }
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(imageData: $meal.imageData)
        }
        .sheet(isPresented: $showingAddIngredients) {
            NavigationStack {
                ItemSelectionView(selectedItems: $selectedItems)
                    .navigationTitle("Add Ingredients")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") {
                                selectedItems.removeAll()
                                showingAddIngredients = false
                            }
                            .foregroundColor(AppTheme.secondary)
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Add") {
                                addSelectedIngredients()
                                showingAddIngredients = false
                            }
                            .disabled(selectedItems.isEmpty)
                            .foregroundColor(AppTheme.primary)
                        }
                    }
            }
            .presentationDetents([.medium, .large])
        }
    }
    
    private func addSelectedIngredients() {
        for itemID in selectedItems {
            if let item = try? modelContext.fetch(FetchDescriptor<ShoppingItem>(predicate: #Predicate<ShoppingItem> { item in
                item.id == itemID
            })).first {
                if !meal.ingredients.contains(where: { $0.id == item.id }) {
                    meal.ingredients.append(item)
                }
            }
        }
        selectedItems.removeAll()
    }
}
