//
//  ScannerParentView.swift
//  ResicloApp
//
//  Created by Diego Esparza on 16/11/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct ScannerParentView: View {
    @State private var showScanner = false // Controla cuándo mostrar el escáner

    var body: some View {
        VStack {
            // Botón para abrir el escáner
            Button("Escanear QR") {
                showScanner = true
            }
            .sheet(isPresented: $showScanner) {
                QRScannerView(
                    didFindCode: { result in
                        procesarCodigoQR(result) // Procesa el QR escaneado
                    },
                    handleSave: { kilos, material, puntos in
                        guardarReciclajeEnFirestore(kilos: kilos, material: material, puntos: puntos)
                    }
                )
            }
        }
        .padding()
        .navigationTitle("Escanear QR")
        .navigationBarTitleDisplayMode(.inline)
    }

    func procesarCodigoQR(_ codigo: String) {
        // Supongamos que el código QR contiene datos separados por ":" (material:kilos)
        let componentes = codigo.split(separator: ":")
        guard componentes.count == 2,
              let material = componentes.first,
              let kilosString = componentes.last,
              let kilos = Int(kilosString) else {
            print("Código QR inválido")
            return
        }

        // Lógica para convertir los datos a puntos
        let puntos = kilos * 1 // 1 punto por kilo (ajusta según tu lógica)

        // Guardar los datos en Firestore
        guardarReciclajeEnFirestore(kilos: kilos, material: String(material), puntos: puntos)
    }

    func guardarReciclajeEnFirestore(kilos: Int, material: String, puntos: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No se encontró un usuario autenticado.")
            return
        }

        let db = Firestore.firestore()
        let recordID = UUID().uuidString // Genera un ID único para cada registro
        let reciclajeData: [String: Any] = [
            "kilos": kilos,
            "material": material,
            "puntos": puntos,
            "timestamp": Timestamp(date: Date()) // Incluye la fecha/hora
        ]

        db.collection("Users").document(userID).collection("Reciclaje").document(recordID).setData(reciclajeData) { error in
            if let error = error {
                print("Error al guardar los datos: \(error.localizedDescription)")
            } else {
                print("Datos guardados exitosamente en Firestore.")
            }
        }
    }
}

#Preview {
    ScannerParentView()
}
