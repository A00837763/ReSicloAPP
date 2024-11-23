import GoogleSignIn
import FirebaseAuth
import Firebase
import SwiftUI // Asegúrate de importar SwiftUI para UIHostingController

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    func configurarGoogle() {
        // Configura Firebase (asegúrate de llamar a este método en AppDelegate)
        FirebaseApp.configure()
    }
    
    func iniciarSesionConGoogle(desde viewController: UIViewController, completion: @escaping (Result<(User, URL?), Error>) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
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
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let user = result?.user {
                    let photoURL = user.photoURL
                    completion(.success((user, photoURL)))
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
            case .success(let (user, photoURL)):
                print("Usuario autenticado: \(user.uid)")
                print("URL de la imagen de perfil: \(String(describing: photoURL))")
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
    
    
}
