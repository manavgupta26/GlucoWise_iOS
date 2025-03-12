import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    @Environment(\.presentationMode) var presentationMode  // Allows going back to previous screen
    
    private let accentColor = Color(red: 108/255, green: 171/255, blue: 157/255)
    
    var body: some View {
        NavigationView {  // Wrap in NavigationView for navigation
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
                
                // Forgot Password - Now navigates to ForgetPasswordView
                HStack {
                    Spacer()
                    NavigationLink(destination: ForgetPasswordView()) {
                        Text("Forgot Password?")
                            .foregroundColor(accentColor)
                    }
                    Spacer()
                }
                .padding(.horizontal, 30)
                
                Spacer() // Pushes elements to the bottom
                
                // Login Button
                Button(action: {
                    print("Login tapped")
                }) {
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
                
                // Register Button - Takes user back to previous screen
                HStack {
                    Text("Don't have an account yet?")
                        .foregroundColor(.black)
                    
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Register")
                            .foregroundColor(accentColor)
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 0)
            }
            .padding()
            .navigationBarBackButtonHidden(true) // Hides the back button
        }
    }
}

// Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
