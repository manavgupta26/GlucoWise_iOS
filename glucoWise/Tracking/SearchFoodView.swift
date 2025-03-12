import SwiftUI
struct SearchFoodView: View {
    let mealType: String
    @StateObject private var viewModel = FoodSearchViewModel()
    
    var body: some View {
        VStack {
            SearchBar(viewModel: viewModel)
            Spacer()
        }
        .navigationTitle("Search Food")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Custom search bar
struct SearchBar: View {
    @ObservedObject var viewModel: FoodSearchViewModel
    
    var body: some View {
        VStack {
            TextField("Search food...", text: $viewModel.searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            // Display search recommendations
            List(viewModel.foodResults, id: \.self) { food in
                Text(food)
            }
            .frame(height: 200) // Limit height
        }
    }
}




import Combine

class FoodSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var foodResults: [String] = [] // Store food recommendations
    private var cancellables = Set<AnyCancellable>()
    private var appID = "49219ebc"
    private let apiKey = "e2d5d197d5b45aea88bea1b99c5317e6"
    
    
       init() {
           // Observe search text changes and fetch data
           $searchText
               .debounce(for: .milliseconds(500), scheduler: RunLoop.main) // Debounce to limit API calls
               .removeDuplicates()
               .sink { [weak self] text in
                   if !text.isEmpty {
                       self?.fetchFoodResults(query: text)
                   } else {
                       self?.foodResults = []
                   }
               }
               .store(in: &cancellables)
       }
       
       func fetchFoodResults(query: String) {
           guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
           let urlString = "https://trackapi.nutritionix.com/v2/search/instant?query=\(encodedQuery)"
           guard let url = URL(string: urlString) else { return }
           
           var request = URLRequest(url: url)
           request.addValue(appID, forHTTPHeaderField: "x-app-id")   // ✅ Corrected header
           request.addValue(apiKey, forHTTPHeaderField: "x-app-key") // ✅ Corrected header
           
           URLSession.shared.dataTaskPublisher(for: request)
               .map { $0.data }
               .decode(type: NutritionixResponse.self, decoder: JSONDecoder())
               .receive(on: DispatchQueue.main)
               .sink(receiveCompletion: { completion in
                   if case .failure(let error) = completion {
                       print("API Error: \(error)")
                   }
               }, receiveValue: { [weak self] response in
                   self?.foodResults = response.common.map { $0.food_name }
               })
               .store(in: &cancellables)
       }
   }

   // API Response Model
   struct NutritionixResponse: Codable {
       let common: [FoodItem]
   }

   struct FoodItem: Codable {
       let food_name: String
   }
