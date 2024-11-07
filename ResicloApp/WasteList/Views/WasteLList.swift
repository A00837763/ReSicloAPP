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
                        .foregroundColor(Color("ResicloGreen2"))
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(10)
                }

                ForEach(filteredWastes) { waste in
                    NavigationLink {
                        WasteLDetail(waste: waste)
                    } label: {
                        WasteLRow(waste: waste)
                    }
                    .transition(.move(edge: .leading))
                    //.animation(.easeInOut, value: filteredWastes)
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("ResicloGreen1"), Color("ResicloGreen2")]), startPoint: .top, endPoint: .bottom)
            )
            .navigationTitle("Tipos de desechos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Tipos de desechos")
                        .font(.headline)
                        .foregroundColor(Color("ResicloGreen1"))
                }
            }
            .tint(Color("ResicloGreen1"))
        }
    }
}

#Preview {
    WasteLList().environment(ModelData())
}


