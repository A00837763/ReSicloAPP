import SwiftUI

// SearchResultsView.swift
struct SearchResultsView: View {
    let markers: [RecyclingCenter]
    @Binding var searchText: String
    @Binding var showingResults: Bool

    let onMarkerSelected: (RecyclingCenter) -> Void
    
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
