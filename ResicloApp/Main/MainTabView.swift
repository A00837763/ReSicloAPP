import SwiftUI
import MapKit
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )
    @Environment(MapViewModel.self) private var vm
    @Environment(\.modelContext) private var modelContext
    @Environment(ModelData.self) private var modelData

    private let locationManager = LocationManager()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            CameraViewWrapper()
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                .tag(1)
            
            MapView(locationManager: locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(2)
            
            WasteLList()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(3)
        }
        .tint(Color("ResicloGreen2"))
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: StoredMarker.self,
        StoredWasteReference.self,
        StoredWasteInfo.self,
        WasteL.self, // Incluye el modelo WasteL
        configurations: config
    )
    let viewModel = MapViewModel(modelContext: container.mainContext)
    
    // Cargar datos desde JSON
    if let url = Bundle.main.url(forResource: "wasteLData", withExtension: "json"),
       let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        if let wastes = try? decoder.decode([WasteL].self, from: data) {
            for waste in wastes {
                container.mainContext.insert(waste)
            }
        }
    }
    
    return MainTabView()
        .modelContainer(container)
        .environment(viewModel)
        .environment(ModelData())
}

