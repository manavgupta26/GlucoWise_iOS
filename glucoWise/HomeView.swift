import SwiftUI
let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "d"  // Format for day (e.g., "12" for 12th)
    return formatter
}()

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
        var body: some View {
            NavigationView {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        CalendarSection()
                        BloodGlucoseSection()
                        MealRecommendationSection(carbLevel: 0.4, giLevel: 0.7)
                        DailyTipsSection()
                        DailySummarySection()
                        Spacer()
                    }
                    .padding(.top)
                }
                .background(Color(UIColor.systemGray6))
                .navigationTitle("Dashboard")
            }
        }
    }
struct CalendarSection: View {
    @State private var selectedDate: Date = Date()
    
    
    private var weekDates: [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: startOfWeek) }
    }
    
    var body: some View {
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
                                    .background(isSelected ? Color(hex: "#6CAB9C") : Color(hex: "#F2F2F8"))
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
        }
    }
}
    struct BloodGlucoseSection: View {
        @State private var selectedDate = Date()
        
        var body: some View {
            VStack(alignment: .leading) {
                if let lastReading = UserManager.shared.getReadings(for: selectedDate).last {
                    HStack {
                        
                        VStack(alignment: .leading) {
                            Text("Blood Glucose Level")
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                            Text("\(lastReading.value, specifier: "%.1f") mg/dL")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            HStack {
                                Text("\(UserManager.shared.differenceBetweenBloodSugar(for: selectedDate) ?? 0, specifier: "%.1f") mg/dL")
                                    .foregroundColor(Color(hex: "#6CAB9C")).font(.footnote) // Green color for difference
                                
                                Text("since yesterday")
                                    .foregroundColor(.gray).font(.footnote) // Gray color for label
                            }
                            Spacer()
                            Text("Updated at \(formattedTime(from: lastReading.date))")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                        }
                        Spacer()
                        lastReading.image.resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                       
                            NavigationLink( destination: DailyReadingsView(selectedDate: selectedDate)){
                                
                                
                                Image(systemName: "chevron.right").font(.title2)
                            }.padding(.top, -10)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(12)
                } else {
                    Text("No readings available")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
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
    
struct MealRecommendationSection: View {
    var carbLevel: Double // Value between 0 to 1
    var giLevel: Double // Value between 0 to 1
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Meal Recommendations")
                .font(.headline)
                .padding(.bottom, 4)
            
            HStack {
               
                VStack(alignment: .leading) {
                    HStack(alignment: .top){
                        Text("🥗").font(.system(size: 30, weight: .bold))
                        Text("Last Meal:  Grilled Chicken Salad").font(.system(size: 18, weight: .bold)).fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2).minimumScaleFactor(0.5).allowsTightening(true)
                            .frame(maxHeight: 30, alignment: .leading)
                        Spacer()
                        
                    }
                    // Carbohydrates Progress Bar}
                    Text("Carbohydrates")
                        .font(.caption)
                        .foregroundColor(.gray)
                    ProgressView(value: carbLevel)
                        .progressViewStyle(LinearProgressViewStyle()).clipShape(Capsule()) .frame(width: 100, height: 10)
                        
                        
                    
                    // Glycemic Index Progress Bar
                    Text("Glycemic Index")
                        .font(.caption)
                        .foregroundColor(.gray)
                    ProgressView(value: giLevel)
                        .progressViewStyle(LinearProgressViewStyle())
                        .clipShape(Capsule()).frame(width: 100, height: 10)
                }
                
                Spacer()
                Spacer()
                
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("🍣").font(.system(size: 30, weight: .bold))
                        Text("Recommended Next Meal").font(.system(size: 18, weight: .bold)).fixedSize(horizontal: false, vertical: true)
                            .lineLimit(2).minimumScaleFactor(0.5).allowsTightening(true)
                            .frame(maxHeight: 30, alignment: .leading)
                        
                    }
                            Spacer()
                                    Text("Baked Salmon with steamed broccoli").frame(maxWidth: .infinity, alignment: .top).font(.caption)
                        .foregroundColor(.gray)
                    Spacer()
                    Text("View Recipe >")
                        .font(.caption)
                        .foregroundColor(Color(hex: "6CAB9C")).frame(maxWidth: .infinity, alignment: .top)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}

    struct DailyTipsSection: View {
        var body: some View {
            VStack(alignment: .leading) {
                Text("Tips")
                    .font(.headline)
                    .padding(.bottom, 4)
                
                HStack(spacing: 16) {
                    TipCard(imageName: "figure.walk", title: "Take 10 min walk",
                            message: "You haven't logged any activity in the past 10 days. Let's get moving",
                            actionText: "Log Activity >")
                    
                    TipCard(imageName: "drop.fill", title: "9.5% HbA1c",
                            message: "Your HbA1c levels are improving—fantastic progress! Keep it up!",
                            actionText: "Know More >")
                }
            }
            .padding(.horizontal)
        }
    }
    
    struct TipCard: View {
        let imageName: String
        let title: String
        let message: String
        let actionText: String
        
        var body: some View {
            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 20, height: 30)
                    .foregroundColor(Color(hex: "6CAB9C"))
                
                Text(title)
                    .font(.headline)
                
                Text(message)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .fixedSize(horizontal: false, vertical: true) // Ensures full text is visible
                                .frame(maxWidth: .infinity, minHeight: 50) // Keeps message area consistent
Spacer()
                
                Text(actionText)
                    .font(.caption)
                    .foregroundColor(Color(hex: "6CAB9C"))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12).frame(width: 180, height: 200)
        }
    }
    



struct DailySummarySection: View {
    var stepsTaken: Double = 5000
    var totalSteps: Double = 10000
    var caloriesConsumed: Double = 1200
    var totalCalories: Double = 2000
    
    @State private var expandedSection: String? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Summary")
                .font(.headline)
                .padding(.bottom, 8)
            
            HStack(spacing: 50) {
                if expandedSection != "Calories" {
                    VStack {
                        ProgressCircle(title: "Steps", value: stepsTaken, total: totalSteps, unit: "steps")
                        
                        Button(action: {
                            withAnimation {
                                expandedSection = (expandedSection == "Steps") ? nil : "Steps"
                            }
                        }) {
                            HStack {
                                Text(expandedSection == "Steps" ? "View Less" : "View More")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                Image(systemName: expandedSection == "Steps" ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                if expandedSection == "Steps" {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Goal: \(Int(totalSteps)) steps")
                        Text("Steps Remaining: \(Int(totalSteps - stepsTaken))")
                        Text("Active Time: 45 min")
                        
                        Button(action: {
                            withAnimation {
                                expandedSection = nil
                            }
                        }) {
                            HStack {
                                Text("View Less")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                Image(systemName: "chevron.up")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                
                            }
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
                
                if expandedSection != "Steps" {
                    VStack {
                        ProgressCircle(title: "Calories", value: caloriesConsumed, total: totalCalories, unit: "kcal")
                        
                        Button(action: {
                            withAnimation {
                                expandedSection = (expandedSection == "Calories") ? nil : "Calories"
                            }
                        }) {
                            HStack {
                                Text(expandedSection == "Calories" ? "View Less" : "View More")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                Image(systemName: expandedSection == "Calories" ? "chevron.up" : "chevron.down")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                            }
                        }
                    }
                    .transition(.opacity.combined(with: .scale))
                }
                
                if expandedSection == "Calories" {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Goal: \(Int(totalCalories)) kcal")
                        Text("Remaining: \(Int(totalCalories - caloriesConsumed)) kcal")
                        Text("Macronutrient Breakdown: 50% Carbs, 30% Protein, 20% Fats")
                        
                        Button(action: {
                            withAnimation {
                                expandedSection = nil
                            }
                        }) {
                            HStack {
                                Text("View Less")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                                Image(systemName: "chevron.up")
                                    .font(.caption)
                                    .foregroundColor(Color(hex: "6CAB9C"))
                            }
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .cornerRadius(12)
        .padding(.horizontal)
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
