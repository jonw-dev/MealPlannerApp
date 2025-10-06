# Sharing Features Documentation

## 🎉 Overview

The app now includes comprehensive sharing functionality for both **Meal Plans** and **Shopping Lists**. This is a **Premium Feature** that requires a subscription.

---

## ✨ Features Implemented

### 1. **Meal Plan Sharing** 📅

Users can share their weekly meal plan in three different formats:

#### Share Options:

**a) Share as Text** (Simple)
```
🍽️ MY MEAL PLAN
═══════════════════════════════

📅 Monday, February 3, 2025
   🌅 Scrambled Eggs
   ☀️ Chicken Salad
   🌙 Spaghetti Bolognese

📅 Tuesday, February 4, 2025
   🌅 Oatmeal
   ☀️ Turkey Sandwich

...

═══════════════════════════════
Created with Meal Planner App 📱
```

**b) Share Detailed Version**
- Includes meal descriptions
- Lists all ingredients for each meal
- Perfect for sharing recipes with friends

```
🍽️ MY MEAL PLAN (DETAILED)
═══════════════════════════════

📅 Monday, February 3, 2025
───────────────────────────────
🌅 SCRAMBLED EGGS
   Quick and easy breakfast
   Ingredients:
   • Eggs
   • Butter
   • Salt
   • Pepper

☀️ CHICKEN SALAD
   Fresh and healthy lunch
   Ingredients:
   • Chicken Breast
   • Lettuce
   • Tomatoes
   ...
```

**c) Export as CSV**
- Spreadsheet format
- Columns: Date, Meal, Category, Description, Ingredients
- Perfect for importing into Excel or Google Sheets
- Filename: `meal-plan-2025-02-03.csv`

---

### 2. **Shopping List Sharing** 🛒

Users can share their shopping list in three formats:

#### Share Options:

**a) Share Simple List**
```
🛒 SHOPPING LIST

Produce:
• Tomatoes (x2)
• Lettuce
• Onions

Meat & Seafood:
• Chicken Breast
• Ground Beef (x2)

Dairy & Eggs:
• Milk
• Eggs (x2)
```

**b) Share Detailed List**
- Includes checkboxes
- Shows purchase progress
- Categories organized

```
🛒 MY SHOPPING LIST
═══════════════════════════════

📦 PRODUCE
───────────────────────────────
☐ Lettuce
☐ Onions
✅ Tomatoes (x2)

📦 MEAT & SEAFOOD
───────────────────────────────
☐ Chicken Breast
☐ Ground Beef (x2)

═══════════════════════════════
Progress: 2/7 items
Created with Meal Planner App 📱
```

**c) Export as CSV**
- Spreadsheet format
- Columns: Item, Category, Count, Purchased
- Filename: `shopping-list-2025-02-03.csv`

---

## 🔒 Premium Feature

### How It Works:

1. **Free Users:**
   - See share button in toolbar
   - Clicking it shows the paywall
   - Prompted to upgrade to Premium

2. **Premium Users:**
   - Full access to all sharing features
   - Can export unlimited times
   - All formats available

### Access Points:

#### Meal Plan View:
- Share button in top-right toolbar
- Icon: Share arrow (square.and.arrow.up)
- Shows when meals are scheduled

#### Shopping List View:
- Share button in top-right toolbar
- Icon: Share arrow (square.and.arrow.up)
- Disabled when list is empty

---

## 📱 User Experience

### Sharing Flow:

1. User taps **share button** in toolbar
2. **Premium check:**
   - If Premium → Show format options
   - If Free → Show paywall
3. User selects format:
   - Text (simple)
   - Text (detailed)
   - CSV file
4. iOS share sheet appears
5. User can:
   - Send via Messages/WhatsApp
   - Email
   - AirDrop
   - Copy to clipboard
   - Save to Files
   - Share to Notes
   - And more!

---

## 🛠️ Technical Implementation

### New Files Created:

#### `ShareManager.swift`
Central utility for all sharing functionality:

**Methods:**
- `generateMealPlanText()` - Simple text meal plan
- `generateDetailedMealPlanText()` - Detailed with ingredients
- `generateMealPlanCSV()` - Spreadsheet format
- `generateShoppingListText()` - Detailed list with checkboxes
- `generateSimpleShoppingListText()` - Basic list
- `generateShoppingListCSV()` - Spreadsheet format
- `shareText()` - Present share sheet for text
- `shareFile()` - Present share sheet for files

### Updated Files:

#### `WeeklyPlanViewV2.swift`
- Added share button to toolbar
- Premium check before sharing
- Three sharing methods
- Confirmation dialog for format selection

#### `ShopListView.swift`
- Added share button to toolbar
- Premium check before sharing
- Three sharing methods
- Confirmation dialog for format selection

#### `PaywallView.swift`
- Removed "Nutritional Tracking"
- Removed "Recipe Import"
- Updated "Export & Share" description

