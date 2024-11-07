//
//  WasteL.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//
import Foundation
import SwiftUI

struct WasteL: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    var isFavorite: Bool
    let process: String
    let icon: String?  // Make it optional to handle null values in JSON

    // Computed property for AsyncImage loading the icon URL
    var iconURL: URL? {
        guard let icon = icon, !icon.isEmpty else { return nil } // If icon is null or empty, return nil
        return URL(string: icon)
    }
    
    
}
