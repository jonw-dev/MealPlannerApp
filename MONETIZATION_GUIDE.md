# Meal Planner App - Monetization Guide

## 🎯 Overview
This app now includes a freemium subscription model with the core premium feature being **multiple meals per day**.

---

## 💰 Pricing Strategy

### Free Tier
- 1 meal per day
- 7-day meal planning
- Basic shopping list generation
- Full ingredient library
- View and edit meal details

### Premium Subscription

#### Monthly: $4.99/month
- All features unlocked
- Auto-renewing subscription

#### Annual: $39.99/year (Save 33%)
- Best value
- Equivalent to $3.33/month

#### Lifetime: $79.99 (One-time)
- Pay once, own forever
- Best for committed users

---

## ✨ Premium Features

### 1. **Multiple Meals Per Day** (CORE FEATURE)
- Add up to 5 meals per day
- Perfect for breakfast, lunch, dinner, snacks, desserts
- Free users limited to 1 meal per day
- **Implementation:** When user tries to add a 2nd meal, paywall appears

### 2. **Meal Categories** (Implemented)
- Tag meals as: Breakfast, Lunch, Dinner, Snack, Dessert, Other
- Each category has unique icon
- Better organization and planning

### 3. **Extended Planning** (Suggested - Not Yet Implemented)
- Free: 7 days
- Premium: 14, 21, or 30 days
- Better for advanced planners

### 4. **Future Premium Features to Implement**
- Nutritional tracking (calories, macros)
- Recipe import from URLs/photos
- Family/household profiles
- Smart shopping suggestions
- Meal history & favorites
- Export to PDF/other apps
- Recipe scaling
- Meal notes and ratings
- Cloud sync across devices

---

## 🏗️ Implementation Details

### New Files Created

1. **`SubscriptionManager.swift`**
   - Manages subscription state
   - Contains test mode for development
   - Will integrate with StoreKit 2 for production
   - Key methods:
     - `checkSubscription()` - Validates subscription status
     - `canAddMultipleMeals()` - Checks if user can add more meals
     - `enablePremiumForTesting()` - Test mode only
     - `disablePremiumForTesting()` - Test mode only

2. **`PaywallView.swift`**
   - Beautiful, professional paywall UI
   - Shows all premium features
   - Three pricing tiers
   - Test mode for development

3. **`WeeklyPlanViewV2.swift`**
   - Updated meal planning view
   - Supports multiple meals per day
   - Shows meal categories with icons
   - Integrates paywall when user hits limit
   - Better visual design

4. **`SettingsView.swift`**
   - New Settings tab
   - Shows subscription status
   - Lists premium features
   - Toggle premium mode (test mode only)
   - Links to privacy/terms

### Modified Files

1. **`Models.swift`**
   - Added `MealCategory` enum with icons
   - Updated `Meal` model to include category
   - Updated `ScheduledMeal` to support multiple meals per day with `mealTime` field

2. **`AddMealView.swift`**
   - Added category picker
   - Now saves meal category

3. **`MainTabView.swift`**
   - Added Settings tab with badge
   - Switched to `WeeklyPlanViewV2`
   - Loads subscription status on appear

---

## 🧪 Testing the Monetization

### Test Mode (Current State)

The app is in **TEST MODE** for easy development and testing:

1. Open the app and go to **Settings** tab
2. You'll see "Developer Options" section
3. Toggle "Premium Mode (Test)" ON/OFF
4. This simulates premium subscription without real payments

### How to Test Premium Features

#### Test Free Tier:
1. Go to Settings
2. Turn OFF "Premium Mode"
3. Go to Meal Plan tab
4. Add 1 meal to any day ✅
5. Try to add a 2nd meal → **Paywall appears** ✅

#### Test Premium Tier:
1. Go to Settings
2. Turn ON "Premium Mode"
3. Go to Meal Plan tab
4. Add multiple meals to same day (up to 5) ✅
5. No paywall appears ✅

---

## 🚀 Production Setup (Before Release)

### Step 1: Set Up App Store Connect

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to **Features** → **In-App Purchases**
4. Create three new subscriptions:

**Auto-Renewable Subscriptions:**
- Product ID: `com.yourapp.mealplanner.premium.monthly`
  - Price: $4.99
  - Duration: 1 month
  
- Product ID: `com.yourapp.mealplanner.premium.annual`
  - Price: $39.99
  - Duration: 1 year
  
**Non-Consumable Purchase:**
- Product ID: `com.yourapp.mealplanner.premium.lifetime`
  - Price: $79.99

### Step 2: Update Product IDs

In `SubscriptionManager.swift`, update the product IDs to match your App Store Connect products:

```swift
enum ProductID: String {
    case monthly = "com.yourapp.mealplanner.premium.monthly"
    case annual = "com.yourapp.mealplanner.premium.annual"
    case lifetime = "com.yourapp.mealplanner.premium.lifetime"
}
```

