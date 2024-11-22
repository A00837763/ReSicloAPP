//
//  MapLayerView.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 21/11/24.
//

import SwiftUI
import MapKit

struct MapLayerView: View {
    @Binding var position: MapCameraPosition
    @Binding var selectedMarker: RecyclingCenter?
    let centers: [RecyclingCenter]
    let userLocation: CLLocationCoordinate2D?
    let onMarkerSelected: (RecyclingCenter) -> Void
    
    var body: some View {
        Map(position: $position, selection: $selectedMarker) {
            // Centers Markers
            ForEach(centers) { marker in
                Marker(marker.name, systemImage: "leaf.circle.fill", coordinate: marker.coordinate)
                    .tint(.resicloGreen1)
                    .tag(marker)
                    .annotationTitles(.hidden)
            }
            
            // User Location Marker
            if let userLocation {
                Annotation("Your Location", coordinate: userLocation) {
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(.blue)
                        .background(.white)
                        .clipShape(Circle())
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .mapStyle(.standard)
        .mapControls {
            MapUserLocationButton()
        }
        .onChange(of: selectedMarker) { oldValue, newValue in
            if let marker = newValue {
                onMarkerSelected(marker)
            }
        }
    }
}

// Preview provider for development and testing
#Preview {
    let sampleCenters = [
        RecyclingCenter(
            centerId: 1,
            name: "Centro de Reciclaje MTY",
            desc: "Centro principal de reciclaje",
            address: "Av. Constitución 123",
            city: "Monterrey",
            state: "Nuevo León",
            country: "México",
            postalCode: "64000",
            latitude: 25.6867,
            longitude: -100.3161,
            phone: "81-1234-5678",
            email: "contacto@reciclaje.com",
            website: "www.reciclaje.com",
            operatingHours: [],
            wasteCategories: []
        )
    ]
    
    MapLayerView(
        position: .constant(.camera(MapCamera(
            centerCoordinate: .monterrey,
            distance: 1000,
            heading: 0,
            pitch: 0
        ))),
        selectedMarker: .constant(nil),
        centers: sampleCenters,
        userLocation: CLLocationCoordinate2D(
            latitude: 25.6866,
            longitude: -100.3161
        ),
        onMarkerSelected: { _ in }
    )
}
