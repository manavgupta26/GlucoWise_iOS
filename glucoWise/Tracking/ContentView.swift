import SwiftUI
import Charts

struct TrackingView: View {
    @State private var selectedTab = "Blood Sugar"
    let tabs = ["Blood Sugar", "Meals", "Activity"]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Picker("", selection: $selectedTab) {
                    ForEach(tabs, id: \ .self) { tab in
                        Text(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                if selectedTab == "Blood Sugar" {
                    BloodSugarView()
                } else if selectedTab == "Meals" {
                    MealsView()
                } else if selectedTab == "Activity" {
                    HealthStatsView()
                }
                Spacer()
                    .navigationTitle("Tracking")
            }
            .padding(.top,20)
        }
    }
    
    struct BloodSugarView: View {
        @State private var selectedGraph = 0
        let graphOptions = ["Today", "Week", "Month"]
        
        var body: some View {
            VStack(alignment: .leading) {
                TabView(selection: $selectedGraph) {
                    BloodSugarGraphView(title: "Today", data: [120, 150, 118, 130, 115])
                        .tag(0)
                    BloodSugarGraphView(title: "Week", data: [110, 140, 135, 125, 120, 130, 128])
                        .tag(1)
                    BloodSugarGraphView(title: "Month", data: [125, 132, 120, 145, 130, 135, 140, 138, 130, 128])
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .frame(height: 250)
                
                HStack {
                    Spacer()
                    PageIndicator(selectedIndex: $selectedGraph, count: graphOptions.count)
                    Spacer()
                }
                .padding(.top, 5)
                
                Text("Readings")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                
                List {
                    ReadingRow(title: "Post Dinner levels", time: "At 10:00 pm", value: "143 mg/dl")
                    ReadingRow(title: "Post Workout levels", time: "At 6:00 pm", value: "135 mg/dl")
                    ReadingRow(title: "Post Lunch levels", time: "At 3:00 pm", value: "130 mg/dl")
                }
                .listStyle(PlainListStyle())
            }
        }
    }
    
    struct BloodSugarGraphView: View {
        let title: String
        let data: [Double]
        
        var body: some View {
            VStack {
                Text(title)
                    .font(.headline)
                    .padding(.top)
                
                Chart {
                    ForEach(Array(data.enumerated()), id: \ .offset) { index, value in
                        LineMark(
                            x: .value("Index", index),
                            y: .value("Blood Sugar", value)
                        )
                        .foregroundStyle(Color(hex : "#6CAB9C"))
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) // Moves Y-axis labels to the right
                }
                .frame(width : 350, height: 200)
                .padding()
                
            }
        }
    }
    
    struct PageIndicator: View {
        @Binding var selectedIndex: Int
        let count: Int
        
        var body: some View {
            HStack(spacing: 8) {
                ForEach(0..<count, id: \ .self) { index in
                    Circle()
                        .frame(width: 8, height: 8)
                        .foregroundColor(index == selectedIndex ? .black : .gray.opacity(0.5))
                }
            }
        }
    }
    
    struct ReadingRow: View {
        let title: String
        let time: String
        let value: String
        
        var body: some View {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    Text(time)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(value)
                    .bold()
            }
            .padding()
        }
    }
    
    struct TrackingView_Previews: PreviewProvider {
        static var previews: some View {
            TrackingView()
        }
    }
   
}




extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#") // Remove # if present
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}
#Preview{
    TrackingView()
}




