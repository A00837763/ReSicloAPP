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
    @State private var showScanner = false
    @State private var showDataView = false
    @State private var scannedMaterial = ""
    @State private var scannedKilos = 0
    
    var body: some View {
        VStack {
            Button("Escanear QR") {
                showScanner = true
            }
            .sheet(isPresented: $showScanner) {
                QRScannerView(
                    didFindCode: { result in
                        procesarCodigoQR(result)
                    },
                    isPresented: $showScanner
                )
            }
            .sheet(isPresented: $showDataView) {
                ViewDataQR(
                    qrData: "",
                    material: scannedMaterial,
                    kilos: scannedKilos,
                    onDismiss: {
                        let puntos = Int(Double(scannedKilos) *
                            MaterialMultiplicador.obtenerMultiplicador(para: scannedMaterial))
                        guardarReciclajeEnFirestore(
                            kilos: scannedKilos,
                            material: scannedMaterial,
                            puntos: puntos
                        )
                        showDataView = false
                    }
                )
            }
        }
        .padding()
        .navigationTitle("Escanear QR")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func procesarCodigoQR(_ codigo: String) {
        let componentes = codigo.split(separator: ":")
        guard componentes.count == 2,
              let material = componentes.first,
              let kilosString = componentes.last,
              let kilos = Double(kilosString) else {
            print("QR inválido")
            return
        }
        
        scannedMaterial = String(material)
        scannedKilos = Int(kilos)
        showScanner = false
        showDataView = true
    }
    
    private func guardarReciclajeEnFirestore(kilos: Int, material: String, puntos: Int) {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("Usuario no autenticado")
            return
        }
        
        let db = Firestore.firestore()
        let recordID = UUID().uuidString
        let reciclajeData: [String: Any] = [
            "kilos": kilos,
            "material": material,
            "puntos": puntos,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("Users").document(userID)
          .collection("Reciclaje").document(recordID)
          .setData(reciclajeData) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Guardado exitoso")
            }
        }
    }
}
#Preview {
    ScannerParentView()
}
