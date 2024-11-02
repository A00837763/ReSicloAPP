import SwiftUI

struct RecyclingMarker: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "leaf.circle.fill")
                .font(.title)
                .foregroundColor(.resicloGreen1)
                .shadow(radius: 1)
        }
    }
}
