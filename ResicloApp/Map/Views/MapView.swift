import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Environment(MapViewModel.self) private var viewModel
    @Environment(\.modelContext) private var modelContext
    var locationManager: LocationManager
    
    var body: some View {
        @Bindable var vm = viewModel
        
        NavigationStack {
            ZStack(alignment: .top) {
                // Map Layer
                MapLayerView(
                    position: $vm.position,
                    selectedMarker: $vm.selectedMarker,
                    centers: vm.filteredCenters,
                    userLocation: locationManager.currentLocation,
                    onMarkerSelected: { marker in
                        dismissKeyboard()
                        vm.selectMarker(marker)
                    }
                )
                
                // Search Results Layer
                SearchResultsLayer(
                    markers: vm.filteredMarkers,
                    searchText: $vm.searchText,
                    showingResults: $vm.showingSearchResults
                ) { marker in
                    vm.handleMarkerSelection(marker)
                }
                
                // Loading Layer
                if vm.isLoading {
                    LoadingLayerView()
                }
            }
            .searchable(text: $vm.searchText, prompt: "Buscar centros de reciclaje")
            .onChange(of: vm.searchText) { _, _ in
                vm.showingSearchResults = true
            }
            .sheet(isPresented: $vm.isSheetPresented) {
                vm.clearSelectedMarker()
            } content: {
                if let marker = vm.selectedCenter {
                    CenterDetailView(center: marker)
                        .environment(\.modelContext, modelContext)
                }
            }
            .task {
                if vm.centers.isEmpty {
                    await vm.fetchCenters()
                }
            }
            .onAppear {
                if let userLocation = locationManager.currentLocation {
                    vm.updatePositionForUserLocation(userLocation)
                }
            }
        }
    }
}

private extension MapView {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,from: nil,for: nil)
    }
}

// Simplified Preview
#Preview {
    MapView(locationManager: .preview)
        .environment(MapViewModel.preview)
        .modelContainer(.preview)
}
