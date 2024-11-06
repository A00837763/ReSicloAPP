import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var showStartPage = true
    @Environment(\.modelContext) private var modelContext
    @Environment(MapViewModel.self) private var vm
    
    var body: some View {
        ZStack {
            if showStartPage {
                StartPage(showStartPage: $showStartPage)
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
                    .environment(\.modelContext, modelContext)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showStartPage)
    }
}
#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(
        for: StoredMarker.self,
        StoredWasteReference.self,
        StoredWasteInfo.self,
        configurations: config
    )
    
    let viewModel = MapViewModel(modelContext: container.mainContext)
    
    return ContentView()
        .modelContainer(container)
        .environment(viewModel)
}
