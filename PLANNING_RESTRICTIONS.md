# Meal Planning Restrictions - Free vs Premium

## 🆓 Free Tier Limits

### 1. **7-Day Planning Limit**
Free users can only plan meals for the **next 7 days** from today.

**Example:**
- Today: February 3, 2025
- Free users can plan: Feb 3 - Feb 9 (7 days)
- Days beyond Feb 9: **Locked** 🔒

### 2. **One Meal Per Day**
Free users can only add **1 meal per day** within the 7-day window.

---

## 💎 Premium Benefits

### 1. **Extended Planning (30 days)**
Premium users can plan meals up to **30 days ahead**.

### 2. **Multiple Meals Per Day (5 meals)**
Premium users can add up to **5 meals per day**.

---

## 🎨 UI/UX Implementation

### Visual Indicators:

#### 1. **Premium Badge on Locked Dates**
When a date is beyond 7 days (free users only):
```
┌─────────────────────────┐
│ Mon            🔒 Premium│
│ 10              (orange) │
└─────────────────────────┘
```

#### 2. **Lock Icon on Add Meal Button**
When button is locked (free users only):
```
┌─────────────────────────┐
│ ➕ Add Meal      🔒     │
│ (dashed border)         │
└─────────────────────────┘
```

Two scenarios show the lock:
- Date is beyond 7 days
- Trying to add 2nd+ meal (free tier)

#### 3. **Paywall Trigger**
Clicking any locked "Add Meal" button shows the paywall.

---

## 🔧 Technical Implementation

### SubscriptionManager Methods:

```swift
// Check if user can plan for a specific date
func canPlanForDate(_ date: Date) -> Bool {
    if isPremium {
        return true // Unlimited
    } else {
        // Free: only 7 days from today
        let daysDifference = date - today
        return daysDifference >= 0 && daysDifference < 7
    }
}

// Check if user can add multiple meals
func canAddMultipleMeals(for date: Date, currentMealCount: Int) -> Bool {
    if isPremium {
        return currentMealCount < 5
    } else {
        return currentMealCount < 1
    }
}

// Get max planning days
func maxPlanningDays() -> Int {
    return isPremium ? 30 : 7
}
```

### Flow:

1. **User taps "Add Meal" button**
2. **Check 1:** Is date within 7 days? (free users)
   - ❌ No → Show paywall
   - ✅ Yes → Continue to Check 2
3. **Check 2:** Can add more meals to this day?
   - ❌ No → Show paywall (already have 1 meal, free tier)
   - ✅ Yes → Show meal picker

---

## 📱 User Experience Examples

### Scenario 1: Free User, Day 3
- ✅ Date is within 7 days
- ✅ No meals scheduled yet
- **Result:** Can add meal

### Scenario 2: Free User, Day 3 (already has 1 meal)
- ✅ Date is within 7 days
- ❌ Already has 1 meal (free limit)
- **Result:** Show lock icon + paywall

### Scenario 3: Free User, Day 10
- ❌ Date is beyond 7 days
- **Result:** "Premium" badge on date + lock on button + paywall

### Scenario 4: Premium User, Day 10
- ✅ Premium allows 30 days
- ✅ Can have up to 5 meals
- **Result:** Full access, no restrictions

---

## 🎯 Updated Premium Features

The paywall now emphasizes:

1. **Multiple Meals Per Day** 
   - Up to 5 meals per day
   
2. **Extended Planning** ⭐ NEW EMPHASIS
   - "Plan up to 30 days ahead, not just 7"
   
3. **Meal Categories**
   - Organize by type
   
4. **Export & Share**
   - Share with friends & family

❌ Removed: ~~Priority Support~~ (as requested)

---

## 🧪 Testing

### How to Test:

#### Test Free User with 7-Day Limit:

1. Go to **Settings** → Toggle **Premium OFF**
2. Go to **Meal Plan** tab
3. Change the start date to today
4. **Days 1-7:** Should have normal "Add Meal" buttons ✅
5. **Days 8+:** Should show:
   - Orange "Premium" badge on date header
   - Lock icon on "Add Meal" button
   - Clicking button shows paywall ✅

#### Test Free User with Multiple Meals:

1. Premium still OFF
2. Go to a date within 7 days
3. Add 1 meal successfully ✅
4. Try to add 2nd meal
5. Should see lock icon and paywall ✅

#### Test Premium User:

1. Go to **Settings** → Toggle **Premium ON**
2. Change date picker to plan 15 days ahead
3. All dates should be unlocked ✅
4. Can add up to 5 meals per day ✅
5. No lock icons anywhere ✅

---

## 📊 Monetization Impact

### Conversion Triggers:

Free users hit paywall when they:
1. **Plan ahead** → Try to plan day 8+ (Extended Planning feature)
2. **Add 2nd meal** → Try to add multiple meals per day

### Value Proposition:

**For Planners:**
- "Plan your whole month at once!"
- "See 30 days ahead"

**For Families:**
- "Plan breakfast, lunch, dinner, and snacks"
- "5 meals per day for busy households"

---

## 🎨 Visual Design

### Lock Icon Colors:
- Icon: `lock.fill`
- Color: Inherits from text (subtle)
- Size: `.caption` (small, non-intrusive)

### Premium Badge:
- Background: Orange opacity 0.15
- Text: Orange
- Icon: `lock.fill`
- Padding: 8px horizontal, 4px vertical
- Corner radius: 8px

### Button States:
- **Normal:** Solid border, no lock
- **Locked:** Dashed border + lock icon
- **Disabled:** Grayed out (if needed)

---

## 🔄 Date Range Behavior

### When User Changes Start Date:

The app dynamically recalculates which dates are locked:

**Example 1:**
- Start Date: Feb 3
- Free user can plan: Feb 3-9
- Feb 10+: Locked

**Example 2:**
- Start Date: Feb 10 (scrolled forward)
- Free user can plan: Feb 10-16
- Feb 17+: Locked

**Always calculated from today's date, not the selected start date!**

---

## 💡 Future Enhancements

### Possible Additions:

1. **Calendar Month View**
   - Visual month calendar
   - Clearly show 7-day vs 30-day limits

2. **Planning Streak**
   - "You've planned 5 days ahead! Upgrade for 30 days"

3. **Upgrade Prompt Timing**
   - Show soft reminder on day 6
   - "Planning ahead? Upgrade for 30 days!"

4. **Meal Plan Templates**
   - Premium: Save and reuse weekly plans
   - One-click plan entire week

---

## ✅ Summary

**Implemented Features:**
- ✅ 7-day planning limit for free users
- ✅ 30-day planning for premium users
- ✅ Lock icons on restricted buttons
- ✅ Premium badge on locked dates
- ✅ Paywall triggers on restricted actions
- ✅ Dynamic date restriction checking
- ✅ Visual indicators for locked features
- ✅ Updated paywall copy (removed priority support)

**User Experience:**
- ✅ Clear visual feedback (lock icons + badges)
- ✅ Native iOS patterns (orange = premium)
- ✅ Immediate paywall on restricted actions
- ✅ Works with any start date selection

The planning restrictions are fully functional and provide a clear upgrade path for users! 🎉

