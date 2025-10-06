# RevenueCat Entitlement Setup Guide

## ⚠️ CRITICAL: You Must Set Up Entitlements

After making a purchase, if premium features aren't unlocking, it's because **entitlements aren't configured in RevenueCat**.

---

## What Are Entitlements?

Entitlements are the premium features your users get when they subscribe. In RevenueCat:
- **Products** = What users buy (weekly, monthly, annual subscriptions)
- **Entitlements** = What users get access to (premium features)

You need to link your products to entitlements!

---

## Step-by-Step Setup in RevenueCat Dashboard

### 1. Go to RevenueCat Dashboard
- Log in to [app.revenuecat.com](https://app.revenuecat.com)
- Select your project: **MealPlannerApp**

### 2. Create an Entitlement

1. In the left sidebar, click **"Entitlements"**
2. Click **"+ New"** button
3. **Entitlement identifier:** `premium` (must match what's in the code)
4. **Display name:** `Premium Features`
5. Click **"Add"**

### 3. Attach Products to the Entitlement

1. Click on your newly created **"premium"** entitlement
2. In the "Products" section, click **"Attach"**
3. Select ALL three of your products:
   - `01` (Annual - £19.99)
   - `02` (Monthly - £2.49)
   - `03` (Weekly - £0.79)
4. Click **"Save"**

### 4. Create an Offering (if not done already)

1. In the left sidebar, click **"Offerings"**
2. If you don't have a "default" offering:
   - Click **"+ New"**
   - **Identifier:** `default`
   - **Display name:** `Premium Subscription`
3. Click on your offering
4. Add packages:
   - Click **"+ Add Package"**
   - **Package Type:** Annual → **Product:** `01`
   - Click **"+ Add Package"**
   - **Package Type:** Monthly → **Product:** `02`
   - **Package Type:** Weekly → **Product:** `03`
5. Click **"Save"**

---

## Verification Steps

After setting up entitlements:

1. **Delete the app** from your test device/simulator
2. **Reinstall** from Xcode
3. **Make a test purchase** with your sandbox account
4. **Check the Xcode console** for these logs:

```
📊 === Customer Info Debug ===
📊 Active Subscriptions: ["01"]  // or "02" or "03"
📊 All Entitlements: ["premium"]
📊 Active Entitlements: ["premium"]
📊 Entitlement 'premium': isActive = true
✅ Premium Status: true
✅ Subscription: annual  // or monthly/weekly
📊 === End Debug ===
```

If you see:
- ✅ `Active Subscriptions: ["01"]` (or 02/03) - Good, purchase worked
- ❌ `Active Entitlements: []` - Entitlement NOT set up correctly
- ❌ `All Entitlements: []` - Entitlement NOT created or attached

---

## Common Issues

### Issue 1: Empty Entitlements After Purchase
**Problem:** Logs show active subscription but no entitlements
**Solution:** You forgot to attach products to the entitlement in RevenueCat dashboard

### Issue 2: "No packages available"
**Problem:** Paywall shows empty or "No subscriptions available"
**Solution:** You haven't created an offering or attached products to it

### Issue 3: Purchase succeeds but premium stays false
**Problem:** The entitlement identifier doesn't match
**Solution:** Ensure the entitlement is named exactly `premium` (lowercase)

---

## Quick Checklist

- [ ] Created entitlement with identifier `premium`
- [ ] Attached products 01, 02, 03 to the entitlement
- [ ] Created "default" offering
- [ ] Added all three packages to the offering
- [ ] Deleted and reinstalled app
- [ ] Made test purchase with sandbox account
- [ ] Verified logs show active entitlements

---

## Still Not Working?

If after following these steps it still doesn't work:

1. **Check the console logs** - Look for the debug output starting with 📊
2. **Copy the logs** and send them for debugging
3. **Verify in RevenueCat Dashboard:**
   - Go to **"Customers"**
   - Find your test user
   - Check if they have active entitlements listed

---

## Production Notes

Once everything is working, remember to:
1. Set `Purchases.logLevel = .error` (instead of `.debug`) in production
2. Test with TestFlight before releasing
3. Use real App Store subscriptions for final testing

