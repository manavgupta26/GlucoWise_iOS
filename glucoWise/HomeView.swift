import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(0)
            
            TrackingView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Tracking")
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
                .tag(2)
        }
        .accentColor(Color(hex: "#6CAB9C"))
    }
}

struct DashboardView: View {
    @State private var selectedDate: Date = Date()
    private var stepsTaken: CGFloat {
        CGFloat(UserManager.shared.getStepsTaken(userId: UserId, date: selectedDate))
    }

    private let totalSteps: CGFloat = 10000
    private var caloriesConsumed: CGFloat { UserManager.shared.getCaloriesConsumed(userId: UserId, date: selectedDate)
    }
    private let totalCalories: CGFloat = 1000
    
    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Calendar Section
                    VStack {
                        HStack {
                            ForEach(weekDates, id: \.self) { date in
                                let isFutureDate = date > Date()
                                let isSelected = Calendar.current.isDate(selectedDate, inSameDayAs: date)
                                
                                Button(action: {
                                    if !isFutureDate {
                                        selectedDate = date
                                    }
                                }) {
                                    VStack {
                                        Text(dateFormatter.string(from: date))
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                        
                                        Text(dayFormatter.string(from: date))
                                            .font(.headline)
                                            .foregroundColor(isFutureDate ? .gray : (isSelected ? .white : .black))
                                            .frame(width: 36, height: 36)
                                            .background(isSelected ? Color(hex: "#6CAB9C") : Color.clear)
                                            .clipShape(Circle())
                                    }
                                }
                                .disabled(isFutureDate)
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Blood Glucose Section
                    VStack(alignment: .leading) {
                        Text("Blood Glucose Level")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        if let lastReading = UserManager.shared.getReadings(for: selectedDate).last {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("\(lastReading.value, specifier: "%.1f") mg/dL")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                    
                                    Text("Updated at \(formattedTime(from: lastReading.date))")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                            }.padding()
                                .frame(maxWidth: .infinity, alignment: .leading
                                )
                                .background(Color.white)
                                .cornerRadius(12)
                        } else {
                            Text("No readings available")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading
                                    )
                                    .background(Color.white)
                                    .cornerRadius(12)
                        }
                        
                    }
                    .padding(.horizontal)
                    
                    // Meal Recommendations
                    VStack(alignment: .leading) {
                        Text("Meal Recommendations")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Last Meal: Grilled Chicken Salad")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("Carb  |  G.I.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("Recommended Next Meal")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                
                                Text("Baked Salmon with steamed broccoli")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                Text("View Recipe >")
                                    .font(.caption)
                                    .foregroundColor(Color(hex : "6CAB9C"))
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Daily Tips
                    VStack(alignment: .leading) {
                        Text("Tips")
                            .font(.headline)
                            .padding(.bottom, 4)
                        
                        HStack(spacing: 16) {
                            VStack {
                                Image(systemName: "figure.walk")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                
                                Text("Take 10 min walk")
                                    .font(.headline)
                                
                                Text("You haven't logged any activity in the past 10 days. Let's get moving")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                
                                Text("Log Activity >")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            
                            VStack {
                                Image(systemName: "drop.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                
                                Text("9.5% HbA1c")
                                    .font(.headline)
                                
                                Text("Your HbA1c levels are improving—fantastic progress! Keep it up!")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                
                                Text("Know More >")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Daily Summary")
                            .font(.headline)
                            .padding(.bottom, 8)
                        
                        HStack(spacing: 100) {
                            ProgressCircle(title: "Steps", value: stepsTaken, total: totalSteps, unit: "steps")
                            ProgressCircle(title: "Calories", value: caloriesConsumed, total: totalCalories, unit: "kcal")
                        }.frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .background(Color(UIColor.systemGray6))
            .navigationTitle("Dashboard")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "E" // Short weekday name (Mon, Tue, etc.)
        return formatter
    }
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d" // Day number
        return formatter
    }
}



struct ProgressCircle: View {
    var title: String
    var value: CGFloat
    var total: CGFloat
    var unit: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0.0, to: value / total)
                    .stroke(Color(hex: "6CAB9C"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100, height: 100)
                
                VStack {
                    Text("\(Int(value))")
                        .font(.headline)
                        .fontWeight(.bold)
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




func formattedTime(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeStyle = .short  // Example: "8:00 AM"
    return formatter.string(from: date)
}

