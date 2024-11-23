import Foundation
import SwiftUI
import MapKit
import CoreLocation
import Combine
import SwiftData

// MARK: - Stored Models for SwiftData
@Model
final class StoredRecyclingCenter {
    var centerId: Int
    var name: String
    var desc: String?
    var address: String
    var city: String
    var state: String
    var country: String
    var postalCode: String?
    var latitude: Double
    var longitude: Double
    var phone: String?
    var email: String?
    var website: String?
    var operatingHours: [StoredOperatingHours]
    var wasteCategories: [StoredWasteCategory]
    var lastUpdated: Date
    
    init(from center: RecyclingCenter) {
        self.centerId = center.centerId
        self.name = center.name
        self.desc = center.desc
        self.address = center.address
        self.city = center.city
        self.state = center.state
        self.country = center.country
        self.postalCode = center.postalCode
        self.latitude = center.latitude
        self.longitude = center.longitude
        self.phone = center.phone
        self.email = center.email
        self.website = center.website
        self.operatingHours = center.operatingHours.map { StoredOperatingHours(from: $0) }
        self.wasteCategories = center.wasteCategories.map { StoredWasteCategory(from: $0) }
        self.lastUpdated = Date()
    }
    
    var toRecyclingCenter: RecyclingCenter {
        RecyclingCenter(
            centerId: centerId,
            name: name,
            desc: desc,
            address: address,
            city: city,
            state: state,
            country: country,
            postalCode: postalCode,
            latitude: latitude,
            longitude: longitude,
            phone: phone,
            email: email,
            website: website,
            operatingHours: operatingHours.map { $0.toOperatingHours },
            wasteCategories: wasteCategories.map { $0.toWasteCategory }
        )
    }
}

@Model
final class StoredOperatingHours {
    var day: String
    var openingTime: String
    var closingTime: String
    
    init(from hours: OperatingHours) {
        self.day = hours.day
        self.openingTime = hours.openingTime
        self.closingTime = hours.closingTime
    }
    
    var toOperatingHours: OperatingHours {
        OperatingHours(
            day: day,
            openingTime: openingTime,
            closingTime: closingTime
        )
    }
}

@Model
final class StoredWasteCategory {
    var categoryId: Int
    var name: String
    var desc: String
    var process: String
    var tips: String
    var icon: String?
    
    init(from category: WasteCategory) {
        self.categoryId = category.categoryId
        self.name = category.name
        self.desc = category.desc
        self.process = category.process
        self.tips = category.tips
        self.icon = category.icon
    }
    
    var toWasteCategory: WasteCategory {
        WasteCategory(
            categoryId: categoryId,
            name: name,
            desc: desc,
            process: process,
            tips: tips,
            icon: icon
        )
    }
}

// MARK: - API Response Models
struct RecyclingCenter: Identifiable, Codable, Equatable, Hashable {
    let centerId: Int
    let name: String
    let desc: String?
    let address: String
    let city: String
    let state: String
    let country: String
    let postalCode: String?
    let latitude: Double
    let longitude: Double
    let phone: String?
    let email: String?
    let website: String?
    let operatingHours: [OperatingHours]
    let wasteCategories: [WasteCategory]
    
    var id: Int { centerId }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(centerId)
    }
    
    static func == (lhs: RecyclingCenter, rhs: RecyclingCenter) -> Bool {
        lhs.centerId == rhs.centerId
    }
    
    enum CodingKeys: String, CodingKey {
        case centerId = "center_id"
        case name, address, city, state, country
        case desc = "description"
        case postalCode = "postal_code"
        case latitude, longitude, phone, email, website
        case operatingHours = "operating_hours"
        case wasteCategories = "waste_categories"
    }
}

struct OperatingHours: Codable, Hashable {
    let day: String
    let openingTime: String
    let closingTime: String
    
    enum CodingKeys: String, CodingKey {
        case day
        case openingTime = "opening_time"
        case closingTime = "closing_time"
    }
}

struct WasteCategory: Codable, Hashable {
    let categoryId: Int
    let name: String
    let desc: String
    let process: String
    let tips: String
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "category_id"
        case name
        case desc = "description"
        case process
        case tips
        case icon
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
               (minLng...maxLng).contains(coordinate.longitude)
    }
}
