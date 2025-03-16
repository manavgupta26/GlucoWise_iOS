//
//  DataModel.swift
//  glucoWise
//
//  Created by Manav Gupta on 13/03/25.
//

import Foundation
import SwiftUICore

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
struct ActivityProgress {
    var date: Date  // The specific day of the activity
    var caloriesBurned: Double  // Total calories burned
    var workoutMinutes: Int  // Total workout minutes
    var totalSteps: Int  // Total steps taken
}


struct Meal: Codable {
    var id: String = UUID().uuidString
    var type: MealType  // Breakfast, Lunch, Dinner, Snacks
    var foodItems: [FoodItem]  // List of food items
    var date: Date  // Date when the meal was logged

    // Function to calculate total nutrition for the meal
    func totalNutrition() -> (calories: Double, carbs: Double, fats: Double, proteins: Double, fiber: Double, giIndex: Double) {
        let totalCalories = foodItems.reduce(0) { $0 + $1.calories }
        let totalCarbs = foodItems.reduce(0) { $0 + $1.carbs }
        let totalFats = foodItems.reduce(0) { $0 + $1.fats }
        let totalProteins = foodItems.reduce(0) { $0 + $1.proteins }
        let totalFiber = foodItems.reduce(0) { $0 + $1.fiber }
        let avgGIIndex = foodItems.isEmpty ? 0 : foodItems.reduce(0) { $0 + $1.giIndex } / Double(foodItems.count)

        return (totalCalories, totalCarbs, totalFats, totalProteins, totalFiber, avgGIIndex)
    }
}

struct FoodItem: Codable {
    var id: String = UUID().uuidString
    var name: String
    var quantity: Double // Example: 100g, 1 cup, etc.
    var calories: Double
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
            calories: calories * factor,
            carbs: carbs * factor,
            fats: fats * factor,
            proteins: proteins * factor,
            fiber: fiber * factor,
            giIndex: giIndex
        )
    }
}

struct BloodReading: Codable, Identifiable {
    var id: String = UUID().uuidString
    var type: BloodReadingType
    var value: Double
    var date: Date

    // Image name stored to load the correct image
    var imageName: String? {
        if value <= 120 {
            return "GoodImage"
        } else if value > 120 && value <= 180 {
            return "NeutralImage"
        } else {
            return "BadImage"
        }
    }

    // Computed property to return an Image based on imageName
    var image: Image {
        if let imageName = imageName {
            return Image(imageName)
        } else {
            return Image(systemName: "questionmark.circle") // Default fallback image
        }
    }

    // Explicit initializer
    init(id: String = UUID().uuidString, type: BloodReadingType, value: Double, date: Date) {
        self.id = id
        self.type = type
        self.value = value
        self.date = date
    }
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
var UserId: String = ""


class UserManager {
    static let shared = UserManager()

    var users: [User] = []
    
    private var mealsByDate: [String: [Meal]] = [:]
    private var readingsByDate: [String: [BloodReading]] = [:]
    private var activitiesByDate: [String: ActivityProgress] = [:]
    private init() {
        loadDummyData()  // Load dummy data when the app starts
    }
    func addActivity(_ activity: ActivityProgress) {
            let dateKey = formatDate(activity.date)
            activitiesByDate[dateKey] = activity
        }

        func getActivity(for date: Date) -> ActivityProgress? {
            let dateKey = formatDate(date)
            return activitiesByDate[dateKey]
        }
    func differenceBetweenBloodSugar(for date: Date) -> Double? {
        let calendar = Calendar.current
        guard let yesterday = calendar.date(byAdding: .day, value: -1, to: date) else { return nil }

        let yesterdayReadings = getReadings(for: yesterday)
        let todayReadings = getReadings(for: date)

        let yesterdayAverage = yesterdayReadings.isEmpty ? nil : yesterdayReadings.map { $0.value }.reduce(0, +) / Double(yesterdayReadings.count)
        let todayAverage = todayReadings.isEmpty ? nil : todayReadings.map { $0.value }.reduce(0, +) / Double(todayReadings.count)

        guard let yAvg = yesterdayAverage, let tAvg = todayAverage else {
            return nil  // Return nil if we don't have readings for both days
        }

        return tAvg - yAvg
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
   
    func getCaloriesConsumed(userId: String, date: Date) -> Double {
        let meals = UserManager.shared.getMeals(for: date)
        return meals.reduce(0) { $0 + $1.totalNutrition().calories }
    }
    func getStepsTaken(userId: String, date: Date) -> Int {
        // Fetch the steps count from stored data for the given date
        return activitiesByDate[formatDate(date)]?.totalSteps ?? 0

    }


    private func loadDummyData() {
           let dummyUser = User(
               id: UUID().uuidString,
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
           UserId = dummyUser.id!
           addUser(dummyUser)

           let today = Date()

           // Dummy Food Items
           let apple = FoodItem(name: "Apple", quantity: 100, calories: 52, carbs: 14, fats: 0.2, proteins: 0.3, fiber: 2.4, giIndex: 38)
           let rice = FoodItem(name: "Rice", quantity: 150, calories: 195, carbs: 40, fats: 0.3, proteins: 3.5, fiber: 1.0, giIndex: 73)

           // Dummy Meals
           let breakfast = Meal(type: .breakfast, foodItems: [apple, rice], date: today)
           let lunch = Meal(type: .lunch, foodItems: [rice], date: today)

           addMeal(breakfast)
           addMeal(lunch)
        let calendar = Calendar.current
      

        // Set time to 10:00 AM
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        components.hour = 10
        components.minute = 0

        
           // Dummy Blood Readings
           let fastingReading = BloodReading(type: .fasting, value: 90.0, date: today)
           let postMealReading = BloodReading(type: .postMeal, value: 125.0, date: today)
            
           addBloodReading(fastingReading)
           addBloodReading(postMealReading)
        

           // Dummy Activity Progress
           let dummyActivity = ActivityProgress(date: today, caloriesBurned: 300, workoutMinutes: 45, totalSteps: 8000)
           addActivity(dummyActivity)
       }
}
