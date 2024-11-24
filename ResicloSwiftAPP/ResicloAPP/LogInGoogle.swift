//
//  LogInGoogle.swift
//  ResicloApp
//
//  Created by Diego Esparza on 16/11/24.
//

import GoogleSignIn
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SwiftUI

class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var isAuthenticated: Bool = false
    @Published var profileImageURL: URL? // Guarda la URL de la imagen de perfil en Firebase Storage
    
    func configurarGoogle() {
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
            
            guard let googleUser = result?.user,
                  let idToken = googleUser.idToken?.tokenString else {
                let error = NSError(domain: "com.tuapp", code: -1, userInfo: [NSLocalizedDescriptionKey: "Falta token de autenticación"])
                completion(.failure(error))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: googleUser.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let user = result?.user {
                    self?.isAuthenticated = true
                    self?.subirYGuardarImagenDePerfil(user: user, googleUser: googleUser, completion: completion)
                }
            }
        }
    }
    
    // Función para subir la imagen de perfil a la carpeta `PerfilUser/` en Firebase Storage y guardar la URL en Firestore
    private func subirYGuardarImagenDePerfil(user: User, googleUser: GIDGoogleUser, completion: @escaping (Result<(User, URL?), Error>) -> Void) {
        guard let imageURL = googleUser.profile?.imageURL(withDimension: 200) else {
            completion(.success((user, nil))) // No hay imagen de perfil
            return
        }
        
        let storageRef = Storage.storage().reference().child("PerfilUser/\(user.uid).jpg")
        
        // Descargar la imagen desde Google usando URLSession
        URLSession.shared.dataTask(with: imageURL) { data, response, error in
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Subir la imagen a Firebase Storage en la carpeta `PerfilUser/`
            storageRef.putData(data, metadata: nil) { [weak self] metadata, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Obtener la URL de descarga de Firebase Storage
                storageRef.downloadURL { url, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    
                    // Guarda la URL en Firestore y en el perfil local
                    if let url = url {
                        self?.profileImageURL = url
                        self?.guardarURLDeImagenEnFirestore(user: user, url: url) { // Guarda la URL en Firestore
                            completion(.success((user, url)))
                        }
                    }
                }
            }
        }.resume()
    }
    
    // Guardar la URL de la imagen en Firestore
    private func guardarURLDeImagenEnFirestore(user: User, url: URL, completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        // Guarda la URL en la colección `ProfileImg` usando el UID del usuario como documento
        db.collection("ProfileImg").document(user.uid).setData(["url": url.absoluteString], merge: true) { error in
            if let error = error {
                print("Error al guardar la URL de la imagen en Firestore: \(error)")
            } else {
                print("URL de la imagen de perfil guardada en Firestore")
            }
            completion() // Llama a la finalización
        }
    }
    
    // Función para obtener la URL de la imagen de Firestore al hacer clic en el icono de perfil
    func obtenerImagenDePerfilDesdeFirestore(completion: @escaping (URL?) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(nil)
            return
        }
        
        let db = Firestore.firestore()
        db.collection("ProfileImg").document(user.uid).getDocument { [weak self] document, error in
            if let document = document, document.exists,
               let urlString = document.get("url") as? String,
               let url = URL(string: urlString) {
                self?.profileImageURL = url
                completion(url)
            } else {
                print("No se encontró la URL de la imagen en Firestore o ocurrió un error")
                completion(nil)
            }
        }
    }
    
    func cerrarSesion() throws {
        try Auth.auth().signOut()
        GIDSignIn.sharedInstance.signOut()
        isAuthenticated = false
        profileImageURL = nil
    }
}
