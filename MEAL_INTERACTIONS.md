# Meal Plan Interactions Guide

## 🎯 New Features Implemented

### 1. **Hide "Add Meal" Button at 5 Meals** ✅
When a user has already added 5 meals to a date, the "Add Another Meal" button is completely hidden.

**Logic:**
```swift
if scheduledMeals.count < 5 {
    // Show "Add Meal" button
}
// If 5 meals, button doesn't appear at all
```

**User Experience:**
- 0 meals: "Add Meal" button
- 1-4 meals: "Add Another Meal" button  
- 5 meals: No button (limit reached)

---

### 2. **Tap to View Meal Details** 👆
Users can tap any meal card in the meal plan to view full meal details.

**What Opens:**
- Full `MealDetailView` in a sheet
- Shows meal image, description, ingredients
- Has "Edit" button in toolbar (existing functionality)

**Gesture:**
```swift
MealCardView(meal: scheduledMeal.meal)
    .onTapGesture {
        showingMealDetail = scheduledMeal.meal
    }
```

---

### 3. **Swipe Actions** 👈

Users can swipe left on any meal card to reveal actions:

#### Swipe Actions (from right to left):
1. **Delete** (Red)
   - Removes meal from that date
   - Destructive action
   
2. **Change** (Orange)
   - Opens meal picker
   - Replace with different meal
   - Keeps same time slot

**Implementation:**
```swift
.swipeActions(edge: .trailing, allowsFullSwipe: false) {
    Button(role: .destructive) {
        // Delete meal
    } label: {
        Label("Delete", systemImage: "trash")
    }
    
    Button {
        // Show change meal sheet
    } label: {
        Label("Change", systemImage: "arrow.triangle.2.circlepath")
    }
    .tint(.orange)
}
```

---

### 4. **Context Menu** (Long Press) 📱

Long-pressing a meal card shows a context menu:

**Options:**
1. **Change Meal** - Replace with different meal
2. **Delete** - Remove meal (destructive/red)

**Why Both?**
- Swipe actions: Quick, iOS-native gestures
- Context menu: Discoverability, works on iPad

---

## 🔄 Change Meal Feature

### What It Does:
Replaces a scheduled meal with a different meal from your library.

### User Flow:

1. **Swipe left** on a meal card (or long-press)
2. Tap **"Change"**
3. Sheet opens showing **all available meals**
4. Current meal has **checkmark** (✓)
5. Tap a **different meal** to select it
6. Tap **"Change"** button
7. Meal is **replaced** on that date
8. Time slot is **preserved**

### Sheet UI:

```
┌─────────────────────────────┐
│  Cancel    Change Meal  Change│
├─────────────────────────────┤
│                             │
│  🌅 Scrambled Eggs      ✓   │ ← Current meal
│  ☀️ Chicken Salad           │
│  🌙 Spaghetti         ○     │ ← Selected
│  🥤 Smoothie Bowl           │
│                             │
└─────────────────────────────┘
```

**Features:**
- Shows all meals from library
- Current meal marked with ✓
- Selected meal marked with ○
- "Change" button disabled if same meal
- Saves automatically on confirm

---

## 🎨 Visual Design

### Meal Card Interactions:

**Normal State:**
```
┌─────────────────────────────┐
│ 🌅  Scrambled Eggs          │
│     Breakfast • 3 ingredients│
│                         [img]│
└─────────────────────────────┘
```

**Tap:**
→ Opens meal detail view in sheet

**Swipe Left:**
```
┌──────────────────┬─────┬─────┐
│ 🌅 Scrambled Eggs│Change│Delete│
│                  │ 🔄  │ 🗑️  │
└──────────────────┴─────┴─────┘
```

**Long Press:**
```
┌─────────────────────────────┐
│  🔄 Change Meal             │
│  🗑️ Delete                  │
└─────────────────────────────┘
```

---

## 📊 Complete Interaction Matrix

### On Meal Cards:

| Action | Gesture | Result |
|--------|---------|--------|
| **View** | Tap | Opens meal detail view |
| **Delete** | Swipe left → Red button | Removes meal |
| **Change** | Swipe left → Orange button | Opens change meal sheet |
| **Delete** | Long press → Delete | Removes meal |
| **Change** | Long press → Change Meal | Opens change meal sheet |

### On Add Meal Button:

| Scenario | Button State |
|----------|--------------|
| 0 meals | "Add Meal" |
| 1-4 meals | "Add Another Meal" |
| 5 meals | Hidden (no button) |
| Free user, 1+ meals | "Add Another Meal" 🔒 |
| Free user, day 8+ | "Add Meal" 🔒 |

---

