//
//  WasteCategoryRow.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 21/11/24.
//

import SwiftUI

struct WasteCategoryRow: View {
    let category: WasteCategory
    
    var body: some View {
        VStack(spacing: 4) {
            if let icon = category.icon {
                AsyncImage(url: URL(string: icon)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.resicloGreen1)
                } placeholder: {
                    Image(systemName: "leaf.circle.fill")
                        .font(.title2)
                        .foregroundColor(.resicloGreen1)
                }
            } else {
                Image(systemName: "leaf.circle.fill")
                    .font(.title2)
                    .foregroundColor(.resicloGreen1)
            }
            
            Text(category.name)
                .font(.caption)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}

#Preview {
    WasteCategoryRow(category: .preview)
}
