//
//  WasteLDetail.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//

import SwiftUI

struct WasteLDetail: View {
    @Environment(ModelData.self) var modelData
    var waste: WasteL

    var wasteIndex: Int {
        modelData.wastes.firstIndex(where: { $0.id == waste.id })!
    }

    var body: some View {
        @Bindable var modelData = modelData

        ScrollView {
            if let iconURL = waste.iconURL {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 150)
                .clipShape(Circle())
                .foregroundColor(Color("ResicloGreen2")) // Color del ícono
            }

            VStack(alignment: .leading) {
                HStack {
                    Text(waste.name)
                        .font(.title)
                        .foregroundColor(Color("ResicloGreen1")) // Color del título
                    FavoriteButton(isSet: $modelData.wastes[wasteIndex].isFavorite)
                }

                Divider().background(Color("ResicloGreen2")) // Color del divisor

                Text("Acerca de \(waste.name)")
                    .font(.title2)
                    .foregroundColor(Color("ResicloGreen1")) // Color del subtítulo
                Text(waste.description)

                Divider().background(Color("ResicloGreen2")) // Color del divisor

                Text("Información de reciclaje")
                    .font(.title2)
                    .foregroundColor(Color("ResicloGreen1")) // Color del subtítulo
                Text(waste.process)
            }
            .padding()
        }
        .navigationTitle(waste.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let modelData = ModelData()
    return WasteLDetail(waste: modelData.wastes[1])
        .environment(modelData)
}



