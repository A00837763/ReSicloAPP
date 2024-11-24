//
//  HistorialReciclajeView.swift
//  ResicloApp
//
//  Created by Diego Esparza on 16/11/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct HistorialReciclajeView: View {
    @State private var historial: [ReciclajeData] = []

    var body: some View {
        NavigationView {
            List(historial) { item in
                VStack(alignment: .leading) {
                    Text("Material: \(item.material)")
                        .font(.headline)
                    Text("Kilos: \(item.kilos)")
                    Text("Puntos: \(item.puntos)")
                    Text("Fecha: \(item.timestamp.dateValue().formatted())")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                .padding()
            }
            .navigationTitle("Historial de Reciclaje")
            .onAppear {
                cargarHistorial()
            }
        }
    }

    func cargarHistorial() {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let db = Firestore.firestore()
        db.collection("Users").document(userID).collection("Reciclaje").order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error al cargar el historial: \(error.localizedDescription)")
                    return
                }
                
                self.historial = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    return ReciclajeData(
                        id: document.documentID,
                        kilos: data["kilos"] as? Int ?? 0,
                        material: data["material"] as? String ?? "",
                        puntos: data["puntos"] as? Int ?? 0,
                        timestamp: data["timestamp"] as? Timestamp ?? Timestamp()
                    )
                } ?? []
            }
    }
}

struct ReciclajeData: Identifiable {
    var id: String
    var kilos: Int
    var material: String
    var puntos: Int
    var timestamp: Timestamp
}