## 💡 User Experience Improvements

### Before:
- ❌ Could add unlimited meals (even 10+)
- ❌ No way to view meal details from plan
- ❌ Only delete option was context menu
- ❌ No way to change a meal (had to delete + re-add)

### After:
- ✅ Max 5 meals per day (sensible limit)
- ✅ Tap to view full meal details
- ✅ Swipe for quick delete/change
- ✅ Context menu for discovery
- ✅ Dedicated "Change Meal" feature
- ✅ Clean UI when at max meals

---

## 🎯 Use Cases

### Scenario 1: Quick Edit
**User:** "I want to change Tuesday's lunch"
1. Swipe left on Tuesday lunch
2. Tap "Change"
3. Select different meal
4. Done! ✅

### Scenario 2: View Details
**User:** "What ingredients do I need for this meal?"
1. Tap the meal card
2. View full details
3. See all ingredients ✅

### Scenario 3: Remove a Meal
**User:** "I don't need breakfast that day"
1. Swipe left on breakfast meal
2. Tap "Delete"
3. Meal removed ✅

### Scenario 4: Planning 5 Meals
**User:** "I want to plan all 5 meals for Saturday"
1. Add breakfast → button changes to "Add Another Meal"
2. Add lunch → button still shows
3. Add dinner → button still shows
4. Add snack → button still shows
5. Add dessert → button disappears ✅
   (Max reached, clean UI)

---

## 🔧 Technical Implementation

### Components Created:

#### 1. **ChangeMealSheet**
New view component for changing meals.

**Props:**
- `scheduledMeal: ScheduledMeal` - The meal to replace
- `onMealChanged: (Meal) -> Void` - Callback when changed

**Features:**
- Query all meals from library
- Show current meal with checkmark
- Show selected meal with filled circle
- Disable "Change" if same meal
- Auto-save on confirm

#### 2. **Enhanced DayRowViewV2**

**New Properties:**
```swift
@State private var showingMealDetail: Meal?
@State private var showingChangeMeal: ScheduledMeal?
```

**New Methods:**
```swift
private func changeMeal(scheduledMeal: ScheduledMeal, to newMeal: Meal) {
    scheduledMeal.meal = newMeal
    try? modelContext.save()
}
```

---

## 🧪 Testing

### Test Checklist:

#### Add Meal Button:
- [ ] Shows "Add Meal" when 0 meals
- [ ] Shows "Add Another Meal" when 1-4 meals
- [ ] Hidden when 5 meals
- [ ] Shows lock icon for free users (2+ meals or day 8+)

#### Tap to View:
- [ ] Tap any meal → opens detail view
- [ ] Shows meal image, description, ingredients
- [ ] Has "Edit" button
- [ ] Can dismiss with swipe down

#### Swipe Actions:
- [ ] Swipe left shows Delete (red) and Change (orange)
- [ ] Delete removes meal
- [ ] Change opens meal picker

#### Context Menu:
- [ ] Long press shows menu
- [ ] "Change Meal" option
- [ ] "Delete" option (red)

#### Change Meal:
- [ ] Opens sheet with all meals
- [ ] Current meal marked with ✓
- [ ] Can select different meal (shows ○)
- [ ] "Change" button disabled for same meal
- [ ] Successfully replaces meal
- [ ] Change persists after app restart

---

## 📱 Accessibility

All interactions support:
- ✅ VoiceOver labels
- ✅ Large text
- ✅ Reduced motion (respects settings)
- ✅ Dark mode
- ✅ Color blind friendly (icons + text)

---

## 🚀 Future Enhancements

### Possible Additions:

1. **Reorder Meals**
   - Drag to reorder meals within a day
   - Custom meal time ordering

2. **Duplicate Meal**
   - Quick copy to another day
   - "Duplicate to tomorrow"

3. **Move Meal**
   - Drag meal to different day
   - Calendar drag-and-drop

4. **Meal Templates**
   - Save common meal patterns
   - "Monday Template" with all 5 meals

5. **Quick Actions**
   - 3D Touch on meal card
   - Quick view/delete/change

---

## ✅ Summary

**What Changed:**
- ✅ Button hides at 5 meals (clean UI)
- ✅ Tap opens meal details
- ✅ Swipe actions (delete + change)
- ✅ Context menu (long press)
- ✅ Change meal feature
- ✅ All actions save properly

**User Benefits:**
- 🎯 Cleaner UI when at max meals
- ⚡ Quick access to meal details
- 🔄 Easy to change meals without delete/re-add
- 👆 Multiple ways to interact (swipe, tap, long-press)
- 💾 All changes persist

The meal plan is now much more interactive and user-friendly! 🎉