### Step 3: Implement StoreKit 2

In `SubscriptionManager.swift`, uncomment and complete the StoreKit implementation in:
- `checkSubscription()` method
- `PaywallView.swift` → `handleSubscribe()` method

### Step 4: Remove Test Mode

1. Set `isTestMode = false` in `SubscriptionManager.swift`
2. Remove the "Developer Options" section from `SettingsView.swift`

### Step 5: Add Privacy & Terms Pages

Update the URLs in `SettingsView.swift`:
```swift
Link(destination: URL(string: "https://yourwebsite.com/privacy")!)
Link(destination: URL(string: "https://yourwebsite.com/terms")!)
```

### Step 6: Test with TestFlight

1. Build and upload to TestFlight
2. Add test users
3. Test actual purchases with sandbox accounts
4. Verify subscription states

---

## 📊 Analytics to Track

Consider adding analytics to track:
- Paywall impressions
- Paywall conversion rate
- Which pricing tier users choose
- Feature usage (free vs premium)
- Churn rate
- Upgrade triggers (which feature drives conversions)

**Suggested Tools:**
- RevenueCat (handles subscriptions + analytics)
- Mixpanel or Amplitude (user behavior)
- Apple's StoreKit Analytics

---

## 🎨 Marketing Suggestions

### In-App Marketing
1. **Onboarding:** Show premium features during first-time setup
2. **Strategic Prompts:** After user creates 5+ meals, prompt upgrade
3. **Feature Discovery:** Highlight locked premium features with subtle badges
4. **Social Proof:** "Join 10,000+ premium users"

### App Store Optimization
- Screenshots showing multiple meals per day
- Highlight meal categories and organization
- Show the beautiful UI
- Emphasize time-saving benefits

### Pricing Psychology
- Annual plan shows "Save 33%" badge
- Lifetime presented as "Best Value"
- Free trial options (7-day free trial on annual)

---

## 🔄 Migration Path for Existing Users

If you already have users:
1. All existing features remain free
2. New "multiple meals" feature is premium-only
3. Consider giving early adopters a discount code
4. Grandfather existing power users with lifetime free premium

---

## 📈 Future Revenue Streams

1. **Recipe Partnerships:** Affiliate links to ingredient delivery services
2. **White Label:** License app to meal prep companies
3. **B2B:** Sell to nutritionists, dietitians, meal prep businesses
4. **Sponsored Meals:** Partner with food brands for featured meals
5. **Meal Plan Marketplace:** Let users buy/sell meal plans

---

## 💡 Additional Premium Features (Easy Wins)

### Quick to Implement:
1. **Custom Themes** - Let users change app colors
2. **Meal Templates** - Quick-add common meal plans
3. **Duplicate Week** - Copy last week's plan
4. **Meal Rotation** - Auto-rotate favorite meals
5. **Smart Notifications** - Cooking reminders

### Medium Effort:
1. **Recipe Scraper** - Import from websites
2. **Barcode Scanner** - Scan products to add
3. **Serving Size Calculator** - Scale recipes
4. **Shopping List Export** - To Reminders app
5. **Calendar Integration** - Sync with iOS Calendar

---

## 🎯 Success Metrics to Watch

- **Conversion Rate:** Target 2-5% of free users → paid
- **Monthly Recurring Revenue (MRR)**
- **Customer Lifetime Value (LTV)**
- **Churn Rate:** Target <5% monthly
- **Average Revenue Per User (ARPU)**

---

## ⚠️ Important Notes

### Before Release:
- [ ] Replace test mode with real StoreKit implementation
- [ ] Update product IDs to match App Store Connect
- [ ] Remove developer test toggles
- [ ] Add privacy policy and terms
- [ ] Test all purchase flows with sandbox
- [ ] Add receipt validation
- [ ] Implement restore purchases
- [ ] Handle failed transactions gracefully
- [ ] Add loading states for purchases

### Legal Requirements:
- Must have restore purchases button
- Clear pricing information
- Cancellation instructions
- Privacy policy and terms of service
- Comply with App Store Review Guidelines

---

## 🎉 Summary

You now have a fully functional freemium app with:
- ✅ Beautiful paywall
- ✅ Multiple meals per day (premium)
- ✅ Meal categories
- ✅ Test mode for development
- ✅ Settings management
- ✅ Upgrade prompts at right moments
- ✅ Professional UI/UX

The app is ready for testing and can be connected to real App Store subscriptions when you're ready to launch!

---

**Need Help?**
- Apple's StoreKit Documentation: https://developer.apple.com/storekit/
- RevenueCat (simplified subscriptions): https://www.revenuecat.com/
- App Store Review Guidelines: https://developer.apple.com/app-store/review/guidelines/

