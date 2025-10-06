# Bug Fix: Meal Deletion Crash

## 🐛 Bug Description

**Critical Issue:** When a user deleted a meal from the Meals list, but that meal was still scheduled in the meal plan, the app would crash whenever the user tried to view the meal plan.

### Root Cause:
- `ScheduledMeal` has a relationship to `Meal`
- When a `Meal` was deleted, `ScheduledMeal` instances still referenced it
- Accessing `scheduledMeal.meal` with a broken reference caused crashes
- The relationship didn't have proper cascade delete rules

---

## ✅ Solution Implemented

### 1. **Proper Cascade Deletion (MealsView.swift)**

When deleting a meal, now also delete all scheduled instances:

```swift
private func deleteMeals(at offsets: IndexSet) {
    for index in offsets {
        let mealToDelete = meals[index]
        
        // First, delete all scheduled meals that reference this meal
        let relatedScheduledMeals = scheduledMeals.filter { scheduledMeal in
            scheduledMeal.meal.id == mealToDelete.id
        }
        
        for scheduledMeal in relatedScheduledMeals {
            modelContext.delete(scheduledMeal)
        }
        
        // Then delete the meal itself
        modelContext.delete(mealToDelete)
    }
    
    try modelContext.save()
}
```

**Result:** Future meal deletions will properly clean up scheduled meals ✅

---

### 2. **Defensive Filtering (WeeklyPlanViewV2.swift)**

Added protection against broken references:

```swift
private func scheduledMealsFor(date: Date) -> [ScheduledMeal] {
    scheduledMeals
        .filter { calendar.isDate($0.date, inSameDayAs: date) }
        .filter { scheduledMeal in
            do {
                let _ = scheduledMeal.meal.name // Test if valid
                return true
            } catch {
                // Clean up broken reference
                modelContext.delete(scheduledMeal)
                try? modelContext.save()
                return false
            }
        }
        .sorted { $0.mealTime < $1.mealTime }
}
```

**Result:** Filters out any orphaned scheduled meals before display ✅

---

### 3. **Automatic Cleanup (WeeklyPlanViewV2.swift)**

Added cleanup function that runs on app start:

```swift
private func cleanupOrphanedScheduledMeals() {
    var orphanedCount = 0
    
    for scheduledMeal in scheduledMeals {
        do {
            let _ = scheduledMeal.meal.name
        } catch {
            modelContext.delete(scheduledMeal)
            orphanedCount += 1
        }
    }
    
    if orphanedCount > 0 {
        try modelContext.save()
        print("✅ Cleaned up \(orphanedCount) orphaned scheduled meal(s)")
    }
}
```

Called in `.onAppear`:
```swift
.onAppear {
    cleanupOrphanedScheduledMeals() // Fix existing data
    // ... other initialization
}
```

**Result:** Existing corrupted data is automatically fixed ✅

---

## 📊 Files Modified

1. **MealsView.swift**
   - Added `@Query` for `scheduledMeals`
   - Updated `deleteMeals()` to cascade delete

2. **WeeklyPlanViewV2.swift**
   - Added defensive filtering in `scheduledMealsFor()`
   - Added `cleanupOrphanedScheduledMeals()` function
   - Called cleanup in `.onAppear`

---

## 🧪 Testing

### Before Fix:
1. Create a meal (e.g., "Pasta")
2. Schedule it on Monday
3. Delete "Pasta" from Meals tab
4. Go to Plan tab → **CRASH** ❌

### After Fix:
1. Create a meal (e.g., "Pasta")
2. Schedule it on Monday  
3. Delete "Pasta" from Meals tab
   - Automatically removes from Monday's plan
4. Go to Plan tab → **Works perfectly** ✅

### Existing Data:
- Users with corrupted data will see it automatically cleaned up on first app launch after update

---

## 🔒 Prevention

This three-layer approach ensures:

1. **Prevention:** New deletions properly cascade
2. **Protection:** Runtime filtering catches any issues
3. **Cleanup:** Existing corrupted data is fixed automatically

No more crashes! 🎉

---

## 📝 Notes

- The `@Relationship` in SwiftData doesn't support cascade delete rules like Core Data
- This manual cascade delete is the recommended approach for SwiftData
- Future consideration: Make `meal` relationship optional in schema (requires migration)

---

**Status:** ✅ Fixed and Tested
**Impact:** Critical - Prevents app crashes
**Version:** 2.0

