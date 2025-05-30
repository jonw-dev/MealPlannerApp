import Foundation

struct DefaultItems {
    static let items: [(name: String, category: String, emoji: String)] = [
        // Produce
        ("Apples", "Produce", "🍎"),
        ("Bananas", "Produce", "🍌"),
        ("Oranges", "Produce", "🍊"),
        ("Lemons", "Produce", "🍋"),
        ("Limes", "Produce", "🟩"),
        ("Strawberries", "Produce", "🍓"),
        ("Blueberries", "Produce", "🫐"),
        ("Raspberries", "Produce", "🫐"),
        ("Grapes", "Produce", "🍇"),
        ("Tomatoes", "Produce", "🍅"),
        ("Onions", "Produce", "🧅"),
        ("Garlic", "Produce", "🧄"),
        ("Potatoes", "Produce", "🥔"),
        ("Sweet Potatoes", "Produce", "🥔"),
        ("Carrots", "Produce", "🥕"),
        ("Celery", "Produce", "🥬"),
        ("Lettuce", "Produce", "🥬"),
        ("Spinach", "Produce", "🥬"),
        ("Broccoli", "Produce", "🥦"),
        ("Cauliflower", "Produce", "🥬"),
        ("Bell Peppers", "Produce", "🫑"),
        ("Cucumber", "Produce", "🥒"),
        ("Zucchini", "Produce", "🥒"),
        ("Mushrooms", "Produce", "🍄"),
        ("Avocados", "Produce", "🥑"),
        
        // Meat & Seafood
        ("Chicken Breast", "Meat & Seafood", "🍗"),
        ("Ground Beef", "Meat & Seafood", "🥩"),
        ("Salmon", "Meat & Seafood", "🐟"),
        ("Shrimp", "Meat & Seafood", "🦐"),
        ("Pork Chops", "Meat & Seafood", "🍖"),
        ("Bacon", "Meat & Seafood", "🥓"),
        ("Turkey", "Meat & Seafood", "🦃"),
        ("Sausages", "Meat & Seafood", "🌭"),
        ("Tuna", "Meat & Seafood", "🐟"),
        ("Ham", "Meat & Seafood", "🍖"),
        
        // Dairy & Eggs
        ("Milk", "Dairy & Eggs", "🥛"),
        ("Eggs", "Dairy & Eggs", "🥚"),
        ("Butter", "Dairy & Eggs", "🧈"),
        ("Cheese", "Dairy & Eggs", "🧀"),
        ("Greek Yogurt", "Dairy & Eggs", "🍶"),
        ("Cream", "Dairy & Eggs", "🥛"),
        ("Sour Cream", "Dairy & Eggs", "🥛"),
        ("Cream Cheese", "Dairy & Eggs", "🧀"),
        ("Cottage Cheese", "Dairy & Eggs", "🧀"),
        
        // Pantry
        ("Rice", "Pantry", "🍚"),
        ("Flour", "Pantry", "🌾"),
        ("Sugar", "Pantry", "🍬"),
        ("Salt", "Pantry", "🧂"),
        ("Black Pepper", "Pantry", "⚫"),
        ("Olive Oil", "Pantry", "🫒"),
        ("Vegetable Oil", "Pantry", "🌻"),
        ("Vinegar", "Pantry", "🧴"),
        ("Honey", "Pantry", "🍯"),
        ("Maple Syrup", "Pantry", "🍁"),
        
        // Grains & Pasta
        ("Spaghetti", "Grains & Pasta", "🍝"),
        ("Penne", "Grains & Pasta", "🍝"),
        ("Macaroni", "Grains & Pasta", "🍝"),
        ("Bread", "Grains & Pasta", "🍞"),
        ("Tortillas", "Grains & Pasta", "🌮"),
        ("Cereal", "Grains & Pasta", "🥣"),
        ("Oatmeal", "Grains & Pasta", "🥣"),
        ("Quinoa", "Grains & Pasta", "🌾"),
        
        // Canned Goods
        ("Diced Tomatoes", "Canned Goods", "🍅"),
        ("Tomato Sauce", "Canned Goods", "🍅"),
        ("Black Beans", "Canned Goods", "🫘"),
        ("Kidney Beans", "Canned Goods", "🫘"),
        ("Chickpeas", "Canned Goods", "🫘"),
        ("Corn", "Canned Goods", "🌽"),
        ("Soup", "Canned Goods", "🍜"),
        
        // Frozen Foods
        ("Mixed Vegetables", "Frozen Foods", "🥬"),
        ("Ice Cream", "Frozen Foods", "🍦"),
        ("Pizza", "Frozen Foods", "🍕"),
        ("French Fries", "Frozen Foods", "🍟"),
        ("Frozen Berries", "Frozen Foods", "🫐"),
        
        // Condiments
        ("Ketchup", "Condiments", "🍅"),
        ("Mustard", "Condiments", "🌭"),
        ("Mayonnaise", "Condiments", "🥪"),
        ("BBQ Sauce", "Condiments", "🍖"),
        ("Hot Sauce", "Condiments", "🌶️"),
        ("Soy Sauce", "Condiments", "🧂"),
        
        // Spices & Herbs
        ("Basil", "Spices & Herbs", "🌿"),
        ("Oregano", "Spices & Herbs", "🌿"),
        ("Thyme", "Spices & Herbs", "🌿"),
        ("Rosemary", "Spices & Herbs", "🌿"),
        ("Cinnamon", "Spices & Herbs", "🌰"),
        ("Paprika", "Spices & Herbs", "🌶️"),
        ("Cumin", "Spices & Herbs", "🌿"),
        ("Chili Powder", "Spices & Herbs", "🌶️"),
        
        // Baking
        ("Baking Powder", "Baking", "🧁"),
        ("Baking Soda", "Baking", "🧪"),
        ("Vanilla Extract", "Baking", "🌸"),
        ("Chocolate Chips", "Baking", "🍫"),
        ("Cocoa Powder", "Baking", "🍫"),
        ("Brown Sugar", "Baking", "🍯"),
        ("Powdered Sugar", "Baking", "🍬"),
        
        // Beverages
        ("Coffee", "Beverages", "☕"),
        ("Tea", "Beverages", "🍵"),
        ("Orange Juice", "Beverages", "🍊"),
        ("Apple Juice", "Beverages", "🍎"),
        ("Soda", "Beverages", "🥤"),
        ("Water", "Beverages", "💧"),
        
        // Snacks
        ("Potato Chips", "Snacks", "🥔"),
        ("Popcorn", "Snacks", "🍿"),
        ("Nuts", "Snacks", "🥜"),
        ("Crackers", "Snacks", "🍘"),
        ("Cookies", "Snacks", "🍪"),
        ("Granola Bars", "Snacks", "🍫"),
        
        // Cleaning Supplies
        ("Dish Soap", "Cleaning Supplies", "🧼"),
        ("Laundry Detergent", "Cleaning Supplies", "🧺"),
        ("Paper Towels", "Cleaning Supplies", "🧻"),
        ("Trash Bags", "Cleaning Supplies", "🗑️"),
        ("All-Purpose Cleaner", "Cleaning Supplies", "🧴"),
        ("Sponges", "Cleaning Supplies", "🧽"),
        
        // Paper & Plastic
        ("Toilet Paper", "Paper & Plastic", "🧻"),
        ("Paper Plates", "Paper & Plastic", "🍽️"),
        ("Plastic Wrap", "Paper & Plastic", "🧴"),
        ("Aluminum Foil", "Paper & Plastic", "📦"),
        ("Zip-lock Bags", "Paper & Plastic", "👜"),
        
        // Household Essentials
        ("Light Bulbs", "Household Essentials", "💡"),
        ("Batteries", "Household Essentials", "🔋"),
        ("Matches", "Household Essentials", "🔥"),
        ("Hand Soap", "Household Essentials", "🧼"),
        
        // Personal Care
        ("Shampoo", "Personal Care", "🧴"),
        ("Conditioner", "Personal Care", "🧴"),
        ("Toothpaste", "Personal Care", "🪥"),
        ("Deodorant", "Personal Care", "🧴"),
        ("Hand Sanitizer", "Personal Care", "🧴"),
        ("Body Wash", "Personal Care", "🚿"),
        
        // Pet Supplies
        ("Dog Food", "Pet Supplies", "🐕"),
        ("Cat Food", "Pet Supplies", "🐱"),
        ("Pet Treats", "Pet Supplies", "🦴"),
        ("Cat Litter", "Pet Supplies", "🐱"),
        
        // Baby Items
        ("Diapers", "Baby Items", "🍼"),
        ("Baby Wipes", "Baby Items", "👶"),
        ("Baby Food", "Baby Items", "🥣"),
        ("Formula", "Baby Items", "🍼")
    ]
} 