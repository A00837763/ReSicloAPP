import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine
import SwiftData

@Model
final class StoredMarker {
    var id: Int
    var name: String
    var lng: Double
    var lat: Double
    var address: String
    var schedule: String?
    var wastes: [StoredWasteReference]
    var lastUpdated: Date
    
    init(from marker: CollectionMarker) {
        self.id = marker.id
        self.name = marker.name
        self.lng = marker.lng
        self.lat = marker.lat
        self.address = marker.address
        self.schedule = marker.schedule
        self.wastes = marker.wastes.map { StoredWasteReference(from: $0) }
        self.lastUpdated = Date()
    }
    
    var toCollectionMarker: CollectionMarker {
        CollectionMarker(
            id: id,
            name: name,
            lng: lng,
            lat: lat,
            address: address,
            schedule: schedule,
            wastes: wastes.map { $0.toWasteReference }
        )
    }
}

@Model
final class StoredWasteReference {
    var id: String
    var type: String
    
    init(from waste: WasteReference) {
        self.id = waste.id
        self.type = waste.type
    }
    
    var toWasteReference: WasteReference {
        WasteReference(id: id, type: type)
    }
}

@Model
final class StoredWasteInfo {
    var id: String
    var name: String
    var icon: String?
    var lastUpdated: Date
    
    init(id: String, info: WasteInfo) {
        self.id = id
        self.name = info.name
        self.icon = info.icon
        self.lastUpdated = Date()
    }
    
    var toWasteInfo: WasteInfo {
        WasteInfo(name: name, icon: icon)
    }
}


struct WasteResponse: Codable {
    let data: [WasteDetail]
}

struct WasteDetail: Codable {
    let id: String
    let type: String
    let attributes: WasteAttributes
}

struct WasteAttributes: Codable {
    let name: String
    let description: String?
    let icon: String?
    let active: Bool
    let platform_visible: String
    let selected: Bool
}

struct WasteInfo: Codable, Hashable {
    let name: String
    let icon: String?
}

struct DetailResponse: Codable {
    let data: [DetailMarker]
}

struct DetailMarker: Codable {
    let id: String
    let type: String
    let attributes: DetailAttributes
    let relationships: MarkerRelationships
}

struct DetailAttributes: Codable {
    let schedule: String?
}

struct MarkerRelationships: Codable {
    let wastes: WastesData
}

struct WastesData: Codable {
    let data: [WasteReference]
}

struct WasteReference: Codable, Hashable {
    let id: String
    let type: String
}


struct CollectionMarker: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let name: String
    let lng: Double
    let lat: Double
    let address: String
    let schedule: String?
    let wastes: [WasteReference]
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CollectionMarker, rhs: CollectionMarker) -> Bool {
        lhs.id == rhs.id
    }
}

struct BasicMarker: Codable {
    let id: Int
    let name: String
    let lng: Double
    let lat: Double
    let address: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case lng
        case lat
        case address = "address_text"
    }
}

extension MKCoordinateRegion {
    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let latDelta = span.latitudeDelta / 2.0
        let lngDelta = span.longitudeDelta / 2.0
        
        let maxLat = center.latitude + latDelta
        let minLat = center.latitude - latDelta
        let maxLng = center.longitude + lngDelta
        let minLng = center.longitude - lngDelta
        
        return (minLat...maxLat).contains(coordinate.latitude) &&
               (minLng...maxLng).contains(coordinate.longitude
              ) }
                                          }
                                          
                                          
