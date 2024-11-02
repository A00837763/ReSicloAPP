import SwiftUI

struct EmptyResultsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "leaf.circle")
                .font(.system(size: 40))
                .foregroundColor(.resicloGreen1)
                .padding(.bottom, 4)
            
            Text("No encontramos centros de reciclaje")
                .font(.system(size: 17, weight: .medium))
            
            Text("Intenta con otra búsqueda")
                .font(.system(size: 15))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
        .padding()
    }
}
