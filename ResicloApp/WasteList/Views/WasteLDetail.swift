import SwiftUI
import SwiftData

struct WasteLDetail: View {
    @Query(FetchDescriptor<WasteL>()) var wastes: [WasteL]
    @Environment(\.dismiss) private var dismiss
    var waste: WasteL
    @State private var showFullDescription = false
    @State private var selectedTab = "description"

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header Section with Image
                headerSection

                // Content Sections
                VStack(spacing: 24) {
                    // Title and Favorite Section
                    titleSection

                    // Tab Selection
                    tabSelection

                    // Content Based on Selected Tab
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
                Text(waste.name)
                    .font(.headline)
                    .foregroundStyle(.resicloGreen1)
            }
        }
    }

    private var headerSection: some View {
        ZStack(alignment: .bottom) {
            // Background with gradient
            Rectangle()
                .fill(LinearGradient(
                    colors: [.resicloGreen1.opacity(0.2), .resicloGreen2.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .frame(height: 240)

            // Image
            if let iconString = waste.icon, let iconURL = URL(string: iconString) {
                AsyncImage(url: iconURL) { image in
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
                } placeholder: {
                    Image(systemName: "leaf.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                        .foregroundStyle(.resicloGreen2)
                }
                .padding(.bottom, -40)
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                Text(waste.name)
                    .font(.title2.bold())

                FavoriteButton(isSet: Binding(
                    get: { waste.isFavorite },
                    set: { waste.isFavorite = $0 }
                ))
                .font(.title2)
            }

            // Category Tags
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    categoryTag(icon: "leaf.circle.fill", text: "Reciclable")
                    categoryTag(icon: "clock.circle.fill", text: "Proceso: 2-3 días")
                    categoryTag(icon: "checkmark.circle.fill", text: "Común")
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
            sectionTitle("Acerca de \(waste.name)")

            Text(waste.wasteDescription)
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

            VStack(alignment: .leading, spacing: 20) {
                processStep(description: waste.process)
            }
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

            VStack(alignment: .leading, spacing: 12) {
                tipItem(icon: "lightbulb.fill", tip: "Aplasta el material para reducir espacio")
                tipItem(icon: "exclamationmark.triangle.fill", tip: "Retira etiquetas y adhesivos")
                tipItem(icon: "checkmark.circle.fill", tip: "Revisa el código de reciclaje")
            }
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
        VStack(alignment: .leading, spacing: 4) {
            Text(description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func tipItem(icon: String, tip: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.resicloGreen1)

            Text(tip)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: WasteL.self, configurations: config)
    let context = container.mainContext

    // Cargar datos reales si están disponibles
    if let firstWaste = try? context.fetch(FetchDescriptor<WasteL>()).first {
        return NavigationStack {
            WasteLDetail(waste: firstWaste)
                .modelContainer(container)
        }
    } else {
        fatalError("No se pudieron cargar datos para la vista previa.")
    }
}


