import Foundation
import CoreLocation

class NetworkService {
    private let baseURL = "http://127.0.0.1:8000/api"
    
    func fetchCenters() async throws -> [RecyclingCenter] {
        let url = URL(string: "\(baseURL)/centers")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([RecyclingCenter].self, from: data)
    }
    
    func fetchNearbyCenters(location: CLLocationCoordinate2D, radius: Double) async throws -> [RecyclingCenter] {
        let url = URL(string: "\(baseURL)/centers/nearby?latitude=\(location.latitude)&longitude=\(location.longitude)&radius=\(radius)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([RecyclingCenter].self, from: data)
    }
    
    func searchCenters(query: String? = nil, city: String? = nil, wasteType: String? = nil) async throws -> [RecyclingCenter] {
        var urlComponents = URLComponents(string: "\(baseURL)/centers/search")!
        var queryItems: [URLQueryItem] = []
        
        if let query = query { queryItems.append(URLQueryItem(name: "q", value: query)) }
        if let city = city { queryItems.append(URLQueryItem(name: "city", value: city)) }
        if let wasteType = wasteType { queryItems.append(URLQueryItem(name: "waste_type", value: wasteType)) }
        
        urlComponents.queryItems = queryItems
        
        let (data, _) = try await URLSession.shared.data(from: urlComponents.url!)
        return try JSONDecoder().decode([RecyclingCenter].self, from: data)
    }
}
