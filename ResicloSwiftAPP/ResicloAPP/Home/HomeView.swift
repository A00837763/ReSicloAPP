// HomeView.swift
import SwiftUI
import MapKit

struct HomeView: View {
    @Binding var selectedTab: Int
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: .monterrey,
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    )
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                HeaderView(userName: "Diego")
                Divider()
                
                HStack(spacing: 16) {
                    LastVisitMapView(position: position, onTapMap: { selectedTab = 2 })
                    PointsSummaryView(points: 1250, level: "Eco Guerrero")
                }
                .frame(height: 200)
                
                Divider()
                ActivityView()
                Divider()
                KnowledgeSection()
            }
            .padding()
        }
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
