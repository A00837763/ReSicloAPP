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
            List {
                ForEach(filteredCategories, id: \.categoryId) { category in
                    NavigationLink(destination: WasteLDetail(category: category)) {
                        WasteLRow(category: category)
                    }
                    .listRowSeparator(.visible)
                    .listRowSeparatorTint(Color(.systemGray4))
                }
            }
            .searchable(text: $searchText, prompt: "Search waste types")
            .navigationTitle("Waste Types")
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


// Preview Support
#Preview {
    WasteLList()
        .environment(ModelData())
}

