# RevenueCat - Quick Start Guide

## 🚀 3 Steps to Get Running

### **1. Add SDK (2 minutes)**
Xcode → File → Add Package Dependencies
```
https://github.com/RevenueCat/purchases-ios
```

### **2. Add API Key (1 minute)**
In `MealPlannerApp.swift` line 21:
```swift
Purchases.configure(withAPIKey: "appl_YOUR_KEY_HERE")
```
Get key from: RevenueCat Dashboard → Project Settings → API Keys

### **3. Update Product IDs (1 minute)**
In `RevenueCatManager.swift` line 19-23:
```swift
enum ProductID: String {
    case weekly = "YOUR_WEEKLY_ID"    // £0.79
    case monthly = "YOUR_MONTHLY_ID"  // £2.49  
    case annual = "YOUR_ANNUAL_ID"    // £19.99
}
```

---

## ✅ Test Checklist

- [ ] SDK added to Xcode
- [ ] API key configured
- [ ] Product IDs updated
- [ ] Sandbox tester created
- [ ] Build and run
- [ ] Try to add 2nd meal → Paywall appears
- [ ] Purchase works
- [ ] Premium unlocks
- [ ] Restart app → Still premium

---

## 📋 Your Product IDs from App Store Connect

Weekly:  `_____________________________`

Monthly: `_____________________________`

Annual:  `_____________________________`

---

## 🆘 If Something's Wrong

**No products showing?**
→ Wait 24 hours for App Store sync
→ Check product IDs match exactly

**Purchase not working?**
→ Sign in with sandbox tester
→ Check offering is "Current" in RevenueCat

**Premium not unlocking?**
→ Check entitlement is called "premium"
→ Check Xcode console for errors

---

## 📖 Full Documentation

See `REVENUECAT_IMPLEMENTATION.md` for complete details.

---

**That's it! You're ready to go.** 🎉

