import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine
import SwiftData

@Observable
class MapViewModel {
    private var modelContext: ModelContext
    var centers: [RecyclingCenter] = []
    var filteredCenters: [RecyclingCenter] = []
    var selectedCenter: RecyclingCenter?
    var isLoading = false
    private let cacheDuration: TimeInterval = 24 * 60 * 60 // 24 hours
    private let baseURL = "http://10.22.193.104:8000/api"
    
    // Map-specific properties
    var region = MKCoordinateRegion(
        center: .monterrey,
        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    )
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func fetchCenters() async {
        if let cachedData = loadFromCache() {
            self.centers = cachedData
            self.filteredCenters = cachedData
            print("Loaded data from SwiftData cache")
            
            if shouldRefreshCache() {
                Task {
                    await refreshDataInBackground()
                }
            }
            return
        }
        
        await fetchFreshData()
    }
    
    private func shouldRefreshCache() -> Bool {
        do {
            let descriptor = FetchDescriptor<StoredRecyclingCenter>(sortBy: [SortDescriptor(\.lastUpdated)])
            let storedCenters = try modelContext.fetch(descriptor)
            guard let lastUpdated = storedCenters.first?.lastUpdated else { return true }
            return Date().timeIntervalSince(lastUpdated) > cacheDuration
        } catch {
            print("Error checking cache: \(error)")
            return true
        }
    }
    
    private func loadFromCache() -> [RecyclingCenter]? {
        do {
            let descriptor = FetchDescriptor<StoredRecyclingCenter>()
            let storedCenters = try modelContext.fetch(descriptor)
            
            if storedCenters.isEmpty || shouldRefreshCache() {
                return nil
            }
            
            return storedCenters.map { $0.toRecyclingCenter }
        } catch {
            print("Error loading from cache: \(error)")
            return nil
        }
    }
    
    private func saveToCache(centers: [RecyclingCenter]) {
        do {
            try clearExistingCache()
            
            centers.forEach { center in
                modelContext.insert(StoredRecyclingCenter(from: center))
            }
            
            try modelContext.save()
            
        } catch {
            print("Error saving to cache: \(error)")
        }
    }
    
    private func clearExistingCache() throws {
        let descriptor = FetchDescriptor<StoredRecyclingCenter>()
        let existingCenters = try modelContext.fetch(descriptor)
        existingCenters.forEach { modelContext.delete($0) }
    }
    
    @MainActor
    private func fetchFreshData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = URL(string: "\(baseURL)/centers")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let centers = try JSONDecoder().decode([RecyclingCenter].self, from: data)
            
            self.centers = centers
            self.filteredCenters = centers
            
            saveToCache(centers: centers)
            
        } catch {
            print("Error fetching centers: \(error)")
        }
    }
    
    @MainActor
    private func refreshDataInBackground() async {
        await fetchFreshData()
    }
    
    @MainActor
    func fetchNearbyCenters(location: CLLocationCoordinate2D, radius: Double = 10) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = URL(string: "\(baseURL)/centers/nearby?latitude=\(location.latitude)&longitude=\(location.longitude)&radius=\(radius)")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let nearbyCenters = try JSONDecoder().decode([RecyclingCenter].self, from: data)
            
            self.filteredCenters = nearbyCenters
            
        } catch {
            print("Error fetching nearby centers: \(error)")
        }
    }
    
    func filterCenters(searchText: String) {
        guard !searchText.isEmpty else {
            filteredCenters = centers
            return
        }
        
        filteredCenters = centers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText) ||
            $0.city.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func filterCenters(in region: MKCoordinateRegion) {
        filteredCenters = centers.filter { region.contains(coordinate: $0.coordinate) }
    }
    
    @MainActor
    func searchCenters(query: String? = nil, city: String? = nil, wasteType: String? = nil) async {
        isLoading = true
        defer { isLoading = false }
        
        var urlComponents = URLComponents(string: "\(baseURL)/centers/search")!
        var queryItems: [URLQueryItem] = []
        
        if let query = query { queryItems.append(URLQueryItem(name: "q", value: query)) }
        if let city = city { queryItems.append(URLQueryItem(name: "city", value: city)) }
        if let wasteType = wasteType { queryItems.append(URLQueryItem(name: "waste_type", value: wasteType)) }
        
        urlComponents.queryItems = queryItems
        
        do {
            let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
            let searchResults = try JSONDecoder().decode([RecyclingCenter].self, from: data)
            self.filteredCenters = searchResults
        } catch {
            print("Error searching centers: \(error)")
        }
    }
    
    // Helper methods for map interactions
    func centerMap(on center: RecyclingCenter) {
        region = MKCoordinateRegion(
            center: center.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
    }
    
    func updateRegion(_ newRegion: MKCoordinateRegion) {
        region = newRegion
        filterCenters(in: newRegion)
    }
}


