//
//  ProfileView.swift
//  ResicloApp
//
//  Created by Diego Esparza on 07/11/24.
//

import SwiftUI

struct ProfileView: View {
    @State private var profileImage: Image? = Image("placeholder") // Imagen de perfil
    @State private var name: String = "Diego Esparza"
    @State private var email: String = "diego@example.com"
    
    var body: some View {
        VStack {
            profileImage?
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.resicloGreen1, lineWidth: 2))
                .shadow(radius: 5)
                .padding(.top, 20)
                .onTapGesture {
                    selectImage()
                }
            
            Text(name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 10)
            
            Text(email)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            Spacer()
            
            Button(action: {
                editProfile()
            }) {
                Text("Editar Perfil")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(Color.resicloGreen1)
                    .cornerRadius(10)
            }
            .padding(.bottom, 20)
            .foregroundStyle(.resicloGreen1)
        }
        .padding()
    }
    
    func selectImage() {
        // Lógica para seleccionar la imagen
    }
    
    func editProfile() {
        // Lógica para editar el perfil
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
