import SwiftUI

struct HeaderView: View {
    let userName: String
    @Environment(\.presentationMode) var presentationMode
    @State private var showProfileView = false
    @ObservedObject var authManager = AuthenticationManager.shared

    var body: some View {
        HStack {
            Text("Hola, \(userName)")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                // Obtén la URL de la imagen de Firestore antes de mostrar ProfileView
                authManager.obtenerImagenDePerfilDesdeFirestore { url in
                    if let url = url {
                        authManager.profileImageURL = url // Asegúrate de actualizar la URL
                    }
                    showProfileView = true
                }
            }) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
            }
        }
        .foregroundStyle(.resicloGreen2)
        .sheet(isPresented: $showProfileView) {
            ProfileView(profileImageURL: authManager.profileImageURL) // Pasamos la URL desde Firebase Storage
        }
    }
}
