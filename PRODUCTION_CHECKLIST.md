# 🚀 Production Checklist for RevenueCat Purchases

## ✅ Changes Already Made
- **Debug logging** is now configured to only show in development builds
- Production builds will only log errors

---

## 🚨 YOUR CURRENT ISSUE: "Missing Metadata"

**Status:** Your products show "Missing Metadata" in App Store Connect.

**What this means:** Your products aren't complete yet and can't be submitted for review.

**Solution:** Follow the step-by-step guide in **`FIX_MISSING_METADATA.md`**

**Quick fix:**
1. Go to App Store Connect → Your App → In-App Purchases
2. For each product (01, 02, 03):
   - Add a **Display Name** (e.g., "Premium Annual")
   - Add a **Description** (e.g., "Access all premium features for one year")
   - Set **Price** (already done if you see £19.99, £2.49, £0.79)
   - Add at least one **Localization** (English)
3. Click **"Save"** on each product
4. Click **"Submit for Review"** on each product
5. Wait 24-48 hours for approval

**After fixing:** Products will change from "Missing Metadata" → "Ready to Submit" → "Waiting for Review" → "Approved"

See **`FIX_MISSING_METADATA.md`** for detailed instructions with copy/paste templates! 📋

---

## 🔍 Critical Production Requirements

### 1. **App Store Connect - Product Status** ⚠️ MOST COMMON ISSUE

Your products must be **APPROVED** before they work in production:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Navigate to **"Features"** → **"In-App Purchases"**
4. Check status of these products:
   - Product ID: `01` (Annual - £19.99)
   - Product ID: `02` (Monthly - £2.49)
   - Product ID: `03` (Weekly - £0.79)

**Required Status:** 
- ✅ "Approved" or "Ready to Submit"
- ❌ NOT "Waiting for Review"
- ❌ NOT "Rejected"

**Timeline:** Products take 24-48 hours to be approved after first submission.

**Note:** Even if your app is live, products must be separately approved!

---

### 2. **RevenueCat Dashboard Configuration**

