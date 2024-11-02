import Foundation
import MapKit
import SwiftUI

@Observable
class MapViewModel {
    var markers: [CollectionMarker] = []
    var filteredMarkers: [CollectionMarker] = []
    var selectedMarker: CollectionMarker?
    
    @MainActor
    func fetchMarkers() async {
        do {
            let url = URL(string: "https://apiecolana.com/api/v1/collection_centers/custom_map?state_id=19&town_id=&section=map")!
            let (data, _) = try await URLSession.shared.data(from: url)
            markers = try JSONDecoder().decode([CollectionMarker].self, from: data)
            filteredMarkers = markers
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func filterMarkers(in region: MKCoordinateRegion) {
        filteredMarkers = markers.filter { region.contains(coordinate: $0.coordinate) }
    }
}

extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let latDelta = span.latitudeDelta / 2.0
        let lngDelta = span.longitudeDelta / 2.0
        
        let maxLat = center.latitude + latDelta
        let minLat = center.latitude - latDelta
        let maxLng = center.longitude + lngDelta
        let minLng = center.longitude - lngDelta
        
        return (minLat...maxLat).contains(coordinate.latitude) &&
               (minLng...maxLng).contains(coordinate.longitude)
    }
}
