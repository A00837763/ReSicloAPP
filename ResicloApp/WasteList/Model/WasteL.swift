//
//  WasteL.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//
import Foundation
import SwiftUI
import SwiftData

@Model
class WasteL: Decodable {
    @Attribute(.unique) var id: String
    var name: String
    var wasteDescription: String
    var isFavorite: Bool
    var process: String
    var icon: String?

    init(id: String, name: String, wasteDescription: String, isFavorite: Bool, process: String, icon: String?) {
        self.id = id
        self.name = name
        self.wasteDescription = wasteDescription
        self.isFavorite = isFavorite
        self.process = process
        self.icon = icon
    }

    // Decodable Conformance
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.wasteDescription = try container.decode(String.self, forKey: .wasteDescription)
        self.isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        self.process = try container.decode(String.self, forKey: .process)
        self.icon = try? container.decode(String.self, forKey: .icon)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, wasteDescription = "description", isFavorite, process, icon
    }
}
