import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine
import SwiftData

@Observable
class MapViewModel {
    private var modelContext: ModelContext
    var markers: [CollectionMarker] = []
    var filteredMarkers: [CollectionMarker] = []
    var selectedMarker: CollectionMarker?
    var wasteLookup: [String: WasteInfo] = [:]
    var isLoading = false
    private let cacheDuration: TimeInterval = 24 * 60 * 60 // 24 hours
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    @MainActor
    func fetchMarkers() async {
        if let cachedData = loadFromCache() {
            self.markers = cachedData.markers
            self.filteredMarkers = cachedData.markers
            self.wasteLookup = cachedData.wasteLookup
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
            let descriptor = FetchDescriptor<StoredMarker>(sortBy: [SortDescriptor(\.lastUpdated)])
            let storedMarkers = try modelContext.fetch(descriptor)
            guard let lastUpdated = storedMarkers.first?.lastUpdated else { return true }
            return Date().timeIntervalSince(lastUpdated) > cacheDuration
        } catch {
            print("Error checking cache: \(error)")
            return true
        }
    }
    
    private func loadFromCache() -> (markers: [CollectionMarker], wasteLookup: [String: WasteInfo])? {
        do {
            let markerDescriptor = FetchDescriptor<StoredMarker>()
            let wasteDescriptor = FetchDescriptor<StoredWasteInfo>()
            
            let storedMarkers = try modelContext.fetch(markerDescriptor)
            let storedWastes = try modelContext.fetch(wasteDescriptor)
            
            if storedMarkers.isEmpty || shouldRefreshCache() {
                return nil
            }
            
            let markers = storedMarkers.map { $0.toCollectionMarker }
            let wasteLookup = Dictionary(
                uniqueKeysWithValues: storedWastes.map { ($0.id, $0.toWasteInfo) }
            )
            
            return (markers, wasteLookup)
        } catch {
            print("Error loading from cache: \(error)")
            return nil
        }
    }
    
    private func saveToCache(markers: [CollectionMarker], wasteLookup: [String: WasteInfo]) {
        do {
            try clearExistingCache()
            
            markers.forEach { marker in
                modelContext.insert(StoredMarker(from: marker))
            }

            wasteLookup.forEach { (id, info) in
                modelContext.insert(StoredWasteInfo(id: id, info: info))
            }
            
            try modelContext.save()
            
        } catch {
            print("Error saving to cache: \(error)")
        }
    }
    
    private func clearExistingCache() throws {
        let markerDescriptor = FetchDescriptor<StoredMarker>()
        let wasteDescriptor = FetchDescriptor<StoredWasteInfo>()
        
        let existingMarkers = try modelContext.fetch(markerDescriptor)
        let existingWastes = try modelContext.fetch(wasteDescriptor)
        
        existingMarkers.forEach { modelContext.delete($0) }
        existingWastes.forEach { modelContext.delete($0) }
    }
    
    @MainActor
    private func fetchFreshData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 1. Fetch wastes
            let wasteUrl = URL(string: "https://apiecolana.com/api/v1/wastes")!
            let (wasteData, _) = try await URLSession.shared.data(from: wasteUrl)
            let wasteResponse = try JSONDecoder().decode(WasteResponse.self, from: wasteData)
            
            wasteLookup = Dictionary(uniqueKeysWithValues: wasteResponse.data.map { waste in
                (waste.id, WasteInfo(name: waste.attributes.name, icon: waste.attributes.icon))
            })
            
            // 2. Fetch basic markers
            let url = URL(string: "https://apiecolana.com/api/v1/collection_centers/custom_map?state_id=19&town_id=&section=map")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let basicMarkers = try JSONDecoder().decode([BasicMarker].self, from: data)
            
            // 3. Create initial markers
            let initialMarkers = basicMarkers.map { marker in
                CollectionMarker(
                    id: marker.id,
                    name: marker.name,
                    lng: marker.lng,
                    lat: marker.lat,
                    address: marker.address,
                    schedule: nil,
                    wastes: []
                )
            }
            
            self.markers = initialMarkers
            self.filteredMarkers = initialMarkers
            
            // 4. Fetch details in parallel
            await withTaskGroup(of: Void.self) { group in
                for marker in basicMarkers {
                    group.addTask {
                        await self.fetchDetail(for: marker)
                    }
                }
            }
            
            saveToCache(markers: self.markers, wasteLookup: self.wasteLookup)
            
        } catch {
            print("Error: \(error)")
        }
    }
    
    @MainActor
    private func refreshDataInBackground() async {
        await fetchFreshData()
    }
        
    @MainActor
    func fetchDetail(for marker: BasicMarker) async {
        let detailUrl = URL(string: "https://apiecolana.com/api/v1/collection_centers/\(marker.id)")!
        do {
            let (detailData, _) = try await URLSession.shared.data(from: detailUrl)
            
            // Depuración: Imprimir JSON de detalle
            if let detailString = String(data: detailData, encoding: .utf8) {
                print("Detail JSON for Marker ID \(marker.id): \(detailString)")
            }
            
            // Decodificar detalladamente
            let detailedResponse = try JSONDecoder().decode(DetailResponse.self, from: detailData)
            guard let detailedMarker = detailedResponse.data.first else {
                print("No data found for marker \(marker.id)")
                return
            }

            
            if let index = self.markers.firstIndex(where: { $0.id == marker.id }) {
                self.markers[index] = CollectionMarker(
                    id: marker.id,
                    name: marker.name,
                    lng: marker.lng,
                    lat: marker.lat,
                    address: marker.address,
                    schedule: detailedMarker.attributes.schedule,
                    wastes: detailedMarker.relationships.wastes.data
                )
                self.filteredMarkers = self.markers
            }
        } catch {
            print("Error fetching details for marker \(marker.id): \(error)")
        }
    }
    
    // Optimizar la búsqueda
    func filterMarkers(searchText: String) {
        guard !searchText.isEmpty else {
            filteredMarkers = markers
            return
        }
        
        filteredMarkers = markers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.address.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func filterMarkers(in region: MKCoordinateRegion) {
        filteredMarkers = markers.filter { region.contains(coordinate: $0.coordinate) }
    }
    
    func getWasteInfo(for marker: CollectionMarker) -> [WasteInfo] {
        let wasteInfoList = marker.wastes.compactMap { wasteLookup[$0.id] }
        return wasteInfoList
    }
}
