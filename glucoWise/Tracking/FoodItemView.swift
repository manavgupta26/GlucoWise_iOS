//
//  FoodItemView.swift
//  glucoWise
//
//  Created by Manav Gupta on 09/03/25.
//
import SwiftUI
import SwiftUI

struct FoodDetailView: View {
    @State private var selectedServings: Double = 1.0
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Image("aloo_paratha")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(10)
                        .padding(.horizontal)

                    Text("Servings")
                        .font(.headline)
                        .foregroundColor(.gray)

                    HStack {

                        Spacer() // Push picker to the trailing side

                        Picker(selection: $selectedServings, label: Image(systemName: "chevron.down")) { // Use a custom label
                            ForEach(1..<11, id: \.self) { num in
                                Text("\(num).0").tag(Double(num)) // Convert Int to Double
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)


                    

                    Text("GI Index")
                        .font(.headline)
                        .foregroundColor(.gray)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.green.opacity(0.8))
                                .frame(width: 40, height: 40)
                                .overlay(Text("GI").foregroundColor(.white))

                            Text("80")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        Text("Glycemic Index")
                            .font(.headline)
                        Text("It will take 40 minutes of running to burn 400 calories. Your meal has high carbs. Add more fibre or protein in your next meal to help stabilize blood sugar.")
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    Text("Macronutrient Breakdown")
                        .font(.headline)
                        .foregroundColor(.gray)

                    VStack(spacing: 8) {
                        NutrientsRow(name: "Carbs", amount: "73 g")
                        NutrientsRow(name: "Protein", amount: "19 g")
                        NutrientsRow(name: "Fats", amount: "21 g")
                        NutrientsRow(name: "Fiber", amount: "9 g")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Aloo Paratha") // Set the title in Navigation Bar
            .navigationBarTitleDisplayMode(.inline) // Optional: Makes it appear inline
        }
    }
}


struct NutrientsRow: View {
    let name: String
    let amount: String
    
    var body: some View {
        HStack {
            Text(name)
                .font(.body)
                .foregroundColor(.primary)
            Spacer()
            Text(amount)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct FoodDetailView_Previews: PreviewProvider {
    static var previews: some View {
        FoodDetailView()
    }
}
