import SwiftUI

struct WasteLList: View {
    @Environment(ModelData.self) private var modelData
    @State private var showFavoritesOnly = false

    var filteredWastes: [WasteL] {
        let wastes = modelData.wastes.filter { waste in
            (!showFavoritesOnly || waste.isFavorite)
        }
        return Array(wastes)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    VStack(spacing: 16) {
                        Toggle(isOn: $showFavoritesOnly) {
                            Label {
                                Text("Mostrar Favoritos")
                                    .font(.headline)
                            } icon: {
                                Image(systemName: "star.fill")
                            }
                        }
                        .tint(.resicloGreen1)
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                        }
                    }
                    .padding()
                    .background(.white)
                    
                    Divider()
                    
                    // Waste List
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredWastes) { waste in
                                NavigationLink(destination: WasteLDetail(waste: waste)) {
                                    WasteLRow(waste: waste)
                                        .padding(.horizontal)
                                        .background {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(.white)
                                                .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
                                        }
                                }
                                .buttonStyle(.plain)
                                .transition(.move(edge: .leading))
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Tipos de Desechos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "leaf.circle.fill")
                            .foregroundStyle(.resicloGreen1)
                        Text("Tipos de Desechos")
                            .font(.headline)
                            .foregroundStyle(.resicloGreen1)
                    }
                }
            }
        }
    }
}

// Preview
#Preview {
    WasteLList()
        .environment(ModelData())
}
