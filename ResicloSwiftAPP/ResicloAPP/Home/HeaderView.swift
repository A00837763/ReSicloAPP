import SwiftUI
import FirebaseAuth

struct HeaderView: View {
    let userName: String
    @Environment(\.presentationMode) var presentationMode
    @State private var showProfileView = false

    // Propiedad calculada para obtener la URL de la foto de perfil del usuario actual
    private var profileImageURL: URL? {
        Auth.auth().currentUser?.photoURL
    }

    var body: some View {
        HStack {
            Text("Hola, \(userName)")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Button(action: {
                presentationMode.wrappedValue.dismiss()
                showProfileView = true
            }) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        showProfileView = true
                    }
            }
        }
        .foregroundStyle(.resicloGreen2)
        .sheet(isPresented: $showProfileView) {
            // Pasamos la URL de la foto de perfil a ProfileView
            ProfileView(profileImageURL: profileImageURL)
        }
    }
}
