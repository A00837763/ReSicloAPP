//
//  GeneradorQr.swift
//  ResicloApp
//
//  Created by Diego Esparza on 13/11/24.
//

import SwiftUI

struct QRGeneratorView: View {
    @State private var material: String = ""
    @State private var kilos: String = ""
    @State private var showQRCode = false

    var body: some View {
        VStack(spacing: 16) {
            Text("Registrar Material Reciclado")
                .font(.headline)

            TextField("Material (ej. Plástico, Papel)", text: $material)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            TextField("Kilos reciclados", text: $kilos)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            Button(action: {
                showQRCode = true
            }) {
                Text("Generar Código QR")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .sheet(isPresented: $showQRCode) {
            let qrDataString = "Material: \(material) - Kilos: \(kilos)"
            QRCodeView(dataString: qrDataString)
        }
    }
}
