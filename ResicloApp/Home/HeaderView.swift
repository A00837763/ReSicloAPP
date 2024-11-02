// HeaderView.swift
import SwiftUI

struct HeaderView: View {
    let userName: String
    
    var body: some View {
        HStack {
            Text("Hola, \(userName)")
                .font(.title)
                .fontWeight(.bold)
            Spacer()
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
        }
        .foregroundStyle(.resicloGreen2)
    }
}
