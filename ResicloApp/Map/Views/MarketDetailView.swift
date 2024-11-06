import SwiftUI
import MapKit

struct MarkerDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var sheetHeight: PresentationDetent = .height(200)
    @Environment(MapViewModel.self) private var vm
    var marker: CollectionMarker
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 8) {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .clipShape(Capsule())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .top, spacing: 12) {
                        Label {
                            Text(marker.name)
                                .font(.title3.bold())
                                .fixedSize(horizontal: false, vertical: true)
                        } icon: {
                            Image(systemName: "leaf.circle.fill")
                                .font(.title2)
                                .foregroundColor(.resicloGreen1)
                        }
                        .padding(.trailing, 24)
                        
                        Spacer(minLength: 0)
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Label {
                        Text(marker.address)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } icon: {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.resicloGreen1)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    materialsView
                    scheduleView
                    Spacer(minLength: 100)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
            
            VStack(spacing: 0) {
                Divider()
                directionsButton
                    .padding()
                    .background(.regularMaterial)
            }
        }
        .presentationDetents([.height(200), .medium, .large], selection: $sheetHeight)
        .onAppear {
            sheetHeight = .height(200)
            vm.printMarkerDetails(for: marker.id)
        }
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        .presentationBackground(.regularMaterial)
        .presentationCornerRadius(12)
    }
    
    private var materialsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Materials Accepted:", systemImage: "trash.circle.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(vm.getWasteInfo(for: marker), id: \.name) { wasteInfo in
                    HStack(spacing: 8) {
                        if let iconUrl = wasteInfo.icon {
                            AsyncImage(url: URL(string: iconUrl)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                            } placeholder: {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                            }
                        } else {
                            Image(systemName: "circle.fill")
                                .font(.system(size: 6))
                        }
                        
                        Text(wasteInfo.name)
                            .font(.subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Spacer(minLength: 0)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private var scheduleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text("Opening Hours:")
                    .font(.headline)
            } icon: {
                Image(systemName: "clock.fill")
                    .foregroundColor(.resicloGreen1)
            }
            
            Text(marker.schedule ?? "No schedule available")
                .font(.subheadline)
                .padding(.leading, 28)
                .padding(.vertical, 4)
        }
    }
    
    private var directionsButton: some View {
        Button {
            if let url = URL(string: "maps://?daddr=\(marker.lat),\(marker.lng)") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("Get Directions", systemImage: "map.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.resicloGreen1)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
