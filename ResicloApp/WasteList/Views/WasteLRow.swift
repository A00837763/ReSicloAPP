//
//  WasteLRow.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//

import SwiftUI
import SwiftData

struct WasteLRow: View {
    var waste: WasteL

    var body: some View {
        HStack(spacing: 16) {
            if let iconString = waste.icon, let iconURL = URL(string: iconString) {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    Image(systemName: "photo")
                        .foregroundStyle(Color.resicloGreen2)
                }
                .frame(width: 50, height: 50)
            } else {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .foregroundStyle(Color.resicloGreen2)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.resicloGreen1, lineWidth: 2)
                    )
                    .background(
                        Circle()
                            .fill(Color.resicloGreen1.opacity(0.1))
                            .padding(-4)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            }

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(waste.name)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if waste.isFavorite {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.subheadline)
                    }
                }

                if !waste.wasteDescription.isEmpty {
                    Text(waste.wasteDescription) // Directo del modelo
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WasteL.self, configurations: config)
    let context = container.mainContext

    // Cargar datos reales desde JSON al contexto
    if let url = Bundle.main.url(forResource: "wasteLData", withExtension: "json"),
       let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        if let wastes = try? decoder.decode([WasteL].self, from: data) {
            for waste in wastes {
                context.insert(waste)
            }
        }
    }

    // Obtener el primer objeto WasteL
    if let firstWaste = try? context.fetch(FetchDescriptor<WasteL>()).first {
        return WasteLRow(waste: firstWaste)
            .modelContainer(container)
    } else {
        fatalError("No se pudieron cargar los datos para la vista previa.")
    }
}



