import SwiftUI

struct HeaderView: View {
    let userName: String
    @Environment(\.presentationMode) var presentationMode
    @Binding  var showProfileView: Bool
    @ObservedObject var authManager = AuthenticationManager.shared


    var body: some View {
        HStack {
            Text("Hola, \(userName)")
                .font(.title2)
                .fontWeight(.bold)
            Spacer()
        }
        .foregroundStyle(.resicloGreen1)
        .sheet(isPresented: $showProfileView) {
            ProfileView(profileImageURL: authManager.profileImageURL) // Pasamos la URL desde Firebase Storage
        }
    }
}

,
