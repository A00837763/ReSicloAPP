import SwiftUI
import MapKit

struct CollectionMarker: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let lng: Double
    let lat: Double
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat , longitude: lng)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, lng, lat
        case address = "address_text"
    }
}
