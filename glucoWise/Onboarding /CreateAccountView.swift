import SwiftUI

struct RegistrationView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showPassword: Bool = false
    @State private var showWelcomeModal: Bool = true  // Show Welcome first
    @State private var navigateToProfileCompletion: Bool = false
    
    // Validation State
    @State private var isValidName: Bool = false
    @State private var isValidEmail: Bool = false
    @State private var isValidPassword: Bool = false
    
    var isFormValid: Bool {
        return isValidName && isValidEmail && isValidPassword && (password == confirmPassword)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Create a new account")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.vertical, 20)
                
                // Name field
                TextField("Name", text: $name)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onChange(of: name) { _ in validateName() }
                
                if !isValidName && !name.isEmpty {
                    Text("Invalid name. It should not contain numbers or special characters.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Email field
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onChange(of: email) { _ in validateEmail() }
                
                if !isValidEmail && !email.isEmpty {
                    Text("Invalid email format.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Password field
                SecureField("Password", text: $password)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onChange(of: password) { _ in validatePassword() }
                
                if !isValidPassword && !password.isEmpty {
                    Text("Password must be at least 5 letters, include 1 special character, and 1 number.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                // Confirm Password field with visibility toggle
                HStack {
                    if showPassword {
                        TextField("Confirm Password", text: $confirmPassword)
                    } else {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    
                    Button(action: {
                        showPassword.toggle()
                    }) {
                        Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                
                if password != confirmPassword && !confirmPassword.isEmpty {
                    Text("Passwords do not match.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                // Register button (enabled only if all validations pass)
                Button(action: {
                    navigateToProfileCompletion = true
                }) {
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: 350, height: 50)
                        .background(isFormValid ? Color(red: 0.4, green: 0.7, blue: 0.6) : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isFormValid)
                .padding(.bottom, 5)
                
                NavigationLink(destination: ProfileCompletionView(), isActive: $navigateToProfileCompletion) {
                    EmptyView()
                }
                
                // Navigation to LoginView
                NavigationLink(destination: LoginView()) {
                    Text("I already have an account.")
                        .foregroundColor(Color(hex: "6CAB9D"))
                        .fontWeight(.medium)
                        .underline()
                }
                .padding(.top,-30)
                .padding(.bottom, 10)
                
            }
            .sheet(isPresented: $showWelcomeModal) {
                WelcomeView()  // WelcomeView appears first
            }
        }
    }
    
    // Validation Functions
    private func validateName() {
        let nameRegex = "^[a-zA-Z ]+$"
        isValidName = NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
    }
    
    private func validateEmail() {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        isValidEmail = NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    private func validatePassword() {
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[!@#$%^&*(),.?\":{}|<>]).{5,}$"
        isValidPassword = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
