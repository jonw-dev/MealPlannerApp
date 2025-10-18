# 📱 Attach Subscriptions to App Version

## The Message You're Seeing

> "Your first subscription must be submitted with a new app version. Create your subscription, then select it from the app's In-App Purchases and Subscriptions section on the version page before submitting the version to App Review."

## What This Means

✅ Your products are ready (metadata is complete)  
✅ But they need to be **linked to an app version** before Apple will review them  
⚠️ This is a **required step** for first-time subscriptions

---

## 🚀 Step-by-Step Solution

### **Step 1: Go to Your App Version**

1. Log into [App Store Connect](https://appstoreconnect.apple.com)
2. Click on **"My Apps"**
3. Select your **Meal Planner App**
4. Click the **"App Store"** tab at the top (not "Features")
5. You should see your app version (e.g., "1.0", "1.1", "2.0")

**Important:** 
- If you see "iOS App" in the left sidebar, click it
- You're looking for the version that's either:
  - **"Prepare for Submission"** (new version)
  - **"Ready for Review"**
  - **"Pending Developer Release"**
  - Or create a new version if needed

---

### **Step 2: Find In-App Purchases and Subscriptions Section**

In your app version page, scroll down until you see:

**"In-App Purchases and Subscriptions"**

This section might show:
- "No in-app purchases or subscriptions added"
- Or a list of products if you've already added some

---

### **Step 3: Add Your Subscriptions**

1. In the "In-App Purchases and Subscriptions" section, click the **"+"** button (or "Add" link)

2. You'll see a list of available products. **Select all three**:
   - ☑️ Product 01 - Premium Annual (£19.99)
   - ☑️ Product 02 - Premium Monthly (£2.49)  
   - ☑️ Product 03 - Premium Weekly (£0.79)

3. Click **"Done"** or **"Add"**

4. All three subscriptions should now appear in the list

---

### **Step 4: Save Changes**

1. Scroll to the top of the page
2. Click **"Save"** (top right)
3. The subscriptions are now linked to your app version! ✅

---

### **Step 5: Submit for Review**

Now you can submit your app version:

1. Make sure all required fields are complete:
   - App description
   - Screenshots
   - Privacy policy URL (if required)
   - Age rating
   - etc.

2. Scroll to the bottom
3. Click **"Add for Review"** or **"Submit for Review"**

4. In the submission flow:
   - You'll see your 3 subscriptions listed
   - They'll be reviewed along with your app
   - Answer any questions about subscriptions

5. Click **"Submit"** to send to Apple

---

## 📊 What Happens After Submission

### During Review (24-48 hours):
- App status: "In Review"
- Subscription status: "Waiting for Review"
- You can still test in sandbox mode

### After Approval:
- App status: "Ready for Sale" or "Pending Developer Release"
- Subscription status: "Approved"
- **Subscriptions now work in production!** 🎉

---

## ⚠️ Common Issues

### "I don't see a version to add subscriptions to"

**Solution:** You need to create a new app version:

1. In the "App Store" tab
2. Click **"+ Version or Platform"** (top left)
3. Select **"iOS"**
4. Enter new version number (e.g., if you're on 1.0, create 1.1)
5. Fill in "What's New in This Version" (mention subscription features!)
6. Now follow steps 2-5 above

**What's New text example:**
```
New in this version:
• Introduced Premium Subscriptions with exclusive features
• Plan up to 30 days ahead (Premium)
• Add up to 5 meals per day (Premium)
• Share meal plans with family (Premium)
• Export shopping lists (Premium)
• Bug fixes and performance improvements
```

---

### "Subscriptions show but I can't add them"

**Possible reasons:**
1. Products still show "Missing Metadata" → Go back and complete them
2. Products show "Rejected" → Fix issues and resubmit
3. Wrong app record → Make sure you're in the correct app

**Solution:** Check product status in Features → In-App Purchases

---

### "Do I need to upload a new build?"

**It depends:**

**If adding subscriptions to existing app:**
- ✅ YES - You need a new build with RevenueCat integrated
- Upload via Xcode or Transporter
- Select the new build in App Store Connect
- Then add subscriptions to that version

**If this is your first submission:**
- ✅ Already have a build ready → Just add subscriptions
- ❌ No build yet → Upload one first, then add subscriptions

---

## 🎯 Quick Checklist

Before submitting:

- [ ] All 3 subscription products have complete metadata
- [ ] All 3 products show "Ready to Submit" (not "Missing Metadata")
- [ ] Created or selected an app version in "App Store" tab
- [ ] Added all 3 subscriptions to the version (In-App Purchases section)
- [ ] Saved the changes
- [ ] Have a build uploaded with RevenueCat SDK integrated
- [ ] Selected the build for this version
- [ ] All other app metadata is complete (description, screenshots, etc.)
- [ ] Ready to click "Submit for Review"

---

## 🔄 The Complete Flow

Here's the big picture:

```
1. Create products in App Store Connect (Features → In-App Purchases) ✅
   ↓
2. Add metadata to products (Display name, description) ✅
   ↓
3. Products show "Ready to Submit" ✅ (YOU ARE HERE)
   ↓
4. Go to App Store tab → Select version
   ↓
5. Add subscriptions to version (In-App Purchases section) ← DO THIS NOW
   ↓
6. Save changes
   ↓
7. Submit app version for review
   ↓
8. Wait 24-48 hours
   ↓
9. Subscriptions approved and work in production! 🎉
```

---

## 💡 Pro Tips

### Add Subscription Screenshot for Review

When you submit, you'll be asked for a screenshot of your subscription in the app:

1. Build and run your app
2. Open the paywall screen (RevenueCatPaywallView)
3. Take a screenshot showing all 3 subscription options
4. Use this screenshot when submitting

### Review Notes

In the "Notes for Review" section, add:

```
SUBSCRIPTION TESTING INSTRUCTIONS:

Our app offers three subscription tiers:
- Weekly: £0.79
- Monthly: £2.49  
- Annual: £19.99 (Best value)

To test subscriptions:
1. Tap "Upgrade to Premium" in the app
2. Select any subscription tier
3. Complete the sandbox purchase
4. Premium features will unlock (planning 30 days ahead, multiple meals)

All subscriptions are auto-renewable and can be cancelled anytime in iOS Settings.

Test Account (if needed):
Username: [your sandbox test account]
Password: [password]
```

---

## 🆘 Still Stuck?

### Can't find "In-App Purchases and Subscriptions" section?

**Check you're in the right place:**
1. App Store Connect → My Apps → [Your App]
2. Click **"App Store"** tab (top navigation)
3. Make sure you see a version number (1.0, 1.1, etc.)
4. Scroll down past all the metadata fields
5. Should be near the bottom of the page

### Message still showing after adding subscriptions?

**This is normal!** The message will disappear:
- After you submit the app version for review
- Once Apple approves your subscriptions
- It's just a reminder to complete this step

---

## ✅ Success!

After completing these steps:
- Subscriptions are linked to your app version ✅
- You can submit for review ✅
- After approval, subscriptions work in production ✅

Your code is ready, RevenueCat is configured correctly - this is just the final App Store Connect setup! 🚀

