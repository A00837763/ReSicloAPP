import SwiftUI
import MapKit

struct MapView: View {
    @State private var vm = MapViewModel()
    @State private var searchText = ""
    @State private var currentSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    @State private var isPresented = false


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
            .sheet(isPresented: $isPresented, onDismiss: {
                vm.selectedMarker = nil
            }) {
                if let marker = vm.selectedMarker {
                    MarkerDetailView(marker: marker)
                }
            }
            .task {
                await vm.fetchMarkers()
            }
            .onAppear(){
                if let userLocation = locationManager.currentLocation {
                    position = .region(
                        MKCoordinateRegion(
                            center: userLocation,
                            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
                        )
                    )
                }
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
                    Image(systemName: "person.circle.fill")
                        .foregroundStyle(.blue)
                        .background(.white)
                        .clipShape(Circle())
                }
            }
        }
        .mapStyle(.standard)
        .mapControls(){
            MapUserLocationButton()
        }
        .onMapCameraChange { context in
            currentSpan = context.region.span

        }
        .onChange(of: vm.selectedMarker) {
            isPresented = vm.selectedMarker != nil
        }
        .onChange(of: vm.selectedMarker) { oldValue, newValue in
            if let marker = newValue {
                withAnimation(.easeInOut) {
                    position = .region(MKCoordinateRegion(
                        center: marker.coordinate,
                        span: currentSpan
                    ))
                }
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
                span: currentSpan
            ))
            vm.selectedMarker = marker
        }
    }
}

#Preview {
    MapView(locationManager: LocationManager())
}



