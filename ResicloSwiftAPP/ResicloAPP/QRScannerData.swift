//
//  QRScannerData.swift
//  ResicloApp
//
//  Created by Diego Esparza on 21/11/24.
//

import Foundation

/// Modelo para representar los datos escaneados de un QR
struct QRScannerData: Identifiable {
    let id = UUID() // Necesario para usarlo con `.sheet(item:)`
    let qrData: String
    let material: String
    let kilos: Int
}
