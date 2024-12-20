import SwiftUI
import FirebaseCore
import SwiftData

@main
struct ResicloAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let container: ModelContainer
    @State private var mapViewModel: MapViewModel
    @State private var modelData = ModelData()
    
    init() {
        do {
            // Create container with the models we'll store
            container = try ModelContainer(
                for: StoredRecyclingCenter.self,
                StoredOperatingHours.self,
                StoredWasteCategory.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: false)
            )
            
            // Initialize mapViewModel with the container's modelContext
            let context = container.mainContext
            _mapViewModel = State(initialValue: MapViewModel(modelContext: context))
            
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(mapViewModel)
                .modelContainer(container)
                .environment(modelData)
        }
    }
}
