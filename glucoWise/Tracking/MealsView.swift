import SwiftUI

struct MealsView: View {
    @State private var selectedCategory = "Meals"
    @State private var selectedDate = Date()
    @State private var ShowMealsSection = false
    @State private var selectedMeal: String? = nil
    @State private var navigateToSearch = false
    
    var currentWeek: [Date] {
        let calendar = Calendar(identifier: .iso8601) // Ensures Monday start
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }

    var body: some View {
        VStack(alignment: .leading) {
            // MARK: - Week Date Picker
            VStack {
                HStack {
                    ForEach(currentWeek, id: \.self) { date in
                        let isFutureDate = date > Date()
                        let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                        
                        Button(action: {
                            if !isFutureDate {
                                selectedDate = date
                            }
                        }) {
                            VStack {
                                Text(dateFormatter.string(from: date)) // "Mon", "Tue"
                                    .font(.footnote)
                                    .foregroundColor(.black) // Always black
                                
                                Text(dateNumberFormatter.string(from: date)) // "21", "22"
                                    .frame(width: 40, height: 40)
                                    .background(isSelected ? Color(hex: "#6cab9c") : Color(.systemGray5))
                                    .clipShape(Circle())
                                    .foregroundColor(isSelected ? .white : (isFutureDate ? .gray : .black))
                            }
                        }
                        .disabled(isFutureDate) // Disable tap for future dates
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.top, 15)
                .padding(.bottom, 15) // Add bottom padding for the calendar section
            }
            .background(Color.white) // White background just for the calendar
            .cornerRadius(12) // Soft rounded edges for a clean look
            
            // MARK: - List with Tracked Food and Macros
            List {
                Section(header: HStack {
                    Text("Tracked Food")
                        .foregroundColor(.gray)
                    Spacer()
                    Button(action: {
                        ShowMealsSection = true
                    }) {
                        Text("Add meal")
                            .padding(.horizontal)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#6cab9c"))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }) {
                    MealRow(title: "Breakfast")
                    MealRow(title: "Lunch")
                    MealRow(title: "Snacks")
                    MealRow(title: "Dinner")
                }
                
                Section(header: Text("Macronutrient Breakdown").foregroundColor(.gray)) {
                    NutrientRow(name: "Carbs", current: 110, total: 105)
                    NutrientRow(name: "Protein", current: 19, total: 25)
                    NutrientRow(name: "Fats", current: 25, total: 21)
                    NutrientRow(name: "Fiber", current: 9, total: 10)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .actionSheet(isPresented: $ShowMealsSection) {
                ActionSheet(
                    title: Text("Meal Type"),
                    buttons: [
                        .default(Text("Breakfast")) { selectMeal("Breakfast") },
                        .default(Text("Snacks")) { selectMeal("Snacks") },
                        .default(Text("Lunch")) { selectMeal("Lunch") },
                        .default(Text("Dinner")) { selectMeal("Dinner") },
                        .cancel()
                    ]
                )
            }
            
            NavigationLink(
                destination: SearchFoodView(mealType: selectedMeal ?? ""),
                isActive: $navigateToSearch
            ) {
                EmptyView()
            }
            .hidden()
        }
    }
    
    private func selectMeal(_ meal: String) {
        selectedMeal = meal
        navigateToSearch = true
    }
}

// MARK: - Meal Row Component
struct MealRow: View {
    let title: String
    
    var body: some View {
        NavigationLink(destination: Text("\(title) Details")) {
            Text(title)
        }
    }
}

// MARK: - Nutrient Row Component
struct NutrientRow: View {
    let name: String
    let current: Int
    let total: Int
    
    var color: Color {
        let ratio = Double(current) / Double(total)
        if ratio > 1.0 {
            return .red
        } else if ratio >= 0.8 {
            return .green
        } else {
            return .orange
        }
    }
    
    var body: some View {
        HStack {
            Text(name)
            Spacer()
            Text("\(current)/\(total) g")
                .font(.subheadline)
                .foregroundColor(.gray)
            ProgressView(value: Double(current), total: Double(total))
                .progressViewStyle(LinearProgressViewStyle(tint: color))
                .frame(width: 100)
        }
    }
}

// MARK: - Date Formatters
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "E" // "Mon", "Tue"
    return formatter
}()

let dateNumberFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d" // "21", "22"
    return formatter
}()
