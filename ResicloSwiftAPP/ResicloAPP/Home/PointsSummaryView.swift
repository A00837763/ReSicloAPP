// PointsSummaryView.swift
import SwiftUI

struct PointsSummaryView: View {
    let points: Int
    let level: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.resicloGreen1)
            
            VStack(spacing: 8) {
                Image(systemName: "leaf.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Text("Puntos Resiclo")
                    .font(.headline)
                
                Text("\(points)")
                    .font(.system(size: 32, weight: .bold))
                
                Text("Nivel: \(level)")
                    .font(.caption)
                    .opacity(0.8)
            }
            .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
    }
}
