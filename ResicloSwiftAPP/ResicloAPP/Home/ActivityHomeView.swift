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
            
            HStack(spacing: 20) {
                // QR Scanner Button
                Button(action: {
                    showScanner = true
                }) {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 24))
                                .foregroundColor(Color("ResicloCream1"))
                            Text("Escanear QR")
                                .font(.headline)
                                .foregroundColor(Color("ResicloCream1"))
                        }
                        
                        Text("Escanea el código QR en tu centro de reciclaje")
                            .font(.caption)
                            .foregroundColor(Color("ResicloCream1"))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color("ResicloGreen2"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // History Button
                Button(action: {
                    showHistory = true
                }) {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "clock")
                                .font(.system(size: 24))
                                .foregroundColor(Color("ResicloCream1"))
                            Text("Historial")
                                .font(.headline)
                                .foregroundColor(Color("ResicloCream1"))
                        }
                        
                        Text("Revisa tu historial de reciclaje y puntos")
                            .font(.caption)
                            .foregroundColor(Color("ResicloCream1"))
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color("ResicloGreen2"))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
}
