// KnowledgeSection.swift
import Foundation
import SwiftUI

struct KnowledgeSection: View {
    private let items = [
        "¿Como Escanear tus Productos?",
        "Gana puntos al escanear",
        "Item 3",
        "Item 4",
        "Item 5",
        "Item 6",
        "Item 7",
        "Item 8",
        "Item 9",
        "Item 10"
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("CONOCE")
                .font(.title2)
                .bold()
                .foregroundColor(.resicloGreen1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        ItemView(title: item)
                    }
                }
            }
            .frame(height: 150)
        }
    }
}
