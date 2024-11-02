// LastVisitMapView.swift
import SwiftUI
import MapKit

struct LastVisitMapView: View {
    let position: MapCameraPosition
    let onTapMap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Map {
                Annotation("Recycling Center", coordinate: .monterrey) {
                    Button {
                        onTapMap()
                    } label: {
                        Image(systemName: "leaf.circle.fill")
                            .font(.title)
                            .foregroundColor(.resicloGreen1)
                    }
                }
            }
            .mapStyle(.standard)
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture(perform: onTapMap)
            
            Text("Última visita ReSiclo")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.resicloBrown)
                .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity)
    }
}
