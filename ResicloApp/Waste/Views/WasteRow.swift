//
//  WasteRow.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//

import SwiftUI

struct WasteRow: View {
    var waste: Waste
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(waste.name)
                    .font(.headline)
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
        WasteRow(waste: wastes[0])
        WasteRow(waste: wastes[1])
    }
}

