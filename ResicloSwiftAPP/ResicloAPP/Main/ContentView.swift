import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var showStartPage = true
    @StateObject private var authManager = AuthenticationManager.shared

    var body: some View {
        ZStack {
            if showStartPage {
                StartPage(showStartPage: $showStartPage)
            } else if authManager.isAuthenticated {
                MainTabView()
            } else {
                MainTabView()
            }
        }
        .onAppear {
            verificarEstadoDeAutenticacion()
        }
    }

    private func verificarEstadoDeAutenticacion() {
        if let user = Auth.auth().currentUser {
            authManager.isAuthenticated = true
            guardarDatosUsuarioEnFirestore(user: user)
        } else {
            authManager.isAuthenticated = false
        }
    }

    private func guardarDatosUsuarioEnFirestore(user: User) {
        let uid = user.uid
        let name = user.displayName ?? "Usuario Sin Nombre"
        let email = user.email ?? "Correo No Disponible"
        let photoURL = user.photoURL?.absoluteString

        // Llama al FirestoreManager para guardar los datos
        FirestoreManager.shared.guardarDatosUsuario(uid: uid, name: name, email: email, photoURL: photoURL)
    }
}
