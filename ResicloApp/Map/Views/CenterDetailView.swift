import SwiftUI
import MapKit

struct CenterDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var sheetHeight: PresentationDetent = .height(200)
    var center: RecyclingCenter
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            Divider()
            
            contentScrollView
            
            footerSection
        }
        .presentationConfiguration
        .onAppear { sheetHeight = .height(200) }
        .highPriorityGesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.height > 100 {
                        dismiss()
                    }
                }
        )
    }
}

// MARK: - Main Sections
private extension CenterDetailView {
    var headerSection: some View {
        VStack(spacing: 8) {
            HStack{
                Spacer()
                closeButton
            }
            detailHeader
        }
        .padding(.bottom, 8)
    }
    
    var closeButton: some View {
         Button {
             dismiss()
         } label: {
             Image(systemName: "xmark.circle.fill")
                 .font(.title3)
                 .foregroundStyle(.gray.opacity(0.6))
                 .padding(.trailing)
                 .padding(.top, 8)
         }
         .accessibilityLabel("Cerrar detalles")
     }
    
    var contentScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                wasteCategoriesView
                operatingHoursView
                
                if let description = center.desc {
                    descriptionView(description)
                }
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }
    
    var footerSection: some View {
        VStack(spacing: 0) {
            Divider()
            directionsButton
                .padding()
                .background(.ultraThinMaterial)
        }
    }
}

// MARK: - Components
private extension CenterDetailView {
    
    var detailHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Label {
                    Text(center.name)
                        .font(.title3.bold())
                        .fixedSize(horizontal: false, vertical: true)
                } icon: {
                    Image(systemName: "leaf.circle.fill")
                        .font(.title2)
                        .foregroundColor(.resicloGreen1)
                }
                
                Spacer()
            }
            
            Label {
                Text(center.address)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } icon: {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.resicloGreen1)
            }
            
            if let phone = center.phone {
                Label {
                    Text(phone)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "phone.circle.fill")
                        .foregroundColor(.resicloGreen1)
                }
                .accessibilityLabel("Teléfono: \(phone)")
            }
        }
        .padding(.horizontal)
    }
    
    var wasteCategoriesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Materiales Aceptados:", systemImage: "trash.circle.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(center.wasteCategories, id: \.categoryId) { category in
                    WasteCategoryRow(category: category)
                }
            }
        }
    }
    
    var operatingHoursView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Horario:", systemImage: "clock.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            ForEach(center.operatingHours, id: \.day) { hours in
                HStack {
                    Text(hours.day)
                        .frame(width: 100, alignment: .leading)
                    Text("\(hours.openingTime) - \(hours.closingTime)")
                }
                .font(.subheadline)
                .padding(.leading, 28)
            }
        }
    }
    
    func descriptionView(_ description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Descripción:", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            Text(description)
                .font(.subheadline)
                .padding(.leading, 28)
        }
    }
    
    var directionsButton: some View {
        Button {
            let coordinate = "\(center.latitude),\(center.longitude)"
            if let url = URL(string: "maps://?daddr=\(coordinate)") {
                UIApplication.shared.open(url)
            }
        } label: {
            Label("Obtener Direcciones", systemImage: "map.fill")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.resicloGreen1)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .accessibilityLabel("Abrir direcciones en mapas")
    }
}

// MARK: - Reusable Components
private struct WasteCategoryRow: View {
    let category: WasteCategory
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "circle.fill")
                .font(.system(size: 6))
            
            Text(category.name)
                .font(.subheadline)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.05))
        .cornerRadius(8)
        .accessibilityLabel("Material aceptado: \(category.name)")
    }
}

// MARK: - Presentation Configuration Modifier
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
    // Ejemplo para vista previa
    let sampleCenter = RecyclingCenter(
        centerId: 1,
        name: "Centro de Reciclaje",
        desc: "Un centro ecológico dedicado al reciclaje responsable.",
        address: "123 Calle Verde",
        city: "Monterrey",
        state: "Nuevo León",
        country: "México",
        postalCode: "64000",
        latitude: 25.6866,
        longitude: -100.3161,
        phone: "81-1234-5678",
        email: "contacto@reciclaje.com",
        website: "www.reciclaje.com",
        operatingHours: [
            OperatingHours(day: "Lunes", openingTime: "9:00", closingTime: "18:00"),
            OperatingHours(day: "Martes", openingTime: "9:00", closingTime: "18:00")
        ],
        wasteCategories: [
            WasteCategory(categoryId: 1, name: "Papel", desc: "Todo tipo de papel", process: "Separar", tips: "Mantener seco"),
            WasteCategory(categoryId: 2, name: "Plástico", desc: "PET y HDPE", process: "Limpiar", tips: "Aplastar")
        ]
    )
    
    CenterDetailView(center: sampleCenter)
}
