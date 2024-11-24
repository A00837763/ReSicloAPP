//
//  ProfileView.swift
//  ResicloApp
//
//  Created by Diego Esparza on 07/11/24.
//

import SwiftUI
import FirebaseAuth

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    let profileImageURL: URL?
    @State private var userEmail: String = ""

    var body: some View {
        VStack {
            if let url = profileImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView() // Muestra un spinner mientras carga
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    case .failure:
                        Image(systemName: "person.crop.circle.badge.exclamationmark")
                            .resizable()
                            .frame(width: 150, height: 150)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Imagen de placeholder si no hay foto de perfil
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.gray)
            }
            
            Text("Bienvenido a tu perfil")
                .font(.title)
                .padding(.top, 20)
            
            if !userEmail.isEmpty {
                Text("Correo: \(userEmail)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.top, 8)
            }
        }
        .onAppear {
            obtenerCorreo()
        }
        .padding()
    }
    
    // Función para obtener el correo del usuario autenticado
    private func obtenerCorreo() {
        if let email = Auth.auth().currentUser?.email {
            userEmail = email
        } else {
            userEmail = "Correo no disponible"
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileImageURL: nil) // Puedes poner una URL de prueba aquí
    }
}
