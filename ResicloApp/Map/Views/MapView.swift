// MapView.swift
import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MarkerViewModel()
    @State private var searchText = ""
    @State private var showingSearchResults = false
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: .monterrey,
            span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        )
    )
    
    var filteredMarkers: [CollectionMarker] {
        guard !searchText.isEmpty else { return viewModel.filteredMarkers }
        return viewModel.filteredMarkers.filter {
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
            .sheet(item: $viewModel.selectedMarker) { marker in
                MarkerDetailView(marker: marker)
                    .presentationDetents([.height(400)])
            }
            .task {
                await viewModel.fetchMarkers()
            }
        }
    }
    
    private var mapLayer: some View {
        Map(position: $position) {
            ForEach(viewModel.filteredMarkers) { marker in
                Annotation(marker.name, coordinate: marker.coordinate) {
                    RecyclingMarker {
                        selectMarker(marker)
                    }
                }
            }
        }
        .mapStyle(.standard)
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
                span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
            ))
            viewModel.selectedMarker = marker
        }
    }
}

// RecyclingMarker.swift
struct RecyclingMarker: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "leaf.circle.fill")
                .font(.title)
                .foregroundColor(.resicloGreen1)
                .shadow(radius: 1)
        }
    }
}

// SearchResultsView.swift
struct SearchResultsView: View {
    let markers: [CollectionMarker]
    @Binding var searchText: String
    @Binding var showingResults: Bool
    let onMarkerSelected: (CollectionMarker) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            searchHeader
            resultsList
        }
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private var searchHeader: some View {
        HStack {
            Text("Centros de Reciclaje")
                .font(.headline)
            Spacer()
            closeButton
        }
        .padding()
        .background(.ultraThinMaterial)
    }
    
    private var closeButton: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                searchText = ""
                showingResults = false
            }
        } label: {
            Image(systemName: "xmark.circle.fill")
                .foregroundStyle(.secondary)
                .font(.title3)
        }
    }
    
    private var resultsList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                if markers.isEmpty {
                    EmptyResultsView()
                } else {
                    resultsContent
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
    }
    
    private var resultsContent: some View {
        ForEach(markers) { marker in
            SearchResultRow(marker: marker) {
                withAnimation(.spring(duration: 0.3)) {
                    onMarkerSelected(marker)
                }
            }
            
            if marker.id != markers.last?.id {
                Divider()
                    .padding(.leading, 56)
                    .padding(.trailing, 16)
            }
        }
        .padding(.vertical, 8)
    }
}

// EmptyResultsView.swift
struct EmptyResultsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 40))
                .foregroundColor(.resicloGreen1)
                .padding(.bottom, 4)
            
            Text("No encontramos centros de reciclaje")
                .font(.system(size: 17, weight: .medium))
            
            Text("Intenta con otra búsqueda")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
    }
}

// SearchResultRow.swift
struct SearchResultRow: View {
    let marker: CollectionMarker
    let onSelect: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                markerIcon
                markerDetails
                chevronIcon
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(pressedBackground)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .pressAction { isPressed in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isPressed = isPressed
            }
        }
    }
    
    private var markerIcon: some View {
        Image(systemName: "leaf.circle.fill")
            .font(.title2)
            .foregroundColor(.resicloGreen1)
            .frame(width: 24)
    }
    
    private var markerDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(marker.name)
                .font(.system(size: 17, weight: .medium))
            
            Text(marker.address)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.secondary)
    }
    
    private var pressedBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isPressed ? Color.gray.opacity(0.1) : Color.clear)
    }
}

// PressAction.swift
struct PressAction: ViewModifier {
    let onPress: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content.onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: onPress, perform: {})
    }
}

extension View {
    func pressAction(onPress: @escaping (Bool) -> Void) -> some View {
        modifier(PressAction(onPress: onPress))
    }
}

// Extensions.swift

// Transitions.swift
extension AnyTransition {
    static var searchResults: AnyTransition {
        .asymmetric(
            insertion: .opacity.combined(with: .move(edge: .top)),
            removal: .opacity.combined(with: .move(edge: .top))
        )
    }
}

#Preview {
    MapView()
}
