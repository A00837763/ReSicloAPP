//
//  ImpactView.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 25/11/24.
//

import SwiftUI

struct ImpactView: View {
    let points: Int
    
    private var impactData: (title: String, description: String, icon: String) {
        switch points {
        case 0..<100:
            return ("Impacto Inicial", "Has evitado la emisión de 5kg de CO2", "leaf")
        case 100..<500:
            return ("Impacto Significativo", "Has salvado el equivalente a 2 árboles", "tree")
        case 500..<1000:
            return ("Gran Impacto", "Has ahorrado 100L de agua", "drop")
        case 1000..<2000:
            return ("Impacto Mayor", "Has reducido tu huella de carbono un 15%", "globe.americas")
        default:
            return ("Impacto Legendario", "Has inspirado a 10 personas a reciclar", "star")
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Tu Impacto Ambiental")
                .font(.title2)
                .fontWeight(.bold)
            
            Image(systemName: impactData.icon)
                .font(.system(size: 50))
                .foregroundColor(Color("ResicloGreen1"))
            
            Text(impactData.title)
                .font(.headline)
                .foregroundColor(Color("ResicloGreen1"))
            
            Text(impactData.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            // Additional statistics
            VStack(spacing: 12) {
                ImpactStat(title: "Materiales Reciclados", value: "\(points/10)kg")
                ImpactStat(title: "CO2 Evitado", value: "\(points/20)kg")
                ImpactStat(title: "Agua Ahorrada", value: "\(points*2)L")
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(radius: 2)
            )
        }
        .padding()
    }
}

struct ImpactStat: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(Color("ResicloGreen1"))
        }
    }
}

#Preview {
    ImpactView(points: 200)
}
