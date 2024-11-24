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
            
            QRGeneratorView() // Vista de Generar QR
                .tabItem {
                    Label("Historial", systemImage: "qrcode")
                }
                .tag(1)
            
            CameraViewWrapper()
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                .tag(2)
            
            MapView(locationManager: locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(3)
            
            WasteLList()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(4)
        }
        .tint(Color("ResicloGreen2"))
    }
}

