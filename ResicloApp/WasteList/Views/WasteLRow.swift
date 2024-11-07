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
        HStack(spacing: 16) {
            if let iconURL = waste.iconURL {
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
                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
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
                
                if !waste.description.isEmpty {
                    Text(waste.description)
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
    let wastes = ModelData().wastes
    return Group {
        WasteLRow(waste: wastes[0])
        WasteLRow(waste: wastes[1])
    }
}



