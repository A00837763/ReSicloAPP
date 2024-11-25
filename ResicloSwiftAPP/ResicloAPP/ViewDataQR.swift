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
       VStack(alignment: .leading, spacing: 16) {
           // Header
           HStack {
               Image(systemName: "checkmark.circle.fill")
                   .font(.system(size: 24))
                   .foregroundColor(Color("ResicloGreen1"))
               
               Text("¡Felicitaciones!")
                   .font(.title3)
                   .bold()
                   .foregroundColor(.primary)
           }
           
           // Separador
           Rectangle()
               .frame(height: 1)
               .foregroundColor(Color(.systemGray5))
           
           // Detalles
           VStack(alignment: .leading, spacing: 12) {
               DetailRow(icon: "leaf.fill", title: "Material", value: material)
               DetailRow(icon: "scalemass.fill", title: "Kilos", value: "\(kilos)")
               DetailRow(icon: "star.fill", title: "Puntos", value: "\(kilos * 10)")
           }
           
           Spacer()
           
           // Botón
           Button(action: onDismiss) {
               HStack {
                   Text("Obtener puntos")
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
       .background(Color(.systemBackground))
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
