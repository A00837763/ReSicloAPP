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
        
        // Normalize the search text first (remove accents)
        let normalizedSearch = searchText.folding(options: .diacriticInsensitive, locale: .current)
        
        return filteredCenters.filter { center in
            // Basic info match with normalized strings
            let basicInfoMatch = [
                center.name.folding(options: .diacriticInsensitive, locale: .current),
                center.address.folding(options: .diacriticInsensitive, locale: .current),
                center.city.folding(options: .diacriticInsensitive, locale: .current)
            ].contains { $0.localizedCaseInsensitiveContains(normalizedSearch) }
            
            // Waste categories match with normalized strings
            let categoryMatch = center.wasteCategories.contains { category in
                category.name.folding(options: .diacriticInsensitive, locale: .current)
                    .localizedCaseInsensitiveContains(normalizedSearch)
            }
            
            return basicInfoMatch || categoryMatch
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
