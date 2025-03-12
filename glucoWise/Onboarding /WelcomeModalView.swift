import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss  // Allows dismissing the modal

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("IconLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            Text("Welcome to")
                .font(.title)
                .fontWeight(.medium)

            Text("GlucoWise")
                .font(.system(size: 42, weight: .bold))

            VStack(spacing: 15) {
                Text("Take Control Of Your Diabetes Journey")
                    .font(.title3)
                    .fontWeight(.bold)

                Text("Your personalized health companion for staying active, eating right, and keeping your blood sugar in check.")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }

            Spacer()

            Button(action: {
                dismiss()  // Dismiss WelcomeView
            }) {
                Text("Continue")
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "6CAB9D"))
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
            }
            .padding(.bottom, 20)
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
