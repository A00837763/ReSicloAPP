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
                        .transition(.opacity.combined(with: .scale))
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 150)
                .clipShape(Circle())
                .foregroundColor(Color("ResicloGreen2"))
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }

            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text(waste.name)
                        .font(.title)
                        .foregroundColor(Color("ResicloGreen1"))
                    FavoriteButton(isSet: $modelData.wastes[wasteIndex].isFavorite)
                }

                Divider().background(Color("ResicloGreen2"))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Acerca de \(waste.name)")
                        .font(.title2)
                        .foregroundColor(Color("ResicloGreen1"))
                    Text(waste.description)
                }
                .padding()
                .background(Color("ResicloGreen1").opacity(0.1))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                Divider().background(Color("ResicloGreen2"))

                VStack(alignment: .leading, spacing: 10) {
                    Text("Información de reciclaje")
                        .font(.title2)
                        .foregroundColor(Color("ResicloGreen1"))
                    Text(waste.process)
                }
                .padding()
                .background(Color("ResicloGreen1").opacity(0.1))
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
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



