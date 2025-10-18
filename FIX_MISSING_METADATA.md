# 🛠️ Fix "Missing Metadata" for In-App Purchases

## The Problem
Your products show "Missing Metadata" in App Store Connect, which means they're not complete and can't be submitted for review yet.

---

## ✅ Step-by-Step Fix

### **Step 1: Complete Product Information**

For **EACH** of your three products (`01`, `02`, `03`), you need to add metadata:

1. Go to [App Store Connect](https://appstoreconnect.apple.com)
2. Select your app
3. Go to **"Features"** → **"In-App Purchases"**
4. Click on each product (one at a time)

---

### **Step 2: Add Required Metadata**

For each product, you need to fill in:

#### **Product 01 - Annual Subscription (£19.99)**

##### A. Subscription Information
- **Reference Name:** `Premium Annual Subscription`
  - This is only visible to you, not customers
- **Product ID:** `01` (already set, can't change)

##### B. Subscription Duration
- **Duration:** `1 year`

##### C. Subscription Prices
- **Price:** £19.99 (or equivalent in other currencies)
- Make sure at least one country/region is selected

##### D. App Store Localization (REQUIRED)
You need at least ONE localization. Click **"Add Localization"**:

**For English (UK) or English (US):**
- **Subscription Display Name:** `Premium Annual`
  - This is what customers see in the App Store
  - Keep it short and clear (max 30 characters)

- **Description:**
  ```
  Get full access to all premium features for one year. Plan unlimited meals, add multiple meals per day, and export your shopping lists. Best value - save over 60% compared to monthly!
  ```
  - This explains what the subscription includes
  - Max 75 characters for auto-renewable subscriptions

##### E. App Store Promotion (Optional but Recommended)
- **Promotional Image:** 
  - Size: 1024x1024 pixels
  - Can skip this initially, add later
  - If you don't have one, you can skip and submit without it

---

#### **Product 02 - Monthly Subscription (£2.49)**

##### A. Subscription Information
- **Reference Name:** `Premium Monthly Subscription`
- **Product ID:** `02` (already set)

##### B. Subscription Duration
- **Duration:** `1 month`

##### C. Subscription Prices
- **Price:** £2.49

##### D. App Store Localization
Click **"Add Localization"** → English:

- **Subscription Display Name:** `Premium Monthly`

- **Description:**
  ```
  Access all premium features with a flexible monthly subscription. Plan unlimited meals and add multiple meals per day. Cancel anytime.
  ```

---

#### **Product 03 - Weekly Subscription (£0.79)**

##### A. Subscription Information
- **Reference Name:** `Premium Weekly Subscription`
- **Product ID:** `03` (already set)

##### B. Subscription Duration
- **Duration:** `1 week`

##### C. Subscription Prices
- **Price:** £0.79

##### D. App Store Localization
Click **"Add Localization"** → English:

- **Subscription Display Name:** `Premium Weekly`

- **Description:**
  ```
  Try premium features for one week. Perfect for testing meal planning with unlimited access. Automatically renews weekly.
  ```

---

### **Step 3: Subscription Group Information**

All three subscriptions should be in the same **Subscription Group**.

1. Go to the Subscription Group page
2. Click **"Add Localization"** for the group itself

**Group Display Name:** `Premium Subscription`

---

### **Step 4: Review Information (For App Submission)**

When you submit your app for review, you'll need to provide:

1. **Screenshot or Video** showing the subscription in your app
   - Take a screenshot of your paywall screen

2. **Review Notes:**
   ```
   Our app offers three subscription tiers:
   - Weekly (£0.79): Trial option for new users
   - Monthly (£2.49): Most popular flexible option  
   - Annual (£19.99): Best value with over 60% savings
   
   Premium features include:
   - Plan meals up to 30 days ahead (vs 7 days free)
   - Add up to 5 meals per day (vs 1 meal free)
   - Share meal plans with family
   - Export shopping lists
   
   All subscriptions auto-renew and can be cancelled anytime in iOS Settings.
   ```

---

## 🎯 Quick Metadata Template

Copy and paste these for quick setup:

### Annual (01)
```
Display Name: Premium Annual
Description: Get full access to all premium features for one year. Plan unlimited meals, add multiple meals per day, and export your shopping lists. Best value - save over 60%!
```

### Monthly (02)
```
Display Name: Premium Monthly  
Description: Access all premium features with a flexible monthly subscription. Plan unlimited meals and add multiple meals per day. Cancel anytime.
```

### Weekly (03)
```
Display Name: Premium Weekly
Description: Try premium features for one week. Perfect for testing meal planning with unlimited access. Automatically renews weekly.
```

---

## ⚠️ Important Notes

### Character Limits:
- **Display Name:** Max 30 characters (keep it short!)
- **Description:** Max 75 characters for auto-renewable subscriptions
- If you go over, you'll get an error when saving

### Required vs Optional:
**REQUIRED to submit for review:**
- ✅ At least one localization (display name + description)
- ✅ Price set
- ✅ Duration set
- ✅ Subscription group assigned

**OPTIONAL (can add later):**
- Promotional image (1024x1024px)
- Additional localizations for other languages
- Family sharing settings

### After Adding Metadata:

1. Click **"Save"** for each product
2. The "Missing Metadata" warning should disappear
3. Status should change to **"Ready to Submit"**
4. Click **"Submit for Review"** on each product
5. Wait 24-48 hours for Apple to review

---

## 🚀 Submit Products for Review

Once all metadata is added:

1. Each product should show **"Ready to Submit"**
2. Click **"Submit for Review"** button on each one
3. You'll submit all three at once when you submit your app

**Timeline:**
- Submission → Review: 24-48 hours
- After approval: Products work in production
- During review: Products still work in sandbox testing

---

## 🐛 Common Issues

### "Description too long"
- Auto-renewable subscriptions: max 75 characters
- Try shorter, punchier descriptions
- Focus on key benefits only

### "Must add localization"
- You need at least ONE language
- English (UK) or English (US) is fine to start
- Can add more languages later

### "Price not set"
- Must select at least one country/region
- UK is required if you have a UK bundle ID
- Can add more regions later

### "Subscription group required"
- All three products must be in the same group
- Create group first if it doesn't exist
- Then assign products to it

---

## ✅ Checklist

After completing the above:

- [ ] Product 01 (Annual) has display name and description
- [ ] Product 02 (Monthly) has display name and description  
- [ ] Product 03 (Weekly) has display name and description
- [ ] All three have prices set
- [ ] All three are in the same subscription group
- [ ] No more "Missing Metadata" warnings
- [ ] All show "Ready to Submit"
- [ ] Clicked "Submit for Review" on each product

---

## 📱 What Happens Next?

1. **Immediate:** Status changes to "Waiting for Review"
2. **24-48 hours:** Apple reviews products
3. **After approval:** Status changes to "Approved"
4. **Products work in production!** 🎉

You can continue sandbox testing while waiting for approval.

---

## 🆘 Need Help?

If you're stuck on any field, here's what matters most to customers:

**Display Name = Short & Clear**
- "Premium Annual" ✅
- "Annual Premium Subscription Plan" ❌ (too long)

**Description = Benefits**
- "Save 60% with unlimited meal planning" ✅
- "This is our annual subscription product" ❌ (not helpful)

Keep it simple and benefit-focused! 🚀

