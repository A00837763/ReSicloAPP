import SwiftUI
import MapKit

//Estructura de Ubicación de Centro de Reciclaje
struct CollectionMarker: Identifiable, Codable, Equatable, Hashable {
    let id: Int //id único del centro
    let name: String //Nombre del Centro
    let lng: Double //Longitud
    let lat: Double // Latitud
    let address: String // Dirección
    
    // Conversión valores de Longitud y Latitud a Coordenadas en 2d En el Espacio
    var coordinate: CLLocationCoordinate2D { //Variable llamada coordinate de tipo CLlocationCoordinate2D
        CLLocationCoordinate2D(latitude: lat , longitude: lng) // Constructor de la coordenada
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, lng, lat //Se llaman igual en la API los atributos
        case address = "address_text" // En la api se llama address_text
    }
}
