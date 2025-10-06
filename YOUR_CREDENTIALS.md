# Your RevenueCat Setup - Configured ✅

## 🔑 API Key (Configured)
```
appl_GlCsilbnFLPORgRaVDLFPcqWycm
```
✅ Added to: `MealPlannerApp.swift` line 20

---

## 📦 Product IDs (Configured)

| Subscription | Product ID | Price | Location in Code |
|--------------|------------|-------|------------------|
| **Annual** | `01` | £19.99 | Line 24 |
| **Monthly** | `02` | £2.49 | Line 23 |
| **Weekly** | `03` | £0.79 | Line 22 |

✅ Added to: `RevenueCatManager.swift` lines 22-24

---

## ⚠️ Important: RevenueCat Dashboard Setup

Make sure in your RevenueCat dashboard you have:

### **1. Products Created:**
- [ ] Product ID: `01` (Annual - £19.99)
- [ ] Product ID: `02` (Monthly - £2.49)
- [ ] Product ID: `03` (Weekly - £0.79)

Go to: **Products** tab → Add each product

---

### **2. Entitlement Created:**
- [ ] Identifier: `premium`
- [ ] Description: "Access to all premium features"

Go to: **Entitlements** tab → Create entitlement

---

### **3. Offering Created:**
- [ ] Identifier: `default`
- [ ] Status: ✅ **Current** (must be set as current!)

**Packages in offering:**
- [ ] Package 1: `$rc_annual` → Product `01` → Entitlement `premium`
- [ ] Package 2: `$rc_monthly` → Product `02` → Entitlement `premium`
- [ ] Package 3: `$rc_weekly` → Product `03` → Entitlement `premium`

Go to: **Offerings** tab → Create offering → Add packages → **Make Current**

---

## 🧪 Next: Add SDK and Test

### **Step 1: Add RevenueCat SDK (2 minutes)**
1. In Xcode: **File** → **Add Package Dependencies**
2. URL: `https://github.com/RevenueCat/purchases-ios`
3. Click **Add Package**
4. Select **"Purchases"** library
5. Click **Add Package**

### **Step 2: Build and Run**
1. Build the app (⌘B)
2. Run the app (⌘R)
3. Try to add 2nd meal → Paywall should appear! 🎉

### **Step 3: Test Purchase (with Sandbox)**
1. On device: **Settings** → **App Store** → **Sandbox Account**
2. Sign out of any existing account
3. In your app, try to purchase
4. Sign in with sandbox tester account
5. Complete purchase
6. Premium should unlock! ✅

---

## 🔍 Check Xcode Console

You should see:
```
✅ Premium Status: false
✅ Subscription: free
✅ Loaded offerings: 3 packages
```

After purchase:
```
✅ Purchase successful!
✅ Premium Status: true
✅ Subscription: annual (or monthly/weekly)
```

---

## 📋 Troubleshooting

**"No products available"**
→ Check RevenueCat dashboard has products with IDs: `01`, `02`, `03`
→ Check offering is marked as "Current"

**"Products not loading"**
→ Wait 24-48 hours for App Store Connect sync
→ Verify products are submitted for review in App Store Connect

**"Purchase not working"**
→ Make sure you're signed in with sandbox tester
→ Check entitlement identifier is exactly `premium`

---

## ✅ Configuration Complete!

Everything is configured in your code:
- ✅ API Key added
- ✅ Product IDs added
- ✅ Ready to add SDK and test

**Next step:** Add the RevenueCat SDK via Swift Package Manager! 🚀

