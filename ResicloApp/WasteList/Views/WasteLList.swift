//
//  WasteLList.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//

import SwiftUI

struct WasteLList: View {
    @Environment(ModelData.self) private var modelData
    @State private var showFavoritesOnly = false

    var filteredWastes: [WasteL] {
        let wastes = modelData.wastes.filter { waste in
            (!showFavoritesOnly || waste.isFavorite)
        }
        return Array(wastes)
    }

    var body: some View {
        NavigationView {
            List {
                Toggle(isOn: $showFavoritesOnly) {
                    Text("Favoritos")
                        .foregroundColor(Color("ResicloGreen2")) // Color del texto en el toggle
                }

                ForEach(filteredWastes) { waste in
                    NavigationLink {
                        WasteLDetail(waste: waste)
                    } label: {
                        WasteLRow(waste: waste)
                    }
                }
            }
            .navigationTitle("Tipos de desechos")
            .navigationBarTitleDisplayMode(.inline) // Para que el título sea centrado
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tipos de desechos")
                        .font(.headline)
                        .foregroundColor(Color("ResicloGreen1")) // Cambia el color del texto
                }
            }
            .tint(Color("ResicloGreen1")) // Color de los iconos de navegación, si es necesario
        }
    }
}

#Preview {
    WasteLList().environment(ModelData())
}


