import SwiftUI
import MapKit
import SwiftData

struct MapView: View {
    @Environment(MapViewModel.self) private var vm
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismissSearch) private var dismissSearch
    @State private var searchText = ""
    @State private var currentSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    @State private var isPresented = false
    @State private var selectedMarker: RecyclingCenter?
    @State private var showingSearchResults = false
    @FocusState private var searchIsFocused: Bool
    @State private var position: MapCameraPosition = .camera(MapCamera(
        centerCoordinate: .monterrey,
        distance: 1000,
        heading: 0, pitch: 0
    ))
    
    var locationManager: LocationManager

    var filteredMarkers: [RecyclingCenter] {
        guard !searchText.isEmpty else { return vm.filteredCenters }
        return vm.filteredCenters.filter {
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
                vm.selectedCenter = nil
                selectedMarker = nil
            }) {
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
            .onAppear() {
                if let userLocation = locationManager.currentLocation {
                    position = .camera(MapCamera(
                        centerCoordinate: userLocation,
                        distance: 800,
                        heading: 0, pitch: 0
                    ))
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
            ForEach(vm.filteredCenters) { marker in
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
        .ignoresSafeArea(.keyboard)
        .mapStyle(.standard)
        .mapControls(){
            MapUserLocationButton()
        }
        .onMapCameraChange { context in
            currentSpan = context.region.span
        }
        .onChange(of: selectedMarker) { oldValue, newValue in
            dismissKeyboard()
            if let marker = newValue {
                if let updatedMarker = vm.centers.first(where: { $0.id == marker.id }) {
                    vm.selectedCenter = updatedMarker
                    withAnimation(.easeInOut) {
                        let lookAtPoint = CLLocationCoordinate2D(
                            latitude: marker.coordinate.latitude - 0.0005,
                            longitude: marker.coordinate.longitude
                        )
                        position = .camera(MapCamera(
                            centerCoordinate: lookAtPoint,
                            distance: 800,
                            heading: 0, pitch: 0
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
                searchIsFocused = false
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
    
    private func selectMarker(_ marker: RecyclingCenter) {
         if let updatedMarker = vm.centers.first(where: { $0.id == marker.id }) {
             dismissKeyboard()
             selectedMarker = updatedMarker
             vm.selectedCenter = updatedMarker
             withAnimation(.easeInOut) {
                 let lookAtPoint = CLLocationCoordinate2D(
                     latitude: marker.coordinate.latitude - 0.0005,
                     longitude: marker.coordinate.longitude
                 )
                 position = .camera(MapCamera(
                     centerCoordinate: lookAtPoint,
                     distance: 1000,
                     heading: 0, pitch: 0
                 ))
             }
             isPresented = true
         }
     }
    
    private func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: StoredRecyclingCenter.self, configurations: config)
    
    let sampleCenters = [
        RecyclingCenter(
            centerId: 1,
            name: "Centro de Reciclaje MTY",
            desc: "Centro principal de reciclaje",
            address: "Av. Constitución 123",
            city: "Monterrey",
            state: "Nuevo León",
            country: "México",
            postalCode: "64000",
            latitude: 25.6867,
            longitude: -100.3161,
            phone: "81-1234-5678",
            email: "contacto@reciclaje.com",
            website: "www.reciclaje.com",
            operatingHours: [
                OperatingHours(day: "Lunes", openingTime: "9:00", closingTime: "18:00"),
                OperatingHours(day: "Martes", openingTime: "9:00", closingTime: "18:00")
            ],
            wasteCategories: [
                WasteCategory(categoryId: 1, name: "Papel", desc: "Todo tipo de papel", process: "Separar", tips: "Mantener seco"),
                WasteCategory(categoryId: 2, name: "Plástico", desc: "PET y HDPE", process: "Limpiar", tips: "Aplastar")
            ]
        ),
        RecyclingCenter(
            centerId: 2,
            name: "EcoRecicla San Pedro",
            desc: "Centro especializado en plásticos",
            address: "Av. Vasconcelos 456",
            city: "San Pedro",
            state: "Nuevo León",
            country: "México",
            postalCode: "66220",
            latitude: 25.6545,
            longitude: -100.3424,
            phone: "81-8765-4321",
            email: "info@ecorecicla.com",
            website: "www.ecorecicla.com",
            operatingHours: [
                OperatingHours(day: "Lunes", openingTime: "8:00", closingTime: "17:00"),
                OperatingHours(day: "Martes", openingTime: "8:00", closingTime: "17:00")
            ],
            wasteCategories: [
                WasteCategory(categoryId: 1, name: "Plástico", desc: "Todo tipo de plástico", process: "Lavar", tips: "Retirar etiquetas"),
                WasteCategory(categoryId: 2, name: "Vidrio", desc: "Botellas y frascos", process: "Separar por color", tips: "No romper")
            ]
        )
    ]
    
    // Create and configure MapViewModel
    let viewModel = MapViewModel(modelContext: container.mainContext)
    viewModel.centers = sampleCenters
    viewModel.filteredCenters = sampleCenters
    
    // Create LocationManager with mock location
    let locationManager = LocationManager()
    locationManager.currentLocation = CLLocationCoordinate2D(
        latitude: 25.6866,
        longitude: -100.3161
    )
    
    return MapView(locationManager: locationManager)
        .environment(viewModel)
        .modelContainer(container)
}