Log into [RevenueCat Dashboard](https://app.revenuecat.com) and verify:

#### Products Tab:
- [ ] Product `01` exists and matches App Store Connect
- [ ] Product `02` exists and matches App Store Connect  
- [ ] Product `03` exists and matches App Store Connect
- [ ] All products show as "Synced" (green checkmark)

#### Entitlements Tab:
- [ ] Entitlement named `"premium"` (lowercase) exists
- [ ] All three products are attached to `"premium"` entitlement

#### Offerings Tab:
- [ ] An offering named `"default"` exists
- [ ] It is marked as **"Current"** (has a star icon)
- [ ] All three products are in the offering as packages
- [ ] Each package is linked to the `"premium"` entitlement

#### Project Settings → Integrations:
- [ ] App Store Connect integration is active (green)
- [ ] No sync errors are shown
- [ ] Last sync was recent (within 24 hours)

---

### 3. **Xcode Project Settings**

#### Bundle ID Must Match Everywhere:
1. **Xcode:** Select project → Target → General → Bundle Identifier
2. **App Store Connect:** App Information → General Information → Bundle ID
3. **RevenueCat:** Project Settings → App Information

⚠️ **They MUST be identical** or purchases will fail!

#### Capabilities:
- [ ] In-App Purchase capability is enabled
  - Xcode → Target → Signing & Capabilities → + Capability → In-App Purchase

---

### 4. **Testing Production Purchases**

**IMPORTANT:** Remove sandbox test account before testing production!

#### Steps to Test:
1. **On your physical device:**
   - Settings → App Store → Sandbox Account → Sign Out
   - Remove the app completely
   - Reinstall from TestFlight or App Store

2. **Make a test purchase:**
   - Use your REAL Apple ID (not sandbox)
   - Use a REAL payment method
   - Complete the purchase
   - Verify features unlock

3. **Request a refund (optional):**
   - Go to [reportaproblem.apple.com](https://reportaproblem.apple.com)
   - Find your test purchase
   - Request refund → "I have a question about using this app"
   - Apple typically approves refunds for test purchases

4. **Verify in RevenueCat Dashboard:**
   - Go to Customers tab
   - Search for your Apple ID or user ID
   - Verify purchase appears
   - Check that entitlement is active

---

## 🐛 Common Production Issues & Solutions

### Issue: "No products available" / Empty paywall

**Causes:**
1. Products not approved in App Store Connect (24-48 hour wait)
2. App Store Connect API integration not working in RevenueCat
3. Products not in "Current" offering in RevenueCat

**Solutions:**
1. Wait for product approval (check App Store Connect status)
2. Verify API integration in RevenueCat → Project Settings → Integrations
3. Make sure offering is marked as "Current"
4. Force refresh in RevenueCat: Products tab → click sync button

---

### Issue: Purchase fails with "Cannot connect to iTunes Store"

**Causes:**
1. Still signed into sandbox account on device
2. Bundle ID mismatch
3. App not approved/live yet

**Solutions:**
1. Settings → App Store → Sandbox Account → Sign Out
2. Verify Bundle IDs match everywhere
3. App must be approved or in TestFlight with approved products

---

### Issue: Purchase succeeds but features don't unlock

**Causes:**
1. Entitlement identifier mismatch (case-sensitive!)
2. Product not attached to entitlement in RevenueCat

**Debug Steps:**
1. Check Xcode console after purchase - look for:
   ```
   📊 === Customer Info Debug ===
   📊 Active Entitlements: [...]
   ```
2. Verify entitlement name in RevenueCat is exactly `"premium"` (lowercase)
3. In RevenueCat → Offerings → verify products are linked to `"premium"` entitlement

---

### Issue: "Restore purchases" finds nothing

**Causes:**
1. Different Apple ID than original purchase
2. Never actually completed a purchase
3. Purchase still processing

**Solutions:**
1. Must use same Apple ID that made the purchase
2. Check email for Apple receipt
3. Wait 5 minutes and try again
4. Check RevenueCat dashboard → Customers to verify purchase exists

---

## 📊 Monitoring Production Purchases

### RevenueCat Dashboard:
- **Overview:** Monitor daily revenue, active subscriptions, new subscribers
- **Charts:** View trends over time
- **Customers:** Search for specific users by Apple ID or user ID
- **Events:** See all purchase events in real-time

### Set Up Webhooks (Recommended):
1. RevenueCat → Project Settings → Integrations
2. Add Slack webhook to get notified of new subscriptions
3. Set up email alerts for churned subscribers

---

## 🔐 Security Best Practices

### API Keys:
- ✅ You're using the **Public** API key (starts with `appl_...`)
- ✅ This is safe to include in client-side code
- ⚠️ NEVER use the Secret API key in your app

### Receipt Validation:
- ✅ RevenueCat automatically validates all receipts server-side
- ✅ No additional code needed
- ✅ Prevents piracy and fraudulent purchases

---

## 📱 Final Pre-Launch Checklist

Before submitting to App Store:

- [ ] All products approved in App Store Connect
- [ ] Test purchase in production environment works
- [ ] Restore purchases works
- [ ] Premium features unlock correctly
- [ ] Debug logging disabled (already done ✅)
- [ ] RevenueCat dashboard shows test purchase
- [ ] App Store review information includes:
  - [ ] Demo account (if needed)
  - [ ] Notes about in-app purchases
  - [ ] Clear instructions for reviewers

---

## 🆘 Still Having Issues?

### Check RevenueCat Logs:
1. Make a purchase attempt
2. Copy logs from Xcode console
3. Look for error messages starting with `❌`
4. Check RevenueCat documentation for that specific error

### RevenueCat Support:
- [Documentation](https://docs.revenuecat.com)
- [Community Forum](https://community.revenuecat.com)
- Email: support@revenuecat.com (free tier gets email support!)

### Debug Information to Include:
When asking for help, provide:
1. Full error message from Xcode console
2. Product IDs from App Store Connect
3. Screenshot of RevenueCat offering configuration
4. Whether testing in sandbox or production
5. iOS version and device type

---

## 💡 Optimization Tips (Post-Launch)

### Pricing Experiments:
- Test different price points using RevenueCat Experiments
- A/B test offering displays (annual vs monthly first)
- Try limited-time discounts

### Conversion Optimization:
- Add trial periods (7-day free trial)
- Show paywall at strategic moments
- Add testimonials/reviews to paywall

### Analytics:
- Track which screens users visit before subscribing
- Monitor trial-to-paid conversion rate
- Watch for churn patterns

---

## 🎯 Quick Diagnosis

**Can't see products in the app?**
→ Products not approved OR offering not "Current" in RevenueCat

**Purchase button does nothing?**
→ Check Xcode console for errors, verify Bundle ID matches everywhere

**Purchase succeeds but features locked?**
→ Entitlement name mismatch (check it's exactly "premium" in RevenueCat)

**"Restore Purchases" doesn't work?**
→ Must use same Apple ID, purchase must be complete (not cancelled)

---

## Summary

The most common production issue is: **Products not approved in App Store Connect yet.**

If you submitted your products recently, wait 24-48 hours for approval, then test again!

Your code is configured correctly for production! 🚀

