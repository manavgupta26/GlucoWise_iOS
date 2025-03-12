import SwiftUI

struct ProgressSummaryView: View {
    @State private var selectedPeriod: TimePeriod = .lastWeek
    
    // Sample data for glucose readings
    let maxReadings = [120, 137, 0, 150, 165, 136, 145]
    let minReadings = [100, 110, 0, 115, 0, 136, 123]
    let daysOfWeek = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Select Time Period")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Time period selector
                HStack(spacing: 0) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Button(action: {
                            selectedPeriod = period
                        }) {
                            Text(period.rawValue)
                                .padding(.vertical, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    selectedPeriod == period ?
                                        Color(red: 0.4, green: 0.7, blue: 0.6) :
                                        Color(UIColor.systemGray5)
                                )
                                .foregroundColor(selectedPeriod == period ? .white : .black)
                        }
                    }
                }
                .cornerRadius(8)
                .padding(.horizontal)
                
                // Chart legend
                HStack(spacing: 20) {
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color(red: 0.7, green: 0.85, blue: 0.75))
                            .frame(width: 16, height: 16)
                        Text("Max")
                            .font(.subheadline)
                    }
                    
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color(red: 0.4, green: 0.7, blue: 0.6))
                            .frame(width: 16, height: 16)
                        Text("Min")
                            .font(.subheadline)
                    }
                }
                .padding(.horizontal)
                
                // Bar chart
                ZStack {
                    // Y-axis labels and grid lines
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach([170.0, 127.5, 85.0, 42.5, 0.0].reversed(), id: \.self) { value in
                            HStack {
                                Text("\(Int(value))")
                                    .font(.caption)
                                    .frame(width: 40, alignment: .trailing)
                                
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(height: 1)
                            }
                            .frame(height: 85)
                        }
                    }
                    
                    // Bars
                    HStack(alignment: .bottom, spacing: 5) {
                        ForEach(0..<7, id: \.self) { index in
                            VStack(alignment: .center, spacing: 0) {
                                // Only show if data exists
                                if maxReadings[index] > 0 {
                                    ZStack(alignment: .top) {
                                        // Max reading bar
                                        VStack {
                                            Text("\(maxReadings[index])")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                            
                                            Rectangle()
                                                .fill(Color(red: 0.7, green: 0.85, blue: 0.75))
                                                .frame(width: 30, height: CGFloat(maxReadings[index]) * 0.5)
                                        }
                                        
                                        // Min reading bar (if exists)
                                        if minReadings[index] > 0 {
                                            VStack {
                                                Text("\(minReadings[index])")
                                                    .font(.caption)
                                                    .foregroundColor(.white)
                                                    .padding(.top, 24)
                                                
                                                Rectangle()
                                                    .fill(Color(red: 0.4, green: 0.7, blue: 0.6))
                                                    .frame(width: 30, height: CGFloat(minReadings[index]) * 0.5)
                                            }
                                            .padding(.top, CGFloat(maxReadings[index] - minReadings[index]) * 0.5)
                                        }
                                    }
                                }
                                
                                // X-axis label
                                Text(daysOfWeek[index])
                                    .font(.caption)
                                    .padding(.top, 5)
                            }
                            .frame(width: 40)
                        }
                    }
                    .padding(.leading, 40)
                }
                .frame(height: 420)
                .padding(.horizontal)
                
                // Insight card
                VStack(alignment: .leading) {
                    Text("Your highest glucose reading occurred on Saturday.")
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(Color(UIColor.systemGray6))
            .navigationTitle("Progress Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "arrow.left.circle.fill")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                        Text("Settings")
                            .foregroundColor(.green)
                    }
                }
            }
        }
    }
}

enum TimePeriod: String, CaseIterable {
    case lastWeek = "Last Week"
    case lastMonth = "Last Month"
    case lastThreeMonths = "Last 3 Months"
}

struct ProgressSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressSummaryView()
    }
}
