//
//  ViewDataQR.swift
//  ResicloApp
//
//  Created by Diego Esparza on 16/11/24.
//

import SwiftUI

struct ViewDataQR: View {
    let qrData: String
    let material: String
    let kilos: Int
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("¡Felicitaciones! Acumulaste:")
                .font(.title)
                .bold()

            Text("Material: \(material)")
                .font(.body)

            Text("Kilos: \(kilos)")
                .font(.body)

            Button(action: onDismiss) {
                Text("Obtener puntos ♻️")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
