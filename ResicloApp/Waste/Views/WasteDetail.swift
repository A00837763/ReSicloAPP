//
//  WasteDetail.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//
import SwiftUI

struct WasteDetail: View {
    @Environment(ModelData.self) var modelData
    var waste: Waste

    // Obtiene el índice del residuo seleccionado en el array de wastes
    var wasteIndex: Int {
        modelData.wastes.firstIndex(where: { $0.id == waste.id })!
    }

    var body: some View {
        @Bindable var modelData = modelData

        ScrollView {
            // Usa assetImage en lugar de image
            CircleImage(image: waste.assetImage)
                .scaledToFit()
                .frame(height: 150) // Adjust this to make it smaller

            VStack(alignment: .leading) {
                // Título y botón de favorito
                HStack {
                    Text(waste.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.wastes[wasteIndex].isFavorite)
                }
                
                Divider()
                

                // Descripción del residuo
                Text("About \(waste.name)")
                    .font(.title2)
                Text(waste.description)

                Divider()
                
                // Información de Procesamiento
                Text("Processing Information")
                    .font(.title2)
                Text(waste.process)
                    //.padding(.vertical)
            }
            .padding()
        }
        .navigationTitle(waste.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let modelData = ModelData()
    return WasteDetail(waste: modelData.wastes[1])
        .environment(modelData)
}




