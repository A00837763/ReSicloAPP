import SwiftUI
import MapKit

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var position = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6866, longitude: -100.3161),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    )

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            HomeView(selectedTab: $selectedTab)  // Replace with ScanView when available
                .tabItem {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
                .tag(1)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(2)
            
            HomeView(selectedTab: $selectedTab) // Replace with SearchView when available
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(3)
        }
        .tint(Color("ResicloGreen2"))
    }
}

#Preview {
    MainTabView()
}

