import SwiftUI

struct StartPage: View {
    @Binding var showStartPage: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.05) {
                Spacer()
                
                Image("ResLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: min(geometry.size.width * 0.5, 200))
                
                VStack(spacing: 10) {
                    Text("RESICLO")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(Color("ResicloGreen1"))
                    
                    Text("Donde Juntos Sí Rescilamos")
                        .font(.system(size: 18, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showStartPage = false
                    }
                }) {
                    Text("Entrar")
                        .frame(width: min(geometry.size.width * 0.8, 300))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color("ResicloGreen1"))
                        .cornerRadius(15)
                        .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 3)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

