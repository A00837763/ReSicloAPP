// PointsSummaryView.swift
import SwiftUI

enum EcoLevel: String {
    case entusiasta = "Eco Entusiasta"
    case iniciado = "Eco Iniciado"
    case aprendiz = "Eco Aprendiz"
    case guerrero = "Eco Guerrero"
    case maestro = "Eco Maestro"
    case leyenda = "Eco Leyenda"
    
    static func current(for points: Int) -> EcoLevel {
        switch points {
        case 0..<100: return .entusiasta
        case 100..<500: return .iniciado
        case 500..<1000: return .aprendiz
        case 1000..<2000: return .guerrero
        default: return .maestro
        }
    }
    
    var next: EcoLevel {
        switch self {
        case .entusiasta: return .iniciado
        case .iniciado: return .aprendiz
        case .aprendiz: return .guerrero
        case .guerrero: return .maestro
        case .maestro: return .leyenda
        case .leyenda: return .leyenda
        }
    }
    
    func pointsRange() -> ClosedRange<Int> {
        switch self {
        case .entusiasta: return 0...99
        case .iniciado: return 100...499
        case .aprendiz: return 500...999
        case .guerrero: return 1000...1999
        case .maestro, .leyenda: return 2000...2000
        }
    }
}

struct PointsSummaryView: View {
    let points: Int
    let maxPoints: Int = 2000
    
    private var currentLevel: EcoLevel {
        .current(for: points)
    }
    
    private var pointsToNextLevel: Int {
        let range = currentLevel.pointsRange()
        return max(0, range.upperBound - points + 1)
    }
    
    private func progress(in width: CGFloat) -> CGFloat {
        let range = currentLevel.pointsRange()
        let progress = CGFloat(points - range.lowerBound) / CGFloat(range.upperBound - range.lowerBound)
        return width * min(max(progress, 0), 1)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color("ResicloGreen1"))
                
                Text("Puntos Resiclo")
                    .font(.headline)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(points)")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(Color("ResicloGreen1"))
                
                HStack(spacing: 8) {
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("ResicloGreen1"))
                                .frame(width: progress(in: geometry.size.width))
                                .animation(.spring(dampingFraction: 0.8), value: points)
                        }
                    }
                    .frame(height: 8)
                    
                    Text(currentLevel.rawValue)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if pointsToNextLevel > 0 {
                    Text("\(pointsToNextLevel) pts para \(currentLevel.next.rawValue)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
        )
    }
}
