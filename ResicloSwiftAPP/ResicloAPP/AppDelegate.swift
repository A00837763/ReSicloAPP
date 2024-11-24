//
//  AppDelegate.swift
//  ResicloApp
//
//  Created by Diego Esparza on 05/11/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configura Firebase
        FirebaseApp.configure()
        
        // Agrega un listener para cambios de autenticación
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("Usuario autenticado: \(user.uid)")
                
                // Guardar datos del usuario en Firestore
                FirestoreManager.shared.guardarDatosUsuario(
                    uid: user.uid,
                    name: user.displayName ?? "Sin nombre",
                    email: user.email ?? "Sin email",
                    photoURL: user.photoURL?.absoluteString
                )
            } else {
                print("Usuario no autenticado.")
            }
        }
        
        return true
    }
    
    // Maneja Google Sign-In
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url) // Maneja el retorno de Google Sign-In si lo usas
    }
}
