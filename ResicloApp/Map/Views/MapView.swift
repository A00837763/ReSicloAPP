import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Environment(MapViewModel.self) private var vm
    @Environment(\.modelContext) private var modelContext
    @State private var searchText = ""
    @State private var currentSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    @State private var isPresented = false
    @State private var selectedMarker: CollectionMarker?
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
                if vm.isLoading {
                    loadingLayer
                }
            }
            .searchable(text: $searchText, prompt: "Buscar centros de reciclaje")
            .onChange(of: searchText) { _, _ in
                showingSearchResults = true
            }
            .sheet(isPresented: $isPresented, onDismiss: {
                vm.selectedMarker = nil
                selectedMarker = nil
            }) {
                if let marker = vm.selectedMarker {
                    MarkerDetailView(marker: marker)
                        .environment(\.modelContext, modelContext)
                }
            }
            .task {
                if vm.markers.isEmpty {
                    await vm.fetchMarkers()
                }
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
    
    private var loadingLayer: some View {
        ZStack {
            Color.white.opacity(0.50)
                
            
            VStack(spacing: 20) {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.resicloGreen1)
                
                ProgressView()
                    .controlSize(.large)
                    .tint(.resicloGreen1)
                
                VStack(spacing: 8) {
                    Text("¡Estamos buscando centros cerca de ti!")
                        .font(.headline)
                        .foregroundStyle(.resicloGreen1)
                        .multilineTextAlignment(.center)
                    
                    Text("Juntos hacemos la diferencia")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
        }
        .transition(.opacity.combined(with: .scale))
    }
    
    private var mapLayer: some View {
        Map(position: $position, selection: $selectedMarker) {
            ForEach(vm.filteredMarkers) { marker in
                Marker(marker.name, systemImage: "leaf.circle.fill", coordinate: marker.coordinate)
                    .tint(.resicloGreen1)
                    .tag(marker)
                    .annotationTitles(.hidden)
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
        .onChange(of: selectedMarker) { oldValue, newValue in
            if let marker = newValue {
                if let updatedMarker = vm.markers.first(where: { $0.id == marker.id }) {
                    vm.selectedMarker = updatedMarker
                    withAnimation(.easeInOut) {
                        let adjustedCoordinate = CLLocationCoordinate2D(
                            latitude: marker.coordinate.latitude - 0.0003,
                            longitude: marker.coordinate.longitude
                        )
                        position = .region(MKCoordinateRegion(
                            center: adjustedCoordinate,
                            span: currentSpan
                        ))
                    }
                    isPresented = true
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
        if let updatedMarker = vm.markers.first(where: { $0.id == marker.id }) {
            selectedMarker = updatedMarker
            vm.selectedMarker = updatedMarker
            withAnimation(.easeInOut) {
                let adjustedCoordinate = CLLocationCoordinate2D(
                    latitude: marker.coordinate.latitude - 0.0003,
                    longitude: marker.coordinate.longitude
                )
                position = .region(MKCoordinateRegion(
                    center: adjustedCoordinate,
                    span: currentSpan
                ))
            }
            isPresented = true
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredMarker.self, StoredWasteReference.self, StoredWasteInfo.self, configurations: config)
    let viewModel = MapViewModel(modelContext: container.mainContext)
    
    return MapView(locationManager: LocationManager())
        .modelContainer(container)
        .environment(viewModel)
}
