import SwiftUI
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

struct StartPage: View {
    @Binding var showStartPage: Bool
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.05) {
                Spacer()
                
                Image("ResLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(geometry.size.width * 0.5, 200))
                
                VStack(spacing: 10) {
                    Text("RESICLO")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color("ResicloGreen1"))
                    
                    Text("Donde Juntos Sí Resiclamos")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(spacing: 15) {
                    // Botón de Google
                    Button(action: {
                        handleGoogleSignIn()
                    }) {
                        HStack {
                            Image("google_logo") // Asegúrate de añadir esta imagen a tus assets
                                .resizable()
                                .frame(width: 24, height: 24)
                                .padding(.leading)
                            
                            Text("Continuar con Google")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding()
                            
                            Spacer()
                        }
                        .frame(width: min(geometry.size.width * 0.8, 300))
                        .background(Color.white)
                        .cornerRadius(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 3)
                    }
                    
                    // Botón "Entrar"
                    Button(action: {
                        withAnimation {
                            showStartPage = false
                        }
                    }) {
                        Text("Entrar")
                            .frame(width: min(geometry.size.width * 0.8, 300))
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color("ResicloGreen1"))
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                    }
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
            .alert("Error de inicio de sesión", isPresented: $showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleGoogleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                errorMessage = "No se pudo obtener la información del usuario"
                showError = true
                return
            }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    showError = true
                    return
                }
                
                withAnimation {
                    showStartPage = false
                }
            }
        }
    }
}
