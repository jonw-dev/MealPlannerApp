# Deep Linking & App-to-App Sharing

## 🎉 Overview

The app now supports **deep linking**, allowing users who share meal plans or shopping lists to have recipients open the shared content directly in the app if they have it installed.

---

## ✨ How It Works

### Sharing Flow:

1. **User A** shares a meal plan or shopping list
2. The app generates:
   - Human-readable text format
   - **Deep link URL** (e.g., `simplemeal://meal-plan?data=...`)
3. **User B** receives the message
4. If User B has the app installed:
   - They can tap the link
   - The app opens automatically
   - Import confirmation dialog appears
5. User B can import the content with one tap!

---

## 🔗 URL Scheme

### Custom URL Scheme: `simplemeal://`

#### Meal Plan Deep Links:
```
simplemeal://meal-plan?data=<base64_encoded_data>
```

#### Shopping List Deep Links:
```
simplemeal://shopping-list?data=<base64_encoded_data>
```

#### Individual Meal Deep Links:
```
simplemeal://meal?data=<base64_encoded_data>
```

---

## 📱 User Experience

### Sharing Side:

When users share content, they'll see:

```
🍽️ MY MEAL PLAN
═══════════════════════════════

📅 Monday, February 3, 2025
   🌅 Scrambled Eggs
   ☀️ Chicken Salad

...

═══════════════════════════════
Created with Meal Planner App 📱

📲 Open in Simple Meal:
simplemeal://meal-plan?data=eyJtZWFscyI6W3...

Don't have the app? Get it here:
https://apps.apple.com/gb/app/simplemealplannerapp/id6746522845
```

### Receiving Side:

When a user taps the link:

1. **App Opens Automatically**
2. **Import Dialog Appears:**
   ```
   Import Shared Content
   
   Import 5 meal(s) from a shared meal plan?
   
   [Import]  [Cancel]
   ```
3. **One-Tap Import:**
   - Meals/Items are added to their app
   - Existing data is preserved
   - New content is immediately visible

---

## 🛠️ Technical Implementation

### New Files:

#### `DeepLinkHandler.swift`
- Manages URL encoding/decoding
- Handles incoming deep links
- Imports data into SwiftData

**Key Methods:**
- `handleURL(_ url: URL) -> Bool` - Process incoming URLs
- `generateMealPlanURL(scheduledMeals:) -> URL?` - Create shareable links
- `generateShoppingListURL(items:) -> URL?` - Create shareable links
- `importMealPlan(_ data:, modelContext:)` - Import into database
- `importShoppingList(_ data:, modelContext:)` - Import into database

### Updated Files:

#### `project.pbxproj`
- Added `INFOPLIST_KEY_CFBundleURLTypes` with `simplemeal` scheme
- Registered in both Debug and Release configurations

#### `MealPlannerApp.swift`
- Added `@StateObject` for `DeepLinkHandler`
- Implemented `.onOpenURL()` modifier
- Added import confirmation alert
- Handles data import to SwiftData

#### `ShareManager.swift`
- New methods:
  - `shareMealPlanWithDeepLink()` - Share with deep link
  - `shareShoppingListWithDeepLink()` - Share with deep link
- Updated `shareText()` to accept optional deep link URL
- Automatically appends clickable link to shared text

#### `WeeklyPlanViewV2.swift`
- Updated sharing methods to use deep link functions
- Maintains backward compatibility

#### `ShopListView.swift`
- Updated sharing methods to use deep link functions
- Maintains backward compatibility

---

## 🔒 Data Format

### Meal Plan Data Structure:
```json
{
  "meals": [
    {
      "name": "Scrambled Eggs",
      "description": "Quick breakfast",
      "category": "breakfast",
      "ingredients": ["Eggs", "Butter", "Salt"],
      "date": 1738569600.0,
      "mealTime": 0
    }
  ],
  "dateRange": [1738569600.0, 1738656000.0]
}
```

