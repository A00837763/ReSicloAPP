//
//  CenterDetailComponents.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 21/11/24.
//

import SwiftUI

struct CenterDetailHeader: View {
    let center: RecyclingCenter
    let onDismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Spacer()
                closeButton
            }
            detailInfo
        }
        .padding(.bottom, 8)
    }
    
    private var closeButton: some View {
        Button {
            onDismiss()
        } label: {
            Image(systemName: "xmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.gray.opacity(0.6))
                .padding(.trailing)
                .padding(.top, 8)
        }
        .accessibilityLabel("Cerrar detalles")
    }
    
    private var detailInfo: some View {
        VStack(alignment: .leading, spacing: 8) {
            nameLabel
            addressLabel
            phoneLabel
        }
        .padding(.horizontal)
    }
    
    private var nameLabel: some View {
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
    }
    
    private var addressLabel: some View {
        Label {
            Text(center.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        } icon: {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.resicloGreen1)
        }
    }
    
    private var phoneLabel: some View {
        Group {
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
    }
}

struct CenterDetailContent: View {
    let center: RecyclingCenter
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                
                if let description = center.desc {
                    descriptionSection(description)
                }
            
                operatingHoursSection
                wasteCategoriesSection
                
                Spacer(minLength: 100)
            }
            .padding(.horizontal)
            .padding(.top, 16)
        }
    }
    
    private var wasteCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Materiales Aceptados:", systemImage: "trash.circle.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(center.wasteCategories, id: \.categoryId) { category in
                    NavigationLink(value: category) {
                        WasteCategoryRow(category: category)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain) // Preserves custom styling
                }
            }
        }
        .navigationDestination(for: WasteCategory.self) { category in
            WasteLDetail(category: category)
        }
    }
    
    private var operatingHoursSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Horario:", systemImage: "clock.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            let grouped = Dictionary(grouping: center.operatingHours) { $0.day }
            let dayOrder: [String: Int] = [
                "Sunday": 0,
                "Monday": 1,
                "Tuesday": 2,
                "Wednesday": 3,
                "Thursday": 4,
                "Friday": 5,
                "Saturday": 6
            ]
            
            let sortedGroups = grouped.map { (day: $0.key, hours: $0.value) }
                .sorted { first, second in
                    (dayOrder[first.day] ?? 7) < (dayOrder[second.day] ?? 7)
                }
            
            ForEach(sortedGroups, id: \.day) { dayGroup in
                VStack(alignment: .leading, spacing: 4) {
                    Text(dayGroup.day)
                        .font(.subheadline)
                    
                    ForEach(dayGroup.hours.sorted { $0.openingTime < $1.openingTime },
                           id: \.openingTime) { hours in
                        Text("\(hours.openingTime) - \(hours.closingTime)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.leading)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    private func descriptionSection(_ description: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Descripción:", systemImage: "info.circle.fill")
                .font(.headline)
                .foregroundColor(.resicloGreen1)
            
            Text(description)
                .font(.subheadline)
                .padding(.leading, 28)
        }
    }
}

struct CenterDetailFooter: View {
    let center: RecyclingCenter
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            directionsButton
                .padding()
                .background(.ultraThinMaterial)
        }
    }
    
    private var directionsButton: some View {
        Button {
            openDirections()
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
    
    private func openDirections() {
        let coordinate = "\(center.latitude),\(center.longitude)"
        if let url = URL(string: "maps://?daddr=\(coordinate)") {
            UIApplication.shared.open(url)
        }
    }
}


