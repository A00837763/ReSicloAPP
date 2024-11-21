import SwiftUI
import SwiftData

struct WasteLList: View {
    @Environment(\.modelContext) private var context
    @Query var wastes: [WasteL]
    @State private var showFavoritesOnly = false
    @State private var searchText = "" // Campo de búsqueda

    var filteredWastes: [WasteL] {
        wastes.filter { waste in
            let matchesSearch = searchText.isEmpty || waste.name.localizedCaseInsensitiveContains(searchText)
            let matchesFavorites = !showFavoritesOnly || waste.isFavorite
            return matchesSearch && matchesFavorites
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Campo de Búsqueda
                    TextField("Buscar por nombre", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.1))
                        }
                        .padding()

                    // Toggle para mostrar favoritos
                    Toggle(isOn: $showFavoritesOnly) {
                        Label("Mostrar Favoritos", systemImage: "star.fill")
                            .font(.headline)
                    }
                    .tint(.resicloGreen1)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                    }
                    .padding()

                    Divider()

                    // Lista de residuos filtrados
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


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WasteL.self, configurations: config)
    let context = container.mainContext

    // Cargar datos reales desde JSON al contexto
    if let url = Bundle.main.url(forResource: "wasteLData", withExtension: "json"),
       let data = try? Data(contentsOf: url) {
        let decoder = JSONDecoder()
        if let wastes = try? decoder.decode([WasteL].self, from: data) {
            for waste in wastes {
                context.insert(waste)
            }
        }
    }

    return WasteLList()
        .modelContainer(container)
}


