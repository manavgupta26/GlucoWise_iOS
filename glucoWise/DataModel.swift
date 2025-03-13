//
//  DataModel.swift
//  glucoWise
//
//  Created by Manav Gupta on 13/03/25.
//

import Foundation


struct User {
    var id: String? = UUID().uuidString
    var name: String
    var emailId: String
    var password: String
    var age: Int
    var gender: Gender
    var weight: Double
    var height: Double
    var targetBloodSugar: Double?
    var currentBloodSugar: Double?
    var activityLevel: ActivityLevel
}
enum Gender: String {
    case male = "Male"
    case female = "Female"
    case other = "Other"
}
enum ActivityLevel: String {
    case sedentary = "Sedentary"
    case active = "Active"
    case veryActive = "Very Active"
    case moderateActive = "Moderately Active"
}


struct Meal: Codable {
    var id: String = UUID().uuidString
    var type: MealType  // Breakfast, Lunch, Dinner, Snacks
    var foodItems: [FoodItem]  // List of food items
    var date: Date  // Date when the meal was logged

    // Function to calculate total nutrition for the meal
    func totalNutrition() -> (carbs: Double, fats: Double, proteins: Double, fiber: Double, giIndex: Double) {
        let totalCarbs = foodItems.reduce(0) { $0 + $1.carbs }
        let totalFats = foodItems.reduce(0) { $0 + $1.fats }
        let totalProteins = foodItems.reduce(0) { $0 + $1.proteins }
        let totalFiber = foodItems.reduce(0) { $0 + $1.fiber }
        let avgGIIndex = foodItems.isEmpty ? 0 : foodItems.reduce(0) { $0 + $1.giIndex } / Double(foodItems.count)

        return (totalCarbs, totalFats, totalProteins, totalFiber, avgGIIndex)
    }
}
struct FoodItem: Codable {
    var id: String = UUID().uuidString
    var name: String
    var quantity: Double // Example: 100g, 1 cup, etc.
    var carbs: Double
    var fats: Double
    var proteins: Double
    var fiber: Double
    var giIndex: Double

    // Function to calculate nutrition based on new quantity
    func adjustedNutrients(for newQuantity: Double) -> FoodItem {
        let factor = newQuantity / quantity
        return FoodItem(
            name: name,
            quantity: newQuantity,
            carbs: carbs * factor,
            fats: fats * factor,
            proteins: proteins * factor,
            fiber: fiber * factor,
            giIndex: giIndex
        )
    }
}
struct BloodReading: Codable {
    var id: String = UUID().uuidString
    var type: BloodReadingType  // Fasting, Pre-meal, Post-meal, etc.
    var value: Double  // Blood sugar value (mg/dL)
    var date: Date  // Date when the reading was taken
}
enum BloodReadingType: String, Codable {
    case fasting = "Fasting"
    case preMeal = "Pre-Meal"
    case postMeal = "Post-Meal"
    case preWorkout = "Pre-Workout"
    case postWorkout = "Post-Workout"
}

enum MealType: String, Codable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snacks = "Snacks"
}


class UserManager {
    static let shared = UserManager()
   
    var users: [User] = []
    private var mealsByDate: [String: [Meal]] = [:]
    private var readingsByDate: [String: [BloodReading]] = [:]
    private init() {
            loadDummyData()  // Load dummy data when the app starts
        }
    func addUser(_ user: User) {
        users.append(user)
    }

    func getAllUsers() -> [User] {
        return users
    }
    // Function to add a meal
    func addMeal(_ meal: Meal) {
            let dateKey = formatDate(meal.date)

            if mealsByDate[dateKey] == nil {
                mealsByDate[dateKey] = []
            }
            mealsByDate[dateKey]?.append(meal)
        }
    // Function to get meals for a specific date
    func getMeals(for date: Date) -> [Meal] {
            let dateKey = formatDate(date)
            return mealsByDate[dateKey] ?? []
        }
    
    
    
    // Function to add a reading
        func addBloodReading(_ reading: BloodReading) {
            let dateKey = formatDate(reading.date)

            if readingsByDate[dateKey] == nil {
                readingsByDate[dateKey] = []
            }
            readingsByDate[dateKey]?.append(reading)
        }

        // Function to get readings for a specific date
        func getReadings(for date: Date) -> [BloodReading] {
            let dateKey = formatDate(date)
            return readingsByDate[dateKey] ?? []
        }
    
    
    private func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    private func loadDummyData() {
           let dummyUser = User(
               name: "John Doe",
               emailId: "johndoe@example.com",
               password: "password123",
               age: 30,
               gender: .male,
               weight: 75.0,
               height: 175.0,
               targetBloodSugar: 100.0,
               currentBloodSugar: 95.0,
               activityLevel: .active
           )
           addUser(dummyUser)

           let today = Date()
           
           // Dummy Food Items
           let apple = FoodItem(name: "Apple", quantity: 100, carbs: 14, fats: 0.2, proteins: 0.3, fiber: 2.4, giIndex: 38)
           let rice = FoodItem(name: "Rice", quantity: 150, carbs: 40, fats: 0.3, proteins: 3.5, fiber: 1.0, giIndex: 73)

           // Dummy Meals
           let breakfast = Meal(type: .breakfast, foodItems: [apple, rice], date: today)
           let lunch = Meal(type: .lunch, foodItems: [rice], date: today)

           addMeal(breakfast)
           addMeal(lunch)

           // Dummy Blood Readings
           let fastingReading = BloodReading(type: .fasting, value: 90.0, date: today)
           let postMealReading = BloodReading(type: .postMeal, value: 120.0, date: today)

           addBloodReading(fastingReading)
           addBloodReading(postMealReading)
       }
    
}
