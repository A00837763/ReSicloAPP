//
//  WasteLViewModel.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//

import Foundation

@Observable
class ModelData {
    var categories: [WasteCategory] = []
    var isLoading = false
    private let baseURL = "http://recycling-centers-api.vercel.app/api"
    
    func fetchCategories() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let url = URL(string: "\(baseURL)/waste-categories")!
            let (data, _) = try await URLSession.shared.data(from: url)
            self.categories = try JSONDecoder().decode([WasteCategory].self, from: data)
        } catch {
            print("Error fetching categories: \(error)")
        }
    }
}

