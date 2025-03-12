import SwiftUI
struct AddReadingView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var bloodSugarReading: String = ""
    @State private var selectedTime = Date()
    @State private var selectedTag = "Fasting"
    
    let tags = ["Fasting", "Premeal", "Postmeal", "Preworkout", "Postworkout"]
    
    var onSave: (Reading) -> Void // Closure to send data back
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Blood Sugar Reading")) {
                    TextField("Enter reading", text: $bloodSugarReading)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Time of Reading")) {
                    DatePicker("Select Time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Tag")) {
                    Picker("Select Tag", selection: $selectedTag) {
                        ForEach(tags, id: \.self) { tag in
                            Text(tag)
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
                        let formatter = DateFormatter()
                        formatter.timeStyle = .short
                        let timeString = "At \(formatter.string(from: selectedTime))"
                        
                        let newReading = Reading(title: "\(selectedTag) levels", time: timeString, value: "\(bloodSugarReading) mg/dl")
                        
                        onSave(newReading) // Send new reading back
                        dismiss()
                    }
                }
            }
        }
    }
}
