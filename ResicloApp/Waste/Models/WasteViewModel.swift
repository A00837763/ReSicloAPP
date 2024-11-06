//
//  WasteViewModel.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//


//
//  WasteViewModel.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 05/11/24.
//


import Foundation

@Observable
class WasteViewModel {
    var wastes: [Waste] = []

    @MainActor
    func fetchWastes() async {
        let url = URL(string: "https://apiecolana.com/api/v1/wastes")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let apiResponse = try JSONDecoder().decode(WasteApiResponse.self, from: data)
            wastes = apiResponse.data
        } catch {
            print("Error fetching wastes: \(error)")
        }
    }
}

struct WasteApiResponse: Codable {
    let data: [Waste]
}
