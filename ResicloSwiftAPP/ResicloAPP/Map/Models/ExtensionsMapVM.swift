import SwiftUI
import MapKit
import CoreLocation

// MARK: - Data Operations
extension MapViewModel {
    @MainActor
    func fetchCenters() async {
        do {
            if let cachedData = try cacheService.loadFromCache() {
                self.centers = cachedData
                self.filteredCenters = cachedData
                if cacheService.shouldRefreshCache() {
                    Task { await refreshDataInBackground() }
                }
                return
            }
            await fetchFreshData()
        } catch {
            print("Error loading from cache: \(error)")
            await fetchFreshData()
        }
    }
    
    @MainActor
    private func fetchFreshData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let centers = try await networkService.fetchCenters()
            self.centers = centers
            self.filteredCenters = centers
            try cacheService.saveToCache(centers)
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
            self.filteredCenters = try await networkService.fetchNearbyCenters(
                location: location,
                radius: radius
            )
        } catch {
            print("Error fetching nearby centers: \(error)")
        }
    }
}

// MARK: - Map Interactions
extension MapViewModel {
    func selectMarker(_ marker: RecyclingCenter) {
        if let updatedMarker = centers.first(where: { $0.id == marker.id }) {
            selectedMarker = updatedMarker
            selectedCenter = updatedMarker
            updatePosition(for: updatedMarker)
            isSheetPresented = true
        }
    }
    
    func clearSelectedMarker() {
        selectedCenter = nil
        selectedMarker = nil
    }
    
    func updatePositionForUserLocation(_ location: CLLocationCoordinate2D) {
        position = .camera(MapCamera(
            centerCoordinate: location,
            distance: 800,
            heading: 0,
            pitch: 0
        ))
    }
    
    private func updatePosition(for marker: RecyclingCenter) {
        withAnimation(.easeInOut) {
            let lookAtPoint = CLLocationCoordinate2D(
                latitude: marker.coordinate.latitude - 0.0005,
                longitude: marker.coordinate.longitude
            )
            position = .camera(MapCamera(
                centerCoordinate: lookAtPoint,
                distance: 1000,
                heading: 0,
                pitch: 0
            ))
        }
    }
    
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

// MARK: - Search & Filtering
extension MapViewModel {
    func handleMarkerSelection(_ marker: RecyclingCenter) {
        selectMarker(marker)
        searchText = ""
        showingSearchResults = false
    }
    
    func filterCenters(in region: MKCoordinateRegion) {
        filteredCenters = centers.filter { region.contains(coordinate: $0.coordinate) }
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
    
    @MainActor
    func searchCenters(query: String? = nil, city: String? = nil, wasteType: String? = nil) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            self.filteredCenters = try await networkService.searchCenters(
                query: query,
                city: city,
                wasteType: wasteType
            )
        } catch {
            print("Error searching centers: \(error)")
        }
    }
}

