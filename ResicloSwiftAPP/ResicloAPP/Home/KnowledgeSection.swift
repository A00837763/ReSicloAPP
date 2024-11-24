// KnowledgeSection.swift
import Foundation
import SwiftUI

struct KnowledgeSection: View {
   @State private var isVisible = false

   var body: some View {
       VStack(alignment: .leading, spacing: 16) {
           // Header
           HStack {
               Image(systemName: "lightbulb.circle.fill")
                   .font(.system(size: 18))
                   .foregroundColor(Color("ResicloGreen1"))
               
               Text("Aprende & Participa")
                   .font(.headline)
                   .foregroundColor(.primary)
           }
           
           LazyVGrid(columns: [
               GridItem(.flexible(), spacing: 12),
               GridItem(.flexible(), spacing: 12)
           ], spacing: 12) {
               // Eventos con badge de "Nuevo"
               KnowledgeCard(
                   icon: "calendar",
                   title: "Eventos",
                   description: "Próximos eventos de reciclaje",
                   badgeText: "¡Nuevo!",
                   illustration: "figure.2.and.child.holdinghands"
               )
               .transition(.scale.combined(with: .opacity))
               .animation(.spring(dampingFraction: 0.8), value: isVisible)
               
               // Tips con contador
               KnowledgeCard(
                   icon: "lightbulb.fill",
                   title: "Tips",
                   description: "Aprende a usar la app",
                   badgeText: "3 Tips",
                   illustration: "leaf.arrow.circlepath"
               )
               .transition(.scale.combined(with: .opacity))
               .animation(.spring(dampingFraction: 0.8).delay(0.1), value: isVisible)
           }
       }
       .padding()
       .background(
           RoundedRectangle(cornerRadius: 12)
               .fill(Color(.tertiarySystemBackground))
               .shadow(
                   color: Color.black.opacity(0.1),
                   radius: 5,
                   x: 0,
                   y: 2
               )
       )
       .onAppear { isVisible = true }
   }
}

struct KnowledgeCard: View {
   let icon: String
   let title: String
   let description: String
   let badgeText: String
   let illustration: String
   
   var body: some View {
       Button(action: {}) {
           ZStack {
               // Patrón de fondo
               
               VStack(alignment: .leading, spacing: 12) {
                   // Header con badge
                   HStack {
                       Image(systemName: icon)
                           .font(.system(size: 20))
                           .foregroundColor(Color("ResicloGreen1"))
                       
                       Spacer()
                       
                       Text(badgeText)
                           .font(.caption2)
                           .fontWeight(.medium)
                           .foregroundColor(.white)
                           .padding(.horizontal, 8)
                           .padding(.vertical, 4)
                           .background(
                               Capsule()
                                   .fill(Color("ResicloGreen1"))
                                   .shadow(color: Color("ResicloGreen1").opacity(0.05), radius: 4, x: 0, y: 2)
                           )
                   }
                   
                   // Ilustración central
                   Image(systemName: illustration)
                       .font(.system(size: 40))
                       .foregroundStyle(
                           LinearGradient(
                               colors: [
                                   Color("ResicloGreen1").opacity(0.8),
                                   Color("ResicloGreen1").opacity(0.4)
                               ],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing
                           )
                       )
                       .frame(maxWidth: .infinity, alignment: .center)
                       .padding(.vertical, 8)
                   
                   // Información
                   Text(title)
                       .font(.subheadline)
                       .fontWeight(.semibold)
                       .foregroundColor(.primary)
                   
                   Text(description)
                       .font(.caption)
                       .foregroundColor(.secondary)
                       .lineLimit(2)
               }
               .padding()
           }
           .background(
               RoundedRectangle(cornerRadius: 12)
                   .fill(Color(.tertiarySystemBackground))
           )
           .shadow(
            color: Color(.black).opacity(0.05),
               radius: 8,
               x: 0,
               y: 4
           )
           .contentShape(Rectangle())
           .hoverEffect(.lift)
       }
   }
}

// Preview
struct KnowledgeSection_Previews: PreviewProvider {
   static var previews: some View {
       KnowledgeSection()
           .padding()
   }
}
