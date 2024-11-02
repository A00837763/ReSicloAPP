// MarkerDetailView.swift
import SwiftUI
import MapKit

struct MarkerDetailView: View {
    let marker: CollectionMarker
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            headerView
            materialsView
            scheduleView
            addressView
            Spacer()
            directionsButton
        }
        .padding()
    }
    
    private var headerView: some View {
        HStack {
            Label {
                Text(marker.name)
                    .font(.title3.bold())
                    .lineLimit(2)
            } icon: {
                Image(systemName: "leaf.circle.fill")
                    .font(.title2)
                    .foregroundColor(.resicloGreen1)
            }
            
            Spacer()
            
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.gray)
            }
        }
    }
    
    private var materialsView: some View {
        Label("Materials Accepted: Plastic", systemImage: "trash.circle.fill")
            .font(.headline)
            .foregroundColor(.resicloGreen1)
    }
    
    private var scheduleView: some View {
        VStack(alignment: .leading) {
            Label {
                Text("Opening Hours:")
                    .font(.headline)
            } icon: {
                Image(systemName: "clock.fill")
                    .foregroundColor(.resicloGreen1)
            }
            
            Text("Monday to Sunday, 8:00 AM - 8:00 PM")
                .font(.subheadline)
                .padding(.leading, 28)
        }
    }
    
    private var addressView: some View {
        Label {
            Text(marker.address)
                .font(.subheadline)
        } icon: {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.resicloGreen1)
        }
    }
    
    private var directionsButton: some View {
        Button {
            if let url = URL(string: "maps://?daddr=\(marker.lat),\(marker.lng)") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("Get Directions", systemImage: "map.fill")
                .frame(maxWidth: .infinity)
                .padding()
                .background(.resicloGreen1)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}
