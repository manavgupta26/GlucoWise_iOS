import SwiftUI

struct AddReadingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var bloodSugarReading: String = ""
    @State private var selectedTime = Date()
    @State private var selectedTag: BloodReadingType = .fasting
    
    let tags: [BloodReadingType] = [.fasting, .preMeal, .postMeal, .preWorkout, .postWorkout]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Blood Sugar Reading")) {
                    TextField("Enter reading", text: $bloodSugarReading)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Time of Reading")) {
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Tag")) {
                    Picker("Select Tag", selection: $selectedTag) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag.rawValue)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationTitle("Add Reading")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let value = Double(bloodSugarReading) {
                            let newReading = BloodReading(type: selectedTag, value: value, date: selectedTime)
                            
                            UserManager.shared.addBloodReading(newReading) // Save to the data model
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}
