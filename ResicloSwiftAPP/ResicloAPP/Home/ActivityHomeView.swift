import SwiftUI

struct ActivityView: View {
    // Sample data structure for activities
    struct Activity: Identifiable {
        let id = UUID()
        let icon: String
        let title: String
        let description: String
        let time: String
    }
    
    let activities: [Activity] = [
        Activity(icon: "barcode.viewfinder", title: "Producto Escaneado", description: "Escaneaste una botella de plastico. ¡Recuerda enjuegarla antes de reciclarla!", time: "Hace 2 horas"),
        Activity(icon: "leaf.fill", title: "Eco Tip", description: "Did you know? Recycling one aluminum can saves enough energy to run a TV for 3 hours.", time: "Yesterday"),
        Activity(icon: "location.fill", title: "Recycling Center", description: "You visited Green Earth Recycling Center. Keep up the good work!", time: "3 days ago")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("ACTIVIDAD")
                .font(.title2)
                .bold()
                .foregroundColor(Color("ResicloGreen1"))
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment: .top, spacing: 50) {
                    ForEach(activities) { activity in
                        activityCard(activity: activity)
                    }
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, -16)
        }
    }
    
    private func activityCard(activity: Activity) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: activity.icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color("ResicloCream1"))
                    .frame(width: 40, height: 40)
                    .background(Color("ResicloGreen2"))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(activity.title)
                        .font(.headline)
                        .foregroundColor(Color("ResicloGreen2"))
                    
                    Text(activity.time)
                        .font(.caption)
                        .foregroundStyle(Color("ResicloGreen1"))
                }
            }
            
            Text(activity.description)
                .font(.subheadline)
                .foregroundColor(Color("ResicloBrown"))
                .lineLimit(3)
                .multilineTextAlignment(.leading)
        }
        .padding(20)
        .frame(width: 350, height: 150, alignment: .leading)
        .background(Color("ResicloCream1"))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ActivityView()
}