### Shopping List Data Structure:
```json
{
  "items": [
    {
      "name": "Eggs",
      "category": "Dairy & Eggs",
      "count": 2
    }
  ]
}
```

### Individual Meal Data Structure:
```json
{
  "name": "Scrambled Eggs",
  "description": "Quick and easy breakfast",
  "category": "breakfast",
  "ingredients": ["Eggs", "Butter", "Salt", "Pepper"]
}
```

**Encoding:** JSON → Data → Base64 → URL Parameter

---

## 🎯 Benefits

### For Users:
✅ **Seamless sharing** - No manual data entry  
✅ **One-tap import** - Quick and easy  
✅ **Cross-device** - Share between iPhone/iPad  
✅ **Family planning** - Easy collaboration  
✅ **Recipe sharing** - Share individual meals with friends  
✅ **No account needed** - Works without login  
✅ **App Store fallback** - Non-users can download and import  

### For Development:
✅ **URL-based** - Platform standard  
✅ **No backend required** - All data in the link  
✅ **Privacy-first** - No data stored externally  
✅ **Offline-capable** - Works without internet  
✅ **Extensible** - Easy to add new content types  

---

## 📊 Sharing Options Comparison

| Format | Deep Link | Size | Use Case |
|--------|-----------|------|----------|
| Simple Text | ✅ Yes | Small | Quick share via Messages |
| Detailed Text | ✅ Yes | Medium | Share with non-users (human readable) |
| CSV Export | ❌ No | Small | Spreadsheets, backup |

**Note:** CSV format doesn't include deep links as it's meant for external tools.

---

## 🧪 Testing Deep Links

### Simulator Testing:

```bash
# Test meal plan import
xcrun simctl openurl booted "simplemeal://meal-plan?data=<your_data>"

# Test shopping list import
xcrun simctl openurl booted "simplemeal://shopping-list?data=<your_data>"
```

### Device Testing:

1. Share from Device A
2. Send via Messages to Device B
3. Tap the `simplemeal://` link on Device B
4. Confirm import dialog appears
5. Verify data imports correctly

### Edge Cases Handled:

✅ Invalid URLs - Gracefully ignored  
✅ Corrupted data - Shows error, doesn't crash  
✅ App not installed - Link shows as text  
✅ Duplicate imports - Adds as new entries  
✅ Large data sets - Base64 encoding handles it  

---

## 🚀 Future Enhancements

### Possible Additions:

1. **Universal Links** (HTTPS)
   - Use `https://simplemeal.app/share/...`
   - Works even if app not installed
   - Redirects to App Store

2. **QR Code Sharing**
   - Generate QR codes from deep links
   - Scan to import
   - Great for in-person sharing

3. **Collaborative Lists**
   - Real-time sync
   - Multiple users edit same list
   - Cloud-based storage

4. **Import Options**
   - Replace existing data
   - Merge with existing
   - Create new week/list

5. **Share Analytics**
   - Track share count (locally)
   - Popular meals
   - Sharing patterns

---

## 📝 Implementation Notes

### URL Size Limits:

- **Typical meal plan:** ~2-5KB encoded
- **Large meal plan (30 meals):** ~15KB encoded
- **Shopping list:** ~1-3KB encoded
- **iOS URL limit:** ~2MB (plenty of headroom)

### Base64 Encoding:

- Adds ~33% size overhead
- URL-safe encoding used
- Handles special characters
- Cross-platform compatible

### Data Validation:

- JSON decoding with error handling
- Malformed data gracefully rejected
- No crashes from invalid links
- User notified of import failures

---

## 🔐 Security & Privacy

### Privacy Protections:

✅ **No server storage** - Data only in the link  
✅ **No tracking** - No analytics on shares  
✅ **Local only** - All processing on-device  
✅ **User consent** - Import requires confirmation  
✅ **Transparent** - User sees what they're importing  

### Security Measures:

