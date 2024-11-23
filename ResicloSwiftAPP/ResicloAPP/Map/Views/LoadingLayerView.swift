//
//  LoadingLayer.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 21/11/24.
//

import SwiftUI

struct LoadingLayerView: View {
    var body: some View {
        ZStack {
            Color.white.opacity(0.50)
            
            VStack(spacing: 20) {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.resicloGreen1)
                
                ProgressView()
                    .controlSize(.large)
                    .tint(.resicloGreen1)
                
                VStack(spacing: 8) {
                    Text("¡Estamos buscando centros cerca de ti!")
                        .font(.headline)
                        .foregroundStyle(.resicloGreen1)
                        .multilineTextAlignment(.center)
                    
                    Text("Juntos hacemos la diferencia")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
            }
            .padding(.horizontal, 40)
        }
        .transition(.opacity.combined(with: .scale))
    }
}
    #Preview {
        LoadingLayerView()
    }
