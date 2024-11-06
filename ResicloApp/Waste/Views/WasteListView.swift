//
//  WasteListView.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//

import SwiftUI

struct WasteList: View {
    @Environment(ModelData.self) private var modelData
    @State private var showFavoritesOnly = false

    var filteredWastes: [Waste] {
        modelData.wastes.filter { waste in
            (!showFavoritesOnly || waste.isFavorite)
        }
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Solo favoritos")
                }

                ForEach(filteredWastes) { waste in
                    NavigationLink {
                        WasteDetail(waste: waste)
                    } label: {
                        WasteRow(waste: waste)
                    }
                }
            }
            .navigationTitle("Tipos de desechos")
        }
    }
}

#Preview {
    WasteList().environment(ModelData())
}



