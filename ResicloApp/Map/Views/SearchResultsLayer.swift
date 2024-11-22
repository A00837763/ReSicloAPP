//
//  SearchResultsLayer.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 21/11/24.
//

import SwiftUI

struct SearchResultsLayer: View {
    let markers: [RecyclingCenter]
    @Binding var searchText: String
    @Binding var showingResults: Bool
    let onMarkerSelected: (RecyclingCenter) -> Void
    
    var body: some View {
        if !searchText.isEmpty && showingResults {
            SearchResultsView(
                markers: markers,
                searchText: $searchText,
                showingResults: $showingResults
            ) { marker in
                onMarkerSelected(marker)
            }
            .frame(maxWidth: .infinity, maxHeight: 300)
            .padding(.horizontal)
            .padding(.top)
            .transition(.searchResults)
            .tint(.resicloGreen1)
        }
    }
}