✅ **URL scheme validation** - Only accept `simplemeal://`  
✅ **Data validation** - Decode errors caught safely  
✅ **Sandboxed** - Can't access other apps' data  
✅ **No code execution** - Pure data, no scripts  

---

## 📱 Platform Support

- **iOS 18.0+** (matches app minimum)
- **iPhone** - Full support
- **iPad** - Full support
- **macOS Catalyst** - Compatible (if enabled)

---

## 🎨 UI/UX Highlights

### Import Alert:
- **Clear messaging** - Shows what will be imported
- **Item count** - "Import 5 meal(s)"
- **Easy actions** - Import or Cancel
- **Non-intrusive** - Doesn't interrupt workflow

### Share Text:
- **Readable format** - Human-friendly text
- **Clickable link** - Tappable deep link at bottom
- **App branding** - "Open in Simple Meal"
- **Multiple formats** - Simple or detailed options

---

## 💡 Tips for Users

### Best Practices:

1. **Share via Messages** - Best support for deep links
2. **Use simple format** - Faster, smaller messages
3. **Check before import** - Review item count
4. **Merge carefully** - Imports add to existing data
5. **Share regularly** - Great for weekly planning

### Troubleshooting:

**Q: Link doesn't open the app?**  
A: Make sure the app is installed and up to date

**Q: Import fails?**  
A: Link may be corrupted, ask sender to reshare

**Q: See duplicate data?**  
A: Imports add new entries, manually remove old ones

---

## 📚 Code Examples

### Generate a Deep Link:

```swift
// Meal Plan
if let url = DeepLinkHandler.generateMealPlanURL(scheduledMeals: meals) {
    print("Share this: \(url.absoluteString)")
}

// Shopping List
if let url = DeepLinkHandler.generateShoppingListURL(items: items) {
    print("Share this: \(url.absoluteString)")
}
```

### Handle Incoming Link:

```swift
.onOpenURL { url in
    let handler = DeepLinkHandler()
    if handler.handleURL(url) {
        // Show import dialog
    }
}
```

### Import Data:

```swift
switch importData {
case .mealPlan(let data):
    handler.importMealPlan(data, modelContext: context)
case .shoppingList(let data):
    handler.importShoppingList(data, modelContext: context)
}
```

---

## 📍 Where to Share From

### Meal Plans (WeeklyPlanViewV2):
- Share button in top toolbar
- Access via "Plan" tab
- Share entire week's meal plan

### Shopping Lists (ShopListView):
- Share button in top toolbar  
- Access via "Shop" tab
- Share current shopping list

### Individual Meals (MealsView):
- Share button in meal detail view
- Access via "Meals" tab → Select meal
- Share single recipe with ingredients

All sharing features require **Premium subscription**.

---

## 📄 Meal Sharing Example

When sharing an individual meal:

```
🍽️ SCRAMBLED EGGS
═══════════════════════════════

🌅 Breakfast

📝 Description:
Quick and easy breakfast recipe

🥘 Ingredients:
  • Eggs
  • Butter
  • Salt
  • Pepper

═══════════════════════════════
Shared from Simple Meal 📱

📲 Open in Simple Meal:
simplemeal://meal?data=eyJuYW1lI...

Don't have the app? Get it here:
https://apps.apple.com/gb/app/simplemealplannerapp/id6746522845
```

---

## ✅ Checklist

Implementation complete:

- [x] Custom URL scheme registered (`simplemeal://`)
- [x] Deep link handler utility created
- [x] URL encoding/decoding implemented
- [x] Import confirmation dialog added
- [x] ShareManager updated with deep link support
- [x] WeeklyPlanView integrated
- [x] ShopListView integrated
- [x] MealsView integrated (individual meal sharing)
- [x] Error handling implemented
- [x] User feedback on import
- [x] Premium feature gating
- [x] Documentation completed

---

**🎉 Deep linking is now live! Users can seamlessly share and import meal plans, shopping lists, and individual meals with just one tap!**

