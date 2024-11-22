import Foundation
import SwiftUI
import MapKit
import CoreLocation
import SwiftData

@Observable
class MapViewModel {
    let modelContext: ModelContext
    let networkService: NetworkService
    let cacheService: CacheService
    
    // MARK: - Data State
    var centers: [RecyclingCenter] = []
    var filteredCenters: [RecyclingCenter] = []
    var isLoading = false
    
    // MARK: - Search State
    var searchText = ""
    var showingSearchResults = false
    
    var filteredMarkers: [RecyclingCenter] {
        guard !searchText.isEmpty else { return filteredCenters }
        return filteredCenters.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Selection State
    var selectedCenter: RecyclingCenter?
    var selectedMarker: RecyclingCenter?
    var isSheetPresented = false
    
    // MARK: - Map State
    var position: MapCameraPosition = .camera(MapCamera(
        centerCoordinate: .monterrey,
        distance: 1000,
        heading: 0,
        pitch: 0
    ))
    
    var region = MKCoordinateRegion(
        center: .monterrey,
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        self.networkService = NetworkService()
        self.cacheService = CacheService(modelContext: modelContext)
    }
}
