import SwiftUI

struct CenterDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var sheetHeight: PresentationDetent = .height(200)
    let center: RecyclingCenter
    
    var body: some View {
        VStack(spacing: 0) {
            CenterDetailHeader(center: center, onDismiss: dismiss.callAsFunction)
            
            Divider()
            
            CenterDetailContent(center: center)
            
            CenterDetailFooter(center: center)
        }
        .presentationConfiguration
        .onAppear { sheetHeight = .height(200) }

    }
}

private extension View {
    var presentationConfiguration: some View {
        self.presentationDetents([.height(200), .medium])
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.enabled)
            .presentationBackground(.regularMaterial)
            .presentationCornerRadius(12)
    }
}

#Preview {
    CenterDetailView(center: .preview)
}
