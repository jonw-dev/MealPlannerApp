# How to Fix the SwiftData Migration Error

## The Problem
You're getting this error:
```
Fatal error: Could not initialize ModelContainer: SwiftDataError(_error: SwiftData.SwiftDataError._Error.loadIssueModelContainer
```

This happens because we added two new fields to the models:
- `category` field to `Meal` model
- `mealTime` field to `ScheduledMeal` model

SwiftData can't automatically migrate the existing database.

---

## Quick Fix (Recommended for Development)

### Option 1: Delete the App from Simulator/Device

**For iOS Simulator:**
1. Stop the app in Xcode
2. In the Simulator, long-press the app icon
3. Click the "-" button to delete the app
4. Run the app again from Xcode

**For Physical Device:**
1. Stop the app in Xcode
2. Long-press the app icon on your device
3. Tap "Remove App" → "Delete App"
4. Run the app again from Xcode

**Command Line (to reset entire simulator):**
```bash
xcrun simctl erase all
```

This will create a fresh database with the new schema. ✅

---

## Advanced Fix (Keep Existing Data)

If you have important test data and want to keep it, you can implement proper versioned schema migration.

### Step 1: Create Versioned Schemas

Create a new file `ModelVersions.swift`:

```swift
import SwiftData
import Foundation

enum MealPlannerSchemaV1: VersionedSchema {
    static var versionIdentifier = Schema.Version(1, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Meal.self, ScheduledMeal.self, ShoppingItem.self, ShoppingListItem.self, MealPlanSettings.self]
    }
    
    @Model
    class Meal {
        var id: UUID
        var name: String
        var descriptionn: String
        var imageData: Data?
        @Relationship(deleteRule: .nullify) var ingredients: [ShoppingItem]
        
        init(name: String, descriptionn: String, imageData: Data? = nil, ingredients: [ShoppingItem] = []) {
            self.id = UUID()
            self.name = name
            self.descriptionn = descriptionn
            self.imageData = imageData
            self.ingredients = ingredients
        }
    }
    
    @Model
    class ScheduledMeal {
        var id: UUID
        var date: Date
        @Relationship var meal: Meal
        
        init(date: Date, meal: Meal) {
            self.id = UUID()
            self.date = date
            self.meal = meal
        }
    }
}

enum MealPlannerSchemaV2: VersionedSchema {
    static var versionIdentifier = Schema.Version(2, 0, 0)
    
    static var models: [any PersistentModel.Type] {
        [Meal.self, ScheduledMeal.self, ShoppingItem.self, ShoppingListItem.self, MealPlanSettings.self]
    }
    
    @Model
    class Meal {
        var id: UUID
        var name: String
        var descriptionn: String
        var imageData: Data?
        var category: String = "Other" // NEW FIELD
        @Relationship(deleteRule: .nullify) var ingredients: [ShoppingItem]
        
        init(name: String, descriptionn: String, imageData: Data? = nil, ingredients: [ShoppingItem] = [], category: String = "Other") {
            self.id = UUID()
            self.name = name
            self.descriptionn = descriptionn
            self.imageData = imageData
            self.ingredients = ingredients
            self.category = category
        }
    }
    
    @Model
    class ScheduledMeal {
        var id: UUID
        var date: Date
        var mealTime: Date = Date() // NEW FIELD
        @Relationship var meal: Meal
        
        init(date: Date, meal: Meal, mealTime: Date? = nil) {
            self.id = UUID()
            self.date = date
            self.mealTime = mealTime ?? date
            self.meal = meal
        }
    }
}

enum MealPlannerMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] {
        [MealPlannerSchemaV1.self, MealPlannerSchemaV2.self]
    }
    
    static var stages: [MigrationStage] {
        [migrateV1toV2]
    }
    
    static let migrateV1toV2 = MigrationStage.custom(
        fromVersion: MealPlannerSchemaV1.self,
        toVersion: MealPlannerSchemaV2.self,
        willMigrate: nil,
        didMigrate: { context in
            // Migrate meals to add default category
            let meals = try context.fetch(FetchDescriptor<MealPlannerSchemaV2.Meal>())
            for meal in meals {
                meal.category = "Other"
            }
            
            // Migrate scheduled meals to add mealTime
            let scheduledMeals = try context.fetch(FetchDescriptor<MealPlannerSchemaV2.ScheduledMeal>())
            for scheduledMeal in scheduledMeals {
                scheduledMeal.mealTime = scheduledMeal.date
            }
            
            try context.save()
        }
    )
}
```

### Step 2: Update MealPlannerApp.swift

Replace the ModelContainer initialization:

```swift
// Replace this:
modelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])

// With this:
modelContainer = try ModelContainer(
    for: MealPlannerSchemaV2.self,
    migrationPlan: MealPlannerMigrationPlan.self,
    configurations: [modelConfiguration]
)
```

---

## Recommended Approach

**For Now (Development Phase):**
- Use **Option 1** - just delete the app and reinstall
- It's faster and simpler while you're still building features
- Test data is easy to recreate

**Before Production Release:**
- Implement versioned schema if you already have users
- This preserves their data during updates
- Only necessary if the app is already published

---

## Prevention for Future

When adding new fields to SwiftData models in the future:

1. **Always add default values** to new fields:
   ```swift
   var category: String = "Other" // ✅ Has default
   ```

2. **Or make them optional:**
   ```swift
   var category: String? // ✅ Can be nil
   ```

3. **For development, delete the app** after schema changes

4. **For production, use VersionedSchema** to migrate user data

---

## Summary

**Quick Fix (Do this now):**
1. Delete the app from your simulator/device
2. Run it again from Xcode
3. Everything will work! ✅

The new schema will be created fresh with the new fields (`category` and `mealTime`).

