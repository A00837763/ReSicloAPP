//
//  PreviewData.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 21/11/24.
//

import Foundation

import SwiftUI
import MapKit
import SwiftData

// MARK: - Preview Data
extension Array where Element == RecyclingCenter {
    static var previewCenters: [RecyclingCenter] {
        [
            .init(centerId: 1,
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
                  wasteCategories: []),
            .init(centerId: 2,
                  name: "EcoRecicla San Pedro",
                  desc: "Centro especializado en plásticos",
                  address: "Av. Vasconcelos 456",
                  city: "San Pedro",
                  state: "Nuevo León",
                  country: "México",
                  postalCode: "66220",
                  latitude: 25.6545,
                  longitude: -100.3424,
                  phone: "81-8765-4321",
                  email: "info@ecorecicla.com",
                  website: "www.ecorecicla.com",
                  operatingHours: [],
                  wasteCategories: [])
        ]
    }
}

// MARK: - Preview Helpers
extension LocationManager {
    static var preview: LocationManager {
        let manager = LocationManager()
        manager.currentLocation = .monterrey
        return manager
    }
}

extension MapViewModel {
    static var preview: MapViewModel {
        let vm = MapViewModel(modelContext: ModelContext(.preview))
        vm.centers = .previewCenters
        vm.filteredCenters = .previewCenters
        return vm
    }
}

extension ModelContainer {
    static var preview: ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        return try! ModelContainer(
            for: StoredRecyclingCenter.self,
            configurations: config
        )
    }
}
