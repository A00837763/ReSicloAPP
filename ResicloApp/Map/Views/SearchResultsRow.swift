import SwiftUI

struct SearchResultRow: View {
    let marker: RecyclingCenter
    let onSelect: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 16) {
                markerIcon
                markerDetails
                chevronIcon
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(pressedBackground)
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
        .pressAction { isPressed in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.isPressed = isPressed
            }
        }
    }
    
    private var markerIcon: some View {
        Image(systemName: "leaf.circle.fill")
            .font(.title2)
            .foregroundColor(.resicloGreen1)
            .frame(width: 24)
    }
    
    private var markerDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(marker.name)
                .font(.system(size: 17, weight: .medium))
            
            Text(marker.address)
                .font(.system(size: 15))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
    }
    
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(.secondary)
    }
    
    private var pressedBackground: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isPressed ? Color.gray.opacity(0.1) : Color.clear)
    }
}
