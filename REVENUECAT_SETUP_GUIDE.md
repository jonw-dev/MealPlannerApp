# RevenueCat Setup Guide for Meal Planner App

## 🎯 What is RevenueCat?

RevenueCat is a subscription platform that simplifies:
- ✅ In-app purchase management
- ✅ Subscription tracking across platforms
- ✅ Analytics and revenue metrics
- ✅ Server-side receipt validation
- ✅ Free trials and promo codes
- ✅ Cross-platform subscriptions (iOS + Android)

---

## 📋 Prerequisites

Before starting, you need:
1. ✅ Apple Developer Account ($99/year)
2. ✅ App Store Connect access
3. ✅ Your app created in App Store Connect
4. ✅ Bundle ID registered

---

## 🚀 Step-by-Step Setup

### **Step 1: Create RevenueCat Account**

1. Go to [https://www.revenuecat.com](https://www.revenuecat.com)
2. Click **"Sign Up Free"**
3. Create account with email
4. Verify your email

**Free Tier Includes:**
- Up to $10k monthly tracked revenue
- Unlimited app installs
- All core features

---

### **Step 2: Create Project in RevenueCat**

1. Log into RevenueCat dashboard
2. Click **"Create new project"**
3. Enter project details:
   - **Project Name:** "Meal Planner" (or your app name)
   - **Platform:** iOS
4. Click **"Create"**

5. You'll get an **API Key** (Public)
   - Example: `appl_xxxxxxxxxxxxxx`
   - **Save this!** You'll need it later

---

### **Step 3: Connect to App Store Connect**

1. In RevenueCat dashboard, go to **"Project Settings"** → **"Integrations"**
2. Click **"App Store Connect"**
3. You'll need to create an **App Store Connect API Key**:

#### Create App Store Connect API Key:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"Users and Access"**
3. Click **"Keys"** tab (under Integrations)
4. Click **"+"** to create new key
5. Fill in:
   - **Name:** "RevenueCat Integration"
   - **Access:** Select "Admin" or "App Manager"
6. Click **"Generate"**
7. **Download the .p8 file** (you can only do this once!)
8. Note the **Key ID** and **Issuer ID**

#### Connect to RevenueCat:

1. Back in RevenueCat dashboard
2. Enter:
   - **Issuer ID** (from App Store Connect)
   - **Key ID** (from App Store Connect)
   - **Private Key** (paste contents of .p8 file)
3. Click **"Save"**

---

### **Step 4: Create Products in App Store Connect**

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to **"Features"** → **"In-App Purchases"**
4. Click **"+"** to create new subscription

#### Create Monthly Subscription:

1. Click **"Auto-Renewable Subscription"**
2. Click **"Create"**
3. Fill in:
   - **Reference Name:** "Premium Monthly"
   - **Product ID:** `meal_planner_premium_monthly`
     - ⚠️ This is permanent, can't be changed!
   - **Subscription Group:** Create new → "Premium Subscription"
4. Click **"Create"**

5. **Add Subscription Duration:**
   - Duration: **1 month**
   - Price: **$4.99** (select your markets)

6. **Add Localizations:**
   - **Display Name:** "Premium Monthly"
   - **Description:** "Access to all premium features including multiple meals per day, extended planning, and export capabilities."

7. Click **"Save"**

#### Create Annual Subscription:

1. In same Subscription Group, click **"+"**
2. Fill in:
   - **Reference Name:** "Premium Annual"
   - **Product ID:** `meal_planner_premium_annual`
3. Duration: **1 year**
4. Price: **$39.99**
5. Display Name: "Premium Annual"
6. Description: "Full year of premium access. Save 33% compared to monthly!"
7. Click **"Save"**

#### Optional: Create Lifetime Purchase:

1. Click **"+"** → **"Non-Consumable"**
2. Fill in:
   - **Reference Name:** "Premium Lifetime"
   - **Product ID:** `meal_planner_premium_lifetime`
3. Price: **$79.99**
4. Display Name: "Premium Lifetime"
5. Description: "Pay once, premium forever!"
6. Click **"Save"**

#### Submit for Review:

- Click **"Submit for Review"** on each product
- Products must be approved before testing (usually 24-48 hours)
- You can still test in sandbox before approval

---

### **Step 5: Create Products in RevenueCat**

1. In RevenueCat dashboard, go to **"Products"**
2. Click **"+ New"**

#### Add Monthly Subscription:

1. **Product Identifier:** `meal_planner_premium_monthly`
   - Must match App Store Connect exactly!
2. **Type:** Subscription
3. **Store:** App Store
4. Click **"Save"**

#### Add Annual Subscription:

1. Click **"+ New"** again
2. **Product Identifier:** `meal_planner_premium_annual`
3. **Type:** Subscription
4. **Store:** App Store
5. Click **"Save"**

#### Add Lifetime (Optional):

1. Click **"+ New"**
2. **Product Identifier:** `meal_planner_premium_lifetime`
3. **Type:** Non-Subscription
4. **Store:** App Store
5. Click **"Save"**

---

### **Step 6: Create Entitlements**

Entitlements are what users get access to when they subscribe.

1. In RevenueCat dashboard, go to **"Entitlements"**
2. Click **"+ New"**
3. Create entitlement:
   - **Identifier:** `premium`
   - **Description:** "Access to all premium features"
4. Click **"Create"**

---

### **Step 7: Create Offerings**

Offerings are groups of products to show users (your paywall).

1. Go to **"Offerings"** in RevenueCat
2. Click **"+ New"**
3. Create offering:
   - **Identifier:** `default`
   - **Description:** "Default paywall offering"
4. Click **"Create"**

5. **Add Products to Offering:**
   - Click **"+ Add Package"**
   - Package 1:
     - **Identifier:** `$rc_annual` (special identifier)
     - **Product:** meal_planner_premium_annual
     - **Entitlement:** premium
   - Click **"Add Package"** again
   - Package 2:
     - **Identifier:** `$rc_monthly`
     - **Product:** meal_planner_premium_monthly
     - **Entitlement:** premium
   - Package 3 (Optional):
     - **Identifier:** `$rc_lifetime`
     - **Product:** meal_planner_premium_lifetime
     - **Entitlement:** premium

6. **Make it Current:**
   - Click **"Make Current"** on the offering

---

### **Step 8: Add RevenueCat SDK to Xcode**

#### Using Swift Package Manager:

1. Open your project in Xcode
2. Go to **File** → **Add Package Dependencies**
3. Enter URL: `https://github.com/RevenueCat/purchases-ios`
4. Click **"Add Package"**
5. Select **"Purchases"** library
6. Click **"Add Package"**

---

### **Step 9: Initialize RevenueCat in Your App**

I'll create the integration code for you:

```swift
// In your MealPlannerApp.swift, add import
import RevenueCat

// In init(), before modelContainer setup:
Purchases.logLevel = .debug  // Remove in production
Purchases.configure(withAPIKey: "YOUR_REVENUECAT_API_KEY")
```

---

### **Step 10: Create Sandbox Test Accounts**

To test purchases before going live:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Click **"Users and Access"**
3. Click **"Sandbox Testers"**
4. Click **"+"** to add tester
5. Fill in:
   - **Email:** test@yourdomain.com (can be fake)
   - **Password:** Create a secure password
   - **Country:** Your country
6. Click **"Invite"**

⚠️ **Important:** Never use your real Apple ID for testing!

---

## 📱 Integration Code

Now I'll create the code to integrate RevenueCat into your app...

### File Structure:
```
MealPlannerApp/
├── Models/
│   ├── RevenueCatManager.swift (NEW - replaces SubscriptionManager)
│   └── ...
└── ...
```

---

## 🧪 Testing

### Test in Sandbox:

1. Build and run your app
2. Go to **Settings** on iOS device/simulator
3. Scroll down to **App Store**
4. Tap **"Sandbox Account"**
5. Sign out of any existing account
6. Run your app
7. Try to purchase
8. Sign in with your **Sandbox Test Account**
9. Purchase should complete (won't be charged)
10. Check RevenueCat dashboard for the purchase

### Testing Checklist:

- [ ] Monthly subscription purchase works
- [ ] Annual subscription purchase works
- [ ] Lifetime purchase works (if implemented)
- [ ] Restore purchases works
- [ ] Premium features unlock after purchase
- [ ] Premium status persists after app restart
- [ ] RevenueCat dashboard shows the purchase

---

## 💰 Pricing Recommendations

Based on your app:

### Option 1: Aggressive Growth
- Monthly: $2.99
- Annual: $24.99 (save 30%)
- Lifetime: $49.99

### Option 2: Standard (Recommended)
- Monthly: $4.99
- Annual: $39.99 (save 33%)
- Lifetime: $79.99

### Option 3: Premium
- Monthly: $6.99
- Annual: $59.99 (save 28%)
- Lifetime: $99.99

**Consider:**
- 7-day free trial on annual plan
- Launch discount (50% off first year)
- Seasonal promotions

---

## 📊 Next Steps After Setup

1. **Implement the code** (I'll provide files next)
2. **Test with sandbox accounts**
3. **Submit products for review** (in App Store Connect)
4. **Wait for approval** (24-48 hours)
5. **Submit app for review** with subscriptions
6. **Launch!** 🚀

---

## 🆘 Common Issues

### "Products not found"
- Wait for App Store Connect products to sync (can take 24 hours)
- Check product IDs match exactly
- Make sure you're testing with sandbox account

### "Restore purchases doesn't work"
- Must be signed in with same Apple ID
- Sandbox account must have made a purchase
- Check RevenueCat dashboard for the user

### "Subscription not unlocking features"
- Check entitlement identifier matches in code
- Verify product is attached to entitlement in RevenueCat
- Check RevenueCat logs in Xcode console

---

## 💡 Pro Tips

1. **Use RevenueCat's built-in paywalls** (saves development time)
2. **Set up webhooks** for Slack notifications of new subscriptions
3. **Enable charts** in RevenueCat for revenue tracking
4. **Add promo codes** for influencers/reviewers
5. **Set up experiments** to test different pricing

---

## 📚 Resources

- [RevenueCat Documentation](https://docs.revenuecat.com)
- [Apple's In-App Purchase Guide](https://developer.apple.com/in-app-purchase/)
- [RevenueCat Sample Apps](https://github.com/RevenueCat/purchases-ios)

---

Ready for the code implementation? Let me know and I'll create:
1. ✅ RevenueCatManager.swift (replaces test SubscriptionManager)
2. ✅ Updated PaywallView.swift (with real purchases)
3. ✅ App initialization code
4. ✅ Restore purchases functionality

This will take about 10-15 minutes to set up in total! 🚀

