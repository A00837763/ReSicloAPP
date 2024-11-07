//
//  WasteLRow.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//

import SwiftUI

struct WasteLRow: View {
    var waste: WasteL

    var body: some View {
        HStack {
            if let iconURL = waste.iconURL {
                AsyncImage(url: iconURL) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo")
                        .foregroundColor(Color("ResicloGreen2")) // Color del ícono de placeholder
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(Color("ResicloGreen2"))
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading) {
                Text(waste.name)
                    .font(.headline)
                    .foregroundColor(Color("ResicloGreen1")) // Color del nombre del residuo
                Text(waste.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            if waste.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
            }
        }
    }
}

#Preview {
    let wastes = ModelData().wastes
    return Group {
        WasteLRow(waste: wastes[0])
        WasteLRow(waste: wastes[1])
    }
}



