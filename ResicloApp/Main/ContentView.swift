import SwiftUI

struct ContentView: View {
    @State private var showStartPage = true
    
    var body: some View {
        ZStack {
            if showStartPage {
                StartPage(showStartPage: $showStartPage)
                    .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showStartPage)
    }
}
#Preview {
    ContentView()
}
