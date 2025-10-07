# Ingredient Persistence Fix

## 🐛 Problem Identified

**Critical Issue:** Users were losing meal ingredients after returning to the app hours later. For example, a meal saved with multiple ingredients would only show 7 ingredients after reopening the app.

### Root Cause

The app had a **fundamental architecture flaw** in how meal ingredients were stored:

1. **Shared Reference Model**: Meals were using `ShoppingItem` objects directly from the shared Items library
2. **Relationship with `.nullify` Delete Rule**: When a meal referenced a `ShoppingItem`, the relationship used `.nullify` delete rule
3. **Cascading Deletion**: When a `ShoppingItem` was deleted from the Items library (either manually by user or during cleanup), it was automatically removed from ALL meals that referenced it
4. **Silent Data Loss**: This happened silently - the user wouldn't know that deleting an item from the library would affect their saved meals

```swift
// OLD (BROKEN) MODEL
@Model
class Meal {
    @Relationship(deleteRule: .nullify) var ingredients: [ShoppingItem]  // ❌ Shared references
}
```

### Why This Happened

When you:
1. Created a meal with 10 ingredients
2. Later deleted 3 items from the Items library tab
3. Came back to view your meal

**Result**: Only 7 ingredients remained (the 3 deleted items were automatically removed from the meal)

---

## ✅ Solution Implemented

### Architectural Change: Independent Ingredient Storage

Created a new `MealIngredient` model that stores ingredient data **independently** from the shopping items library:

```swift
// NEW MODEL - Independent ingredient storage
@Model
class MealIngredient: Identifiable {
    var id: UUID
    var name: String
    var category: String
    var customEmoji: String?
    
    // Copy constructor from ShoppingItem
    convenience init(from shoppingItem: ShoppingItem) {
        self.init(
            name: shoppingItem.name,
            category: shoppingItem.category,
            customEmoji: shoppingItem.customEmoji
        )
    }
}

@Model
class Meal {
    @Relationship(deleteRule: .cascade) var ingredients: [MealIngredient]  // ✅ Independent copies
}
```

### How It Works Now

1. **When Creating a Meal**: 
   - User selects items from the shopping library
   - App creates **independent copies** as `MealIngredient` objects
   - These copies are owned by the meal and stored separately

2. **When Deleting from Items Library**:
   - Deleting an item only affects the library
   - Meal ingredients remain intact (they're independent copies)
   - No more silent data loss! 🎉

3. **Benefits**:
   - ✅ Meals preserve their ingredients permanently
   - ✅ Deleting items from library doesn't affect meals
   - ✅ Each meal has its own ingredient data
   - ✅ True data independence

---

## 📝 Files Modified

### 1. **Models.swift**
- Added new `MealIngredient` model with same properties as `ShoppingItem`
- Updated `Meal` model to use `[MealIngredient]` instead of `[ShoppingItem]`
- Changed delete rule from `.nullify` to `.cascade` (ingredients deleted when meal is deleted)

### 2. **MealPlannerApp.swift**
- Added `MealIngredient.self` to the SwiftData schema
- Schema now includes: `ShoppingItem`, `MealIngredient`, `Meal`, `ScheduledMeal`, `ShoppingListItem`, `MealPlanSettings`

### 3. **AddMealView.swift**
- Updated to convert `ShoppingItem` to `MealIngredient` when saving a meal
- Creates independent copies using `MealIngredient(from: shoppingItem)`

### 4. **MealsView.swift**
- Updated `IngredientsSection` to accept `[MealIngredient]` instead of `[ShoppingItem]`
- Updated `IngredientRow` to display `MealIngredient`
- Updated `EditMealView.addSelectedIngredients()` to create `MealIngredient` copies when adding ingredients

### 5. **DeepLinkHandler.swift**
- Updated `importMealPlan()` to create `MealIngredient` instances instead of `ShoppingItem`
- Updated `importMeal()` to create `MealIngredient` instances
- Ensures imported meals also use independent ingredient storage

### 6. **ShareManager.swift**
- No changes needed - already works with `MealIngredient` (uses `$0.name` accessor)

### 7. **ModelMigration.swift**
- Added notes about schema migration from `ShoppingItem` to `MealIngredient`

---

## ⚠️ Important Notes for Users

### First Launch After Update

Due to the schema change, **existing meals may have lost their ingredient references**. This is a one-time migration issue.

**What Users Need to Do:**
1. Open each existing meal
2. Tap "Edit"
3. Re-add the ingredients
4. Save

**Going Forward:** This problem will **never happen again** - all new meals use the fixed architecture.

### Data Migration

SwiftData will automatically handle the schema migration. The app will:
- Preserve all meal names, descriptions, images, and categories
- Clear ingredient relationships (due to model type change)
- Start fresh with the new `MealIngredient` model

---

## 🧪 Testing Checklist

- [x] Create a new meal with ingredients
- [x] Delete items from Items library
- [x] Verify meal still has all ingredients
- [x] Close and reopen app
- [x] Verify ingredients persist
- [x] Edit meal and add more ingredients
- [x] Delete meal (verify cascade delete of ingredients)
- [x] Share meal with deep link
- [x] Import meal from deep link
- [x] Generate shopping list from meal plan

---

## 🎯 Summary

**Before Fix:**
- Meals → Referenced shared `ShoppingItem` objects
- Deleting item from library → Removed from all meals
- Result: Silent ingredient loss

**After Fix:**
- Meals → Own independent `MealIngredient` copies
- Deleting item from library → No effect on meals
- Result: True data persistence ✅

This architectural change ensures meal ingredients are truly owned by each meal and will never be lost due to actions in other parts of the app.

