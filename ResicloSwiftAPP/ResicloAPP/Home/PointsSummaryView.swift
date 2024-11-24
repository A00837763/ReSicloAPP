// PointsSummaryView.swift
import SwiftUI

struct PointsSummaryView: View {
   let points: Int
   let level: String
   
   var body: some View {
       VStack(alignment: .leading, spacing: 12) {
           // Header
           HStack {
               Image(systemName: "leaf.circle.fill")
                   .font(.system(size: 18))
                   .foregroundColor(Color("ResicloGreen1"))
               
               Text("Puntos Resiclo")
                   .font(.headline)
                   .foregroundColor(.primary)
           }
           
           // Separador sutil
           Rectangle()
               .frame(height: 1)
               .foregroundColor(Color(.systemGray5))
           
           // Puntos y Nivel
           VStack(alignment: .leading, spacing: 6) {
               // Puntos grandes
               Text("\(points)")
                   .font(.system(size: 36, weight: .bold))
                   .foregroundColor(Color("ResicloGreen1"))
               
               // Progreso
               HStack(spacing: 8) {
                   // Barra de progreso
                   ZStack(alignment: .leading) {
                       RoundedRectangle(cornerRadius: 4)
                           .fill(Color(.systemGray5))
                           .frame(width: 100, height: 8)
                       
                       RoundedRectangle(cornerRadius: 4)
                           .fill(Color("ResicloGreen1"))
                           .frame(width: 65, height: 8)
                   }
                   
                   Text(level)
                       .font(.subheadline)
                       .foregroundColor(.secondary)
               }
               
               // Meta
               Text("150 pts para siguiente nivel")
                   .font(.caption)
                   .foregroundColor(.secondary)
           }
       }
       .padding()
       .frame(maxWidth: .infinity, alignment: .leading)
       .background(
           RoundedRectangle(cornerRadius: 12)
               .fill(Color(.tertiarySystemBackground))
               .shadow(
                   color: Color.black.opacity(0.2),
                   radius: 5,
                   x: 0,
                   y: 2
               )
       )
   }
}
