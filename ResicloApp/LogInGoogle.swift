// En primer lugar, asegúrate de tener estos imports
import GoogleSignIn
import FirebaseAuth
import Firebase

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    func configurarGoogle() {
        // Configura Firebase (añade esto en tu AppDelegate)
        FirebaseApp.configure()
    }
    
    func iniciarSesionConGoogle(desde viewController: UIViewController, completion: @escaping (Result<User, Error>) -> Void) {
        // Configura el cliente de Google con tu ID de cliente
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Inicia el proceso de inicio de sesión
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { [weak self] result, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else {
                let error = NSError(domain: "com.tuapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Falta token de autenticación"])
                completion(.failure(error))
                return
            }
            
            // Crear credencial para Firebase
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)
            
            // Autenticar con Firebase
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let user = result?.user {
                    completion(.success(user))
                }
            }
        }
    }
    
    func cerrarSesion() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
    }
}

// Ejemplo de uso en un ViewController
class LoginViewController: UIViewController {
    
    @IBAction func googleSignInTapped(_ sender: UIButton) {
        AuthenticationManager.shared.iniciarSesionConGoogle(desde: self) { result in
            switch result {
            case .success(let user):
                print("Usuario autenticado: \(user.uid)")
                // Navegar a la siguiente pantalla
                self.navegarAPantallaPrincipal()
            case .failure(let error):
                print("Error en autenticación: \(error.localizedDescription)")
                self.mostrarError(error)
            }
        }
    }
    
    private func mostrarError(_ error: Error) {
        let alert = UIAlertController(
            title: "Error",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navegarAPantallaPrincipal() {
        // Implementa la navegación a tu pantalla principal
    }
}
