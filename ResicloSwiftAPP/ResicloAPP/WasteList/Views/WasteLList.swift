import SwiftUI


struct WasteLList: View {
    @Environment(ModelData.self) private var modelData
    @State private var searchText = ""
    
    var filteredCategories: [WasteCategory] {
        guard !searchText.isEmpty else { return modelData.categories }
        
        let normalizedSearchText = searchText.folding(options: .diacriticInsensitive, locale: .current)
        
        return modelData.categories.filter {
            let normalizedName = $0.name.folding(options: .diacriticInsensitive, locale: .current)
            return normalizedName.localizedCaseInsensitiveContains(normalizedSearchText)
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(filteredCategories, id: \.categoryId) { category in
                        NavigationLink(destination: WasteLDetail(category: category)) {
                            WasteLRow(category: category)
                        }
                        .listRowSeparator(.visible)
                        .listRowSeparatorTint(Color(.systemGray4))
                    }
                }
                
                if modelData.isLoading {
                    HalfCircleLoadingView()
                }
            }
            .searchable(text: $searchText, prompt: "Search waste types")
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Lista Resiclo")
                        .font(.headline)
                        .foregroundStyle(.resicloGreen1)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.insetGrouped)
            .task {
                if modelData.categories.isEmpty {
                    await modelData.fetchCategories()
                }
            }
        }
    }
}

struct HalfCircleLoadingView: View {
    @State private var isRotating = false
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .stroke(Color.resicloGreen1, style: StrokeStyle(lineWidth: 8, lineCap: .round))
            .frame(width: 60, height: 60)
            .rotationEffect(.degrees(isRotating ? 360 : 0))
            .onAppear {
                withAnimation(.linear(duration: 1)
                    .repeatForever(autoreverses: false)) {
                    isRotating = true
                }
            }
    }
}


// Preview Support
#Preview {
    WasteLList()
        .environment(ModelData())
}

