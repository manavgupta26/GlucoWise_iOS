import SwiftUI
import Charts

struct HealthStatsView: View {
    var body: some View {
        VStack(spacing: 16) {
            HealthCard(title: "Calories burned", value: "120", unit: "Kcal", time: "8:00 AM", progress: 120/400) // Assuming goal = 400 Kcal
            HealthCard(title: "Workout Minutes", value: "30", unit: "Mins")
            HealthCard(title: "Steps", value: "6000", unit: "Steps", barValues: [2000, 3500, 5000, 4500, 6000])
            HealthCard(title: "Body Weight", value: "72", unit: "Kg", isButtonStyle: true)
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

struct HealthCard: View {
    var title: String
    var value: String
    var unit: String
    var time: String? = nil
    var progress: Double? = nil
    var barValues: [Double]? = nil
    var isButtonStyle: Bool = false

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                HStack {
                    Text(value)
                        .font(.largeTitle)
                        .bold()
                    Text(unit)
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            
            if let time = time {
                Text(time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            if let progress = progress {
                CircularProgressView(progress: progress)
                    .frame(width: 40, height: 40)
            } else if let barValues = barValues {
                BarChartView(values: barValues)
                    .frame(width: 80, height: 50)
            } else if isButtonStyle {
                WeightButton(value: value, unit: unit)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 2)
    }
}

struct CircularProgressView: View {
    var progress: Double // Progress from 0.0 to 1.0
    let progressColor = Color(hex: "#6CAB9C")

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 5)

            Circle()
                .trim(from: 0.0, to: progress)
                .stroke(progressColor, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

struct BarChartView: View {
    var values: [Double]
    let barColor = Color(hex: "#6CAB9C")

    var body: some View {
        Chart {
            ForEach(Array(values.enumerated()), id: \.offset) { index, value in
                BarMark(
                    x: .value("Day", index),
                    y: .value("Steps", value)
                )
                .foregroundStyle(index == values.count - 1 ? barColor : Color.gray.opacity(0.5))
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
    }
}

struct WeightButton: View {
    var value: String
    var unit: String

    var body: some View {
        Text("\(value) \(unit)")
            .font(.callout)
            .bold()
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color(.systemGray5))
            .cornerRadius(8)
    }
}

// Extension to support Hex Color in SwiftUI


struct HealthStatsView_Previews: PreviewProvider {
    static var previews: some View {
        HealthStatsView()
    }
}
