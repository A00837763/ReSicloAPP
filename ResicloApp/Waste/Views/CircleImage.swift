//
//  CircleImage.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//


import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .resizable()
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 4)
            }
            .shadow(radius: 7)
    }
}

#Preview {
    CircleImage(image: Image("aceiteVegetalUsadoImage"))
}
