import Foundation
import SwiftUI

struct Waste: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    var isFavorite: Bool
    let process: String
    let image: String
    var assetImage: Image {
        Image(image)
    }
}


