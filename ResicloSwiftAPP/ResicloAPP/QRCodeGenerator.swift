//
//  QRCodeGenerator.swift
//  ResicloApp
//
//  Created by Diego Esparza on 15/11/24.
//

import CoreImage
import UIKit

struct QRCodeGenerator {
    /// Genera una imagen de código QR a partir de un string
    /// - Parameter string: El string que será codificado en el QR
    /// - Returns: Una imagen de tipo `UIImage` con el código QR generado, o `nil` si ocurre un error
    static func generateQRCode(from string: String) -> UIImage? {
        // Crea un filtro de código QR
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            print("Error: No se pudo crear el filtro CIQRCodeGenerator")
            return nil
        }
        
        // Configura el filtro con los datos del string
        let data = string.data(using: .utf8)
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("H", forKey: "inputCorrectionLevel") // Configuración de corrección de errores

        // Obtén la salida del filtro
        guard let ciImage = filter.outputImage else {
            print("Error: No se pudo generar la imagen del código QR")
            return nil
        }
        
        // Escala la imagen para mejorar la calidad visual
        let transform = CGAffineTransform(scaleX: 10, y: 10) // Escala por 10 para hacerlo más grande
        let scaledCIImage = ciImage.transformed(by: transform)
        
        // Convierte `CIImage` a `UIImage`
        let context = CIContext()
        if let cgImage = context.createCGImage(scaledCIImage, from: scaledCIImage.extent) {
            return UIImage(cgImage: cgImage)
        } else {
            print("Error: No se pudo convertir la imagen CI a UIImage")
            return nil
        }
    }
}
