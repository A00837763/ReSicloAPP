// LastVisitMapView.swift
import SwiftUI
import MapKit

struct LastVisitMapView: View {
   let position: MapCameraPosition
   let onTapMap: () -> Void
   
   var body: some View {
       VStack(alignment: .leading, spacing: 12) {
           // Header
           HStack {
               Image(systemName: "mappin.circle.fill")
                   .font(.system(size: 18))
                   .foregroundColor(Color("ResicloGreen1"))
               
               Text("Última Visita")
                   .font(.headline)
                   .foregroundColor(.primary)
               
               Spacer()
               
               Button(action: onTapMap) {
                   HStack(spacing: 4) {
                       Text("Ver más")
                           .font(.subheadline)
                       Image(systemName: "chevron.right")
                           .font(.system(size: 12))
                   }
                   .foregroundColor(Color("ResicloGreen1"))
               }
           }
           
           // Map
           Map {
               Annotation("Recycling Center", coordinate: .monterrey) {
                   Image(systemName: "leaf.circle.fill")
                       .font(.title)
                       .foregroundColor(Color("ResicloGreen1"))
               }
           }
           .mapStyle(.standard)
           .frame(maxWidth: .infinity)
           .frame(height: 160)
           .clipShape(RoundedRectangle(cornerRadius: 12))
           .onTapGesture(perform: onTapMap)
           
           // Location Info
           HStack {
               VStack(alignment: .leading, spacing: 4) {
                   Text("Centro de Reciclaje")
                       .font(.subheadline)
                       .foregroundColor(.primary)
                   Text("Monterrey, N.L.")
                       .font(.caption)
                       .foregroundColor(.secondary)
               }
               
               Spacer()
               
               Text("Hace 2 días")
                   .font(.caption)
                   .foregroundColor(.secondary)
           }
       }
       .padding()
       .background(
           RoundedRectangle(cornerRadius: 12)
            .fill(Color(.systemBackground))
               .shadow(
                   color: Color.black.opacity(0.2),
                   radius: 5,
                   x: 0,
                   y: 1
               )
       )
   }
}
