import SwiftUI
import MapKit

struct MapView: View {
    @State private var vm = MapViewModel()
    @State private var searchText = ""
    @State private var showingSearchResults = false
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: .monterrey,
            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
    )
    
    var locationManager: LocationManager

    var filteredMarkers: [CollectionMarker] {
        guard !searchText.isEmpty else { return vm.filteredMarkers }
        return vm.filteredMarkers.filter {
            $0.name.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                mapLayer
                searchResultsLayer
            }
            .searchable(text: $searchText, prompt: "Buscar centros de reciclaje")
            .onChange(of: searchText) { _, _ in
                showingSearchResults = true
            }
            .sheet(item: $vm.selectedMarker) { marker in
                MarkerDetailView(marker: marker)
                    .presentationDetents([.height(400)])
            }
            .task {
                await vm.fetchMarkers()
            }
        }
    }
    
    private var mapLayer: some View {
        Map(position: $position, selection: $vm.selectedMarker) {
            ForEach(vm.filteredMarkers) { marker in
                Marker(marker.name, systemImage: "leaf.circle.fill", coordinate: marker.coordinate)
                    .tint(.resicloGreen1)
                    .annotationTitles(.hidden)
                    .tag(marker)
            }
            
            if let userLocation = locationManager.currentLocation {
                Annotation("Your Location", coordinate: userLocation) {
                    Image(systemName: "location.circle.fill")
                        .foregroundColor(.blue)
                        .font(.title)
                }
            }
        }
        .mapStyle(.standard)
        .onChange(of: vm.selectedMarker) { oldValue, newValue in
            if let marker = newValue {
                selectMarker(marker)
            }
        }
    }

    @ViewBuilder
    private var searchResultsLayer: some View {
        if !searchText.isEmpty && showingSearchResults {
            SearchResultsView(
                markers: filteredMarkers,
                searchText: $searchText,
                showingResults: $showingSearchResults
            ) { marker in
                selectMarker(marker)
                searchText = ""
                showingSearchResults = false
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.horizontal)
            .padding(.top)
            .transition(.searchResults)
            .tint(.resicloGreen1)
        }
    }

    private func selectMarker(_ marker: CollectionMarker) {
        withAnimation(.easeInOut) {
            let adjustedCoordinate = CLLocationCoordinate2D(
                latitude: marker.coordinate.latitude - 0.0003,
                longitude: marker.coordinate.longitude
            )

            position = .region(MKCoordinateRegion(
                center: adjustedCoordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            ))
            vm.selectedMarker = marker
        }
    }
}

#Preview {
    MapView(locationManager: LocationManager())
}