#### `SettingsView.swift`
- Removed nutritional tracking feature
- Updated to show "Export & Share Meal Plans"

---

## 📊 Export Formats

### Text Format
- **Pros:** Easy to read, instant share, works everywhere
- **Use case:** Quick sharing with family/friends
- **Share to:** Messages, WhatsApp, Email, Notes

### CSV Format
- **Pros:** Structured data, import to Excel/Sheets
- **Use case:** Data analysis, printing, backup
- **Share to:** Email, Files, Cloud storage

---

## 🎨 UI/UX Details

### Share Button:
- **Icon:** `square.and.arrow.up` (iOS standard share icon)
- **Color:** Primary theme color
- **Position:** Top-right toolbar
- **State:** Disabled when no content to share

### Confirmation Dialog:
- **Title:** "Share [Meal Plan/Shopping List]"
- **Message:** "Choose how you'd like to share..."
- **Options:** 3 format buttons + Cancel
- **Style:** iOS native action sheet

### Premium Paywall:
- Automatically shown if user is not premium
- Highlights "Export & Share" feature
- Clear upgrade path

---

## 💡 Future Enhancements

### Possible Additions:

1. **PDF Export** 📄
   - Beautiful formatted PDF
   - Include images
   - Professional layout

2. **Print Support** 🖨️
   - Direct print from app
   - Formatted for paper

3. **Templates** 📋
   - Different export styles
   - Customizable formats

4. **Email Templates** 📧
   - Pre-formatted email bodies
   - Automatic subject lines

5. **Calendar Export** 📆
   - Export to iOS Calendar
   - Add meals as events

6. **Reminders Integration** ✅
   - Export shopping list to Reminders app
   - Auto-organize by category

7. **QR Code Sharing** 📱
   - Generate QR code for meal plan
   - Quick scan and view

8. **Social Media Sharing** 📱
   - Formatted for Instagram Stories
   - Twitter-friendly format
   - Facebook post format

---

## 🧪 Testing

### How to Test:

1. **Enable Premium Mode:**
   - Go to Settings tab
   - Toggle "Premium Mode (Test)" ON

2. **Test Meal Plan Sharing:**
   - Go to Meal Plan tab
   - Add at least one meal
   - Tap share button (top-right)
   - Select a format
   - Verify share sheet appears

3. **Test Shopping List Sharing:**
   - Go to Shopping tab
   - Add items or generate from meal plan
   - Tap share button (top-right)
   - Select a format
   - Verify share sheet appears

4. **Test Free User Flow:**
   - Go to Settings
   - Toggle Premium OFF
   - Try to share
   - Verify paywall appears

---

## 📝 Sample Outputs

### Meal Plan CSV Example:
```csv
Date,Meal,Category,Description,Ingredients
"2025-02-03","Scrambled Eggs","Breakfast","Quick breakfast","Eggs; Butter; Salt"
"2025-02-03","Chicken Salad","Lunch","Healthy lunch","Chicken; Lettuce; Tomatoes"
```

### Shopping List CSV Example:
```csv
Item,Category,Count,Purchased
"Tomatoes","Produce",2,No
"Chicken Breast","Meat & Seafood",1,No
"Milk","Dairy & Eggs",1,Yes
```

---

## 🎯 Marketing Copy

### Feature Description (App Store):
"Share your meal plans and shopping lists with family and friends! Export as text or spreadsheet format. Perfect for coordinating family meals or sharing favorite recipes."

### In-App Promotion:
"💫 Share your meal plans with loved ones! Upgrade to Premium to export and share in multiple formats."

---

## ⚙️ Configuration

### ShareManager Settings:

All text includes:
- Emoji icons for visual appeal
- Clear formatting
- App branding footer
- Date/category organization

### File Naming:
- Meal Plans: `meal-plan-YYYY-MM-DD.csv`
- Shopping Lists: `shopping-list-YYYY-MM-DD.csv`

---

## ✅ Summary

**Implemented Features:**
- ✅ Meal plan text sharing (simple)
- ✅ Meal plan text sharing (detailed with ingredients)
- ✅ Meal plan CSV export
- ✅ Shopping list text sharing (simple)
- ✅ Shopping list text sharing (detailed with checkboxes)
- ✅ Shopping list CSV export
- ✅ Premium feature gating
- ✅ iOS native share sheet
- ✅ Automatic file naming with dates
- ✅ Category organization
- ✅ Progress tracking in shopping lists
- ✅ Meal category icons in exports

**Premium Integration:**
- ✅ Share button in toolbars
- ✅ Premium check before sharing
- ✅ Paywall for free users
- ✅ Updated feature lists
- ✅ Settings display

**User Experience:**
- ✅ Native iOS patterns
- ✅ Clear format options
- ✅ Confirmation dialogs
- ✅ Disabled states for empty content
- ✅ Professional formatting

The sharing feature is fully functional and ready to use! 🎉

