import SwiftUI

struct ProfileView: View {
    // Add a state to check if image is available
    @State private var profileImage: UIImage? = nil
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Image and Name
                    VStack(spacing: 12) {
                        // Use a conditional to show default image or loaded image
                        Group {
                            if let image = profileImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                // Default image icon when no image is available
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(Color(.systemGray3))
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color(.systemGray5), lineWidth: 1)
                        )
                        
                        Text("Sarah Johnsson")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                    // User Settings Section
                    VStack(spacing: 0) {
                        SectionHeaderView(title: "User Settings")
                        
                        NavigationLink(destination: ChangePasswordView()) {
                            HStack {
                                Image(systemName: "lock")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                Text("Change Password")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                        }

                        Divider()
                            .padding(.leading)
                        
                        NavigationLink(destination: NotificationPreferencesView()) {
                            HStack {
                                Image(systemName: "bell")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                Text("Notification Preference")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // General Section
                    VStack(spacing: 0) {
                        SectionHeaderView(title: "General")
                        
                        NavigationLink(destination: Text("Progress Summary View")) {
                            HStack {
                                Image(systemName: "list.clipboard")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                Text("Calculate Hba1C")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                            .padding(.leading)
                        
                        NavigationLink(destination: HealthGoalsView()) {
                            HStack {
                                Image(systemName: "heart")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                Text("Health Goals")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                            .padding(.leading)
                        
                        NavigationLink(destination: RemindersView()) {
                            HStack {
                                Image(systemName: "alarm")
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.black)
                                Text("Reminders")
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                    
                    // Logout Button
                    Button(action: {
                        // Implement logout functionality
                        print("Logout tapped")
                    }) {
                        Text("Logout")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.4, green: 0.7, blue: 0.7))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                }
                .padding(.bottom, 20)
            }
            .background(Color(.systemGray6))
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // Here you would typically load the profile image
                // For demo purposes, we're leaving it nil to show the default icon
                // loadProfileImage()
            }
        }
    }
    
    // Function to load profile image (would connect to your data source)
    private func loadProfileImage() {
        // Example implementation - replace with your actual image loading code
        if let image = UIImage(named: "profileImage") {
            self.profileImage = image
        }
    }
}

// Custom Section Header View
struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .padding(.vertical, 8)
            Spacer()
        }
        .background(Color(.systemGray6))
    }
}

// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
