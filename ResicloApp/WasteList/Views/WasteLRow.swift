//
//  WasteLRow.swift
//  ResicloApp
//
//  Created by Hugo Ochoa on 06/11/24.
//
import SwiftUI

struct WasteLRow: View {
    var category: WasteCategory
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon or placeholder
            if let icon = category.icon {
                AsyncImage(url: URL(string: icon)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 40, height: 40)
                        .background(Circle().fill(Color(.systemGray5)))
                } placeholder: {
                    Image(systemName: "photo")
                        .foregroundColor(.secondary)
                        .frame(width: 40, height: 40)
                }
            } else {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.resicloGreen1)
                    .frame(width: 40, height: 40)
            }
            
            // Text content
            VStack(alignment: .leading, spacing: 2) {
                Text(category.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if !category.desc.isEmpty {
                    Text(category.desc)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            Spacer()
        }
        .padding(.vertical, 8) // Add vertical padding for a clean native look
    }
}



#Preview {
    let sampleCategory = WasteCategory(
        categoryId: 1,
        name: "Papel y Cartón",
        desc: "Papel, cartón y derivados",
        process: "Separar y aplanar",
        tips: "Mantener seco",
        icon: nil
    )
    
    return WasteLRow(category: sampleCategory)
        .padding()
}
