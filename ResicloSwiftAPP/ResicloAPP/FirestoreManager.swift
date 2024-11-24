//
//  FirestoreManager.swift
//  ResicloApp
//
//  Created by Diego Esparza on 16/11/24.
//
import FirebaseAuth
import FirebaseFirestore

class FirestoreManager {
    static let shared = FirestoreManager()
    private let db = Firestore.firestore()

    /// Guarda los datos del usuario en Firestore
    func guardarDatosUsuario(uid: String, name: String, email: String, photoURL: String?) {
        let userDocRef = db.collection("Usuarios").document(uid)

        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error al obtener los datos del usuario: \(error.localizedDescription)")
                return
            }

            let currentPoints = (document?.data()?["puntosTotales"] as? Int) ?? 0

            let userData: [String: Any] = [
                "name": name,
                "email": email,
                "photoURL": photoURL ?? "",
                "puntosTotales": currentPoints
            ]

            userDocRef.setData(userData, merge: true) { error in
                if let error = error {
                    print("Error al guardar los datos del usuario: \(error.localizedDescription)")
                } else {
                    print("Datos del usuario guardados correctamente.")
                }
            }
        }
    }

    /// Guarda los datos del reciclaje y actualiza los puntos del usuario
    func guardarReciclaje(uid: String, kilos: Int, material: String, puntos: Int) {
        let userDocRef = db.collection("Usuarios").document(uid)

        userDocRef.getDocument { (document, error) in
            if let error = error {
                print("Error al obtener los datos del usuario: \(error.localizedDescription)")
                return
            }

            let currentPoints = (document?.data()?["puntosTotales"] as? Int) ?? 0
            let updatedPoints = currentPoints + puntos

            userDocRef.updateData([
                "puntosTotales": updatedPoints
            ]) { error in
                if let error = error {
                    print("Error al actualizar los puntos: \(error.localizedDescription)")
                } else {
                    print("Puntos actualizados correctamente.")
                }
            }

            let reciclajeData: [String: Any] = [
                "kilos": kilos,
                "material": material,
                "puntosGanados": puntos,
                "fecha": Date()
            ]

            userDocRef.collection("Reciclajes").addDocument(data: reciclajeData) { error in
                if let error = error {
                    print("Error al guardar los datos de reciclaje: \(error.localizedDescription)")
                } else {
                    print("Datos de reciclaje guardados correctamente.")
                }
            }
        }
    }

    /// Obtiene los datos del usuario desde Firestore
    func obtenerDatosUsuario(uid: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let userDocRef = db.collection("Usuarios").document(uid)

        userDocRef.getDocument { (document, error) in
            if let error = error {
                completion(.failure(error))
            } else if let document = document, document.exists, let data = document.data() {
                completion(.success(data))
            } else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No se encontraron datos para el usuario."])
                completion(.failure(error))
            }
        }
    }
}
