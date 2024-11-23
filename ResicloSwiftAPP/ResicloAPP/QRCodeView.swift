//
//  QRCodeView.swift
//  ResicloApp
//
//  Created by Diego Esparza on 13/11/24.
//

import SwiftUI
import UIKit

struct QRCodeView: View {
    let dataString: String
    @State private var qrImage: UIImage?

    var body: some View {
        VStack {
            if let qrImage = qrImage {
                Image(uiImage: qrImage)
                    .interpolation(.none)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                    .padding()
            } else {
                Text("Generando QR...")
                    .padding()
            }
        }
        .onAppear {
            self.qrImage = QRCodeGenerator.generateQRCode(from: dataString)
        }
    }
}
