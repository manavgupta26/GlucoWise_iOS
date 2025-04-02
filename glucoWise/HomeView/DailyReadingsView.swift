import SwiftUI

struct DailyReadingsView: View {
    var selectedDate: Date
    var readings: [BloodReading] // Declare without direct assignment

    // Custom initializer to assign readings
    init(selectedDate: Date) {
        self.selectedDate = selectedDate
        self.readings = UserManager.shared.getReadings(for: selectedDate)
    }

    var body: some View {
        VStack {
            Text("Blood Glucose Readings")
                .font(.title2)
                .bold()

            List(readings) { reading in
                HStack {
                    VStack(alignment: .leading) {
                        Text(reading.type.rawValue) // Example: "Post-Meal"
                            .font(.headline)
                        Text("At \(formattedTime(from: reading.date))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    Text("\(reading.value, specifier: "%.1f") mg/dL")
                        .font(.body)
                        .foregroundColor(reading.value > 180 ? .red : (reading.value > 120 ? .orange : .green))
                }
            }
        }
        .padding()
    }
}
