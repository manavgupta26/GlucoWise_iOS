import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoggedIn: Bool = false  // Track login status
    @State private var navigateToRegister: Bool = false

    @Environment(\.presentationMode) var presentationMode
    
    private let accentColor = Color(red: 108/255, green: 171/255, blue: 157/255)
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 60)
            
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            // Email Field
            TextField("Email", text: $email)
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            // Password Field
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                } else {
                    SecureField("Password", text: $password)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Forgot Password
            HStack {
                Spacer()
                NavigationLink(destination: ForgetPasswordView()) {
                    Text("Forgot Password?")
                        .foregroundColor(accentColor)
                }
                Spacer()
            }
            .padding(.horizontal, 30)
            
            Spacer()
            
            // Login Button
            Button(action: handleLogin) {
                HStack {
                    Spacer()
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(accentColor)
                .cornerRadius(10)
                .padding(.horizontal)
            }
            
            // Register Button
            HStack {
                Text("Don't have an account yet?")
                    .foregroundColor(.black)
                
                Button(action: {
                    navigateToRegister = true
                }) {
                    Text("Register")
                        .foregroundColor(accentColor)
                }
            }
            .padding(.top, 10)
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .fullScreenCover(isPresented: $isLoggedIn) {  // ✅ Full-screen transition
            ContentView()
        }
        .fullScreenCover(isPresented: $navigateToRegister) {
            RegistrationView()
        }
    }
    
    // ✅ Login Validation Function
    private func handleLogin() {
        let users = UserManager.shared.getAllUsers()
        
        if let user = users.first(where: { $0.emailId == email && $0.password == password }) {
            UserDefaults.standard.set(user.id, forKey: "currentUserId") // Save UserId to UserDefaults
            UserId = user.id! // Set the global UserId to the logged-in user's ID
            isLoggedIn = true  // Navigate to ContentView
        } else {
            alertMessage = "Invalid email or password. Please try again."
            showAlert = true
        }
    }
}
