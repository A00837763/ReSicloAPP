//
//  Waste.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//


//
//  Waste.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//

import Foundation

struct Waste: Identifiable, Codable {
    let id: String
    let attributes: WasteAttributes
    
    var name: String? { attributes.name } // Extract 'name' and 'description' for convenience
    var description: String? { attributes.description }
}

struct WasteAttributes: Codable {
    let name: String?
    let description: String?
}