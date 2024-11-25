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
    
    private var puntos: Int {
        Int(Double(kilos) * MaterialMultiplicador.obtenerMultiplicador(para: material))
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Success Header
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color("ResicloGreen1"))
                    
                    VStack(alignment: .leading) {
                        Text("¡Felicitaciones!")
                            .font(.title3)
                            .bold()
                        Text("Has reciclado exitosamente")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // Details Section
                VStack(alignment: .leading, spacing: 16) {
                    DetailRow(icon: "leaf.fill", title: "Material", value: material)
                    DetailRow(icon: "scalemass.fill", title: "Kilos", value: String(format: "%.1f", Double(kilos)))
                    DetailRow(icon: "star.fill", title: "Puntos", value: "\(puntos)")
                        .font(.title3)
                }
                .padding(.vertical)
                
                // Impact Message
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tu impacto")
                        .font(.headline)
                    Text("Al reciclar \(kilos) kilos de \(material.lowercased()), has contribuido significativamente al medio ambiente.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                .padding(.vertical)
                
                Spacer()
                
                // Action Button
                Button(action: onDismiss) {
                    HStack {
                        Text("Guardar y Obtener Puntos")
                            .fontWeight(.semibold)
                        Image(systemName: "leaf.circle.fill")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("ResicloGreen1"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(color: Color("ResicloGreen1").opacity(0.3), radius: 4, x: 0, y: 2)
                }
            }
            .padding()
            .navigationBarItems(trailing: Button("Cerrar") {
                onDismiss()
            })
        }
    }
}

struct DetailRow: View {
   let icon: String
   let title: String
   let value: String
   
   var body: some View {
       HStack {
           Image(systemName: icon)
               .foregroundColor(Color("ResicloGreen1"))
           
           Text(title)
               .foregroundColor(.secondary)
           
           Spacer()
           
           Text(value)
               .fontWeight(.medium)
               .foregroundColor(.primary)
       }
   }
}
struct ViewDataQR_Previews: PreviewProvider {
   static var previews: some View {
       ViewDataQR(
           qrData: "123456",
           material: "Plástico",
           kilos: 5,
           onDismiss: {}
       )
       .padding()
   }
}
