import SwiftUI
import MapKit
import FirebaseAuth

struct ResiclaView: View {
    @Binding var showScanner: Bool
    @Binding var showHistory: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("RESICLA")
                .font(.title2)
                .bold()
                .foregroundColor(Color("ResicloGreen1"))
            
            HStack(spacing: 12) {
                // QR Scanner Button
                ActionButton(
                    icon: "qrcode.viewfinder",
                    title: "Escanear QR",
                    description: "Escanea el código QR en tu centro de reciclaje",
                    action: { showScanner = true }
                )
                
                // History Button
                ActionButton(
                    icon: "clock",
                    title: "Historial",
                    description: "Revisa tu historial de reciclaje y puntos",
                    action: { showHistory = true }
                )
            }
        }
        .padding()
    }
}

struct ActionButton: View {
    let icon: String
    let title: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8){
                    Image(systemName: icon)
                        .font(.system(size: 40))
                        .foregroundColor(Color("ResicloGreen1"))
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: Color.black.opacity(0.05),
                        radius: 3,
                        x: 0,
                        y: 1
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(.systemGray6), lineWidth: 1)
            )
        }
    }
}
