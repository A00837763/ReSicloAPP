//
//  WasteListView.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//


//
//  WasteListView.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//

import SwiftUI

struct WasteListView: View {
    @State private var viewModel = WasteViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.wastes) { waste in
                VStack(alignment: .leading) {
                    Text(waste.name ?? "Unnamed Waste")
                        .font(.headline)
                    if let description = waste.description {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Waste Types")
            .task {
                await viewModel.fetchWastes()
            }
        }
    }
}

#Preview {
    WasteListView()
}
