import Foundation
import SwiftUI
import Combine

class CollectionCenterViewModel: ObservableObject {
    @Published var centerDetails: CollectionCenter?
    @Published var includedItems: [IncludedItem] = []
    var cancellables = Set<AnyCancellable>()

    func fetchCenterDetails(id: String) {
        guard let url = URL(string: "https://apiecolana.com/api/v2/collection_centers/\(id)?include_wastes=true&include_collection_center_wastes=true&include_address=true&include_collection_center_benefit=true&include_collection_center_nup=true&include_collection_center_comments.comment=true&include_collection_center_comments=true&include_campaign_collection_centers=true&include_campaign_collection_centers.campaign=true&include_collection_center_socials.social_medium=true&include_collection_center_contacts.contact=true&include_schedule_model=true&include_schedule_model.schedule_days=true") else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ApiResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error fetching data: \(error.localizedDescription)")
                    // Aquí podrías actualizar alguna variable de estado para mostrar un error en la UI
                }
            }, receiveValue: { [weak self] response in
                self?.centerDetails = response.data
                self?.includedItems = response.included ?? []
            })
            .store(in: &cancellables)
    }
}

// Suponiendo que la API responde con un objeto raíz que contiene 'data' y 'included'
struct ApiResponse: Codable {
    var data: CollectionCenter
    var included: [IncludedItem]?
}

// Modelos de datos necesarios, asegúrate de implementar Codable para la decodificación
struct CollectionCenter: Codable, Identifiable {
    var id: String
    var type: String
    var attributes: CollectionCenterAttributes
    var relationships: CollectionCenterRelationships
}

struct CollectionCenterAttributes: Codable {
    var name: String?
    var description: String?
    var schedule: String?
}

struct CollectionCenterRelationships: Codable {
    var wastes: [RelatedItem]
}

struct RelatedItem: Codable, Identifiable {
    var id: String
    var type: String
}

struct IncludedItem: Codable, Identifiable {
    var id: String
    var type: String
    var attributes: IncludedAttributes
}

struct IncludedAttributes: Codable {
    var name: String
    var description: String?
}
