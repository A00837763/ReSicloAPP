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
                        .foregroundColor(Color("ResicloGreen2"))
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(Color("ResicloGreen2"))
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
            }

            VStack(alignment: .leading) {
                Text(waste.name)
                    .font(.headline)
                    .foregroundColor(Color("ResicloGreen1"))
                //Text(waste.description)
                    //.font(.subheadline)
                    //.foregroundColor(.gray)
            }

            Spacer()

            if waste.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                    .scaleEffect(1.2)
                    .animation(.easeInOut, value: waste.isFavorite)
            }
        }
        .padding()
        .background(Color.white.opacity(0.9))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    let wastes = ModelData().wastes
    return Group {
        WasteLRow(waste: wastes[0])
        WasteLRow(waste: wastes[1])
    }
}



