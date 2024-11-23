import SwiftUI

struct WasteLDetail: View {
   @Environment(ModelData.self) var modelData
   @Environment(\.dismiss) private var dismiss
   var category: WasteCategory
   @State private var selectedTab = "description"
   
   var body: some View {
       ScrollView {
           VStack(spacing: 0) {
               headerSection
               
               VStack(spacing: 24) {
                   titleSection
                   tabSelection
                   tabContent
                       .transition(.opacity)
               }
               .padding()
           }
       }
       .background(Color(.systemBackground))
       .navigationBarTitleDisplayMode(.inline)
       .toolbar {
           ToolbarItem(placement: .principal) {
               Text(category.name)
                   .font(.headline)
                   .foregroundStyle(.resicloGreen1)
           }
       }
   }
   
   private var headerSection: some View {
       ZStack(alignment: .bottom) {
           Image("backGreen2")
               .resizable()
               .scaledToFill()
               .frame(height: 240)
               .mask(Rectangle())
        
           if let icon = category.icon {
               AsyncImage(url: URL(string: icon)) { image in
                   image
                       .resizable()
                       .scaledToFit()
                       .frame(width: 160, height: 160)
                       .clipShape(Circle())
                       .overlay(
                           Circle()
                               .stroke(Color.white, lineWidth: 4)
                               .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 4)
                       )
                       .background(
                           Circle()
                               .fill(Color.white) // White background circle
                               .frame(width: 170, height: 170) // Slightly larger than the image
                       )
               } placeholder: {
                   Image(systemName: "leaf.circle.fill")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 160, height: 160)
                       .foregroundStyle(.resicloGreen2)
                       .background(
                           Circle()
                               .fill(Color.white) // White background for placeholder
                               .frame(width: 170, height: 170)
                       )
               }
               .padding(.bottom, -40)
           }
       }
   }
   
   private var titleSection: some View {
       VStack(spacing: 16) {
           Text(category.name)
               .font(.title2.bold())
           
           ScrollView(.horizontal, showsIndicators: false) {
               HStack(spacing: 8) {
                   categoryTag(icon: "leaf.circle.fill", text: "Reciclable")
                   categoryTag(icon: "clock.circle.fill", text: "Proceso Definido")
                   categoryTag(icon: "checkmark.circle.fill", text: "Tips Disponibles")
               }
           }
       }
       .padding(.top, 40)
   }
   
   private func categoryTag(icon: String, text: String) -> some View {
       HStack(spacing: 4) {
           Image(systemName: icon)
               .font(.subheadline)
           Text(text)
               .font(.subheadline)
       }
       .padding(.horizontal, 12)
       .padding(.vertical, 6)
       .background(Color.resicloGreen1.opacity(0.1))
       .foregroundStyle(.resicloGreen1)
       .clipShape(Capsule())
   }
   
   private var tabSelection: some View {
       HStack(spacing: 0) {
           tabButton(title: "Descripción", tag: "description")
           tabButton(title: "Proceso", tag: "process")
           tabButton(title: "Tips", tag: "tips")
       }
       .padding(4)
       .background(Color.gray.opacity(0.1))
       .clipShape(RoundedRectangle(cornerRadius: 12))
   }
   
   private func tabButton(title: String, tag: String) -> some View {
       Button {
           withAnimation { selectedTab = tag }
       } label: {
           Text(title)
               .font(.subheadline.weight(.medium))
               .padding(.vertical, 8)
               .frame(maxWidth: .infinity)
               .background(
                   RoundedRectangle(cornerRadius: 10)
                       .fill(selectedTab == tag ? .white : .clear)
                       .shadow(color: .black.opacity(selectedTab == tag ? 0.05 : 0), radius: 4, x: 0, y: 2)
               )
               .foregroundStyle(selectedTab == tag ? .resicloGreen1 : .gray)
       }
   }
   
   @ViewBuilder
   private var tabContent: some View {
       switch selectedTab {
       case "description":
           descriptionSection
       case "process":
           processSection
       case "tips":
           tipsSection
       default:
           EmptyView()
       }
   }
   
   private var descriptionSection: some View {
       VStack(alignment: .leading, spacing: 16) {
           sectionTitle("Acerca de \(category.name)")
           
           Text(category.desc)
               .font(.subheadline)
               .foregroundStyle(.secondary)
               .lineSpacing(4)
       }
       .padding()
       .frame(maxWidth: .infinity, alignment: .leading)
       .background(
           RoundedRectangle(cornerRadius: 16)
               .fill(.white)
               .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
       )
   }
   
   private var processSection: some View {
       VStack(alignment: .leading, spacing: 16) {
           sectionTitle("Proceso de Reciclaje")
           
           processStep(description: category.process)
       }
       .padding()
       .frame(maxWidth: .infinity, alignment: .leading)
       .background(
           RoundedRectangle(cornerRadius: 16)
               .fill(.white)
               .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
       )
   }
   
   private var tipsSection: some View {
       VStack(alignment: .leading, spacing: 16) {
           sectionTitle("Tips de Reciclaje")
           
           Text(category.tips)
               .font(.subheadline)
               .foregroundStyle(.secondary)
       }
       .padding()
       .frame(maxWidth: .infinity, alignment: .leading)
       .background(
           RoundedRectangle(cornerRadius: 16)
               .fill(.white)
               .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
       )
   }
   
   private func sectionTitle(_ text: String) -> some View {
       Text(text)
           .font(.headline)
           .foregroundStyle(.resicloGreen1)
   }
   
   private func processStep(description: String) -> some View {
       Text(description)
           .font(.subheadline)
           .foregroundStyle(.secondary)
   }
}

#Preview {
   let sampleCategory = WasteCategory(
       categoryId: 1,
       name: "Papel y Cartón",
       desc: "Materiales de papel y cartón reciclables",
       process: "Separar por tipo, aplanar cajas, retirar grapas",
       tips: "Mantener seco, separar por tipo",
       icon: nil
   )
   
   return NavigationStack {
       WasteLDetail(category: sampleCategory)
           .environment(ModelData())
   }
}
