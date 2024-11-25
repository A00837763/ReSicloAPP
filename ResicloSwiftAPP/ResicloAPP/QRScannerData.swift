//
//  QRScannerData.swift
//  ResicloApp
//
//  Created by Diego Esparza on 21/11/24.
//

import Foundation

/// Modelo para representar los datos escaneados de un QR
struct QRScannerData: Identifiable {
    let id = UUID()
    let material: String
    let kilos: Int
    
    var puntos: Int {
        Int(Double(kilos) * MaterialMultiplicador.obtenerMultiplicador(para: material))
    }
    
    init(material: String, kilos: Int) {
        self.material = material
        self.kilos = kilos
    }
    
    init?(qrData: String) {
        let components = qrData.split(separator: ":")
        guard components.count == 2,
              let kilos = Int(components[1]),
              MaterialMultiplicador.esMaterialValido(String(components[0])) else {
            return nil
        }
        self.material = String(components[0])
        self.kilos = kilos
    }
}
