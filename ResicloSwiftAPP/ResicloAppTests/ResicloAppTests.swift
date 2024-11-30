//
//  ResicloAppTests.swift
//  ResicloAppTests
//
//  Created by Santiago Sánchez Reyes on 29/11/24.
//

//
//  ResicloAppTests.swift
//  ResicloAppTests
//
//  Created by Santiago Sánchez Reyes on 28/11/24.
//

import Testing
import CoreLocation
import SwiftData
@testable import ResicloApp

@MainActor
struct FilteredCentersTests {
    // Helper function to create test centers
    func createTestCenters() -> [RecyclingCenter] {
        let plasticCategory = WasteCategory(
            categoryId: 1,
            name: "Plastico Duro",
            desc: "Plastic recycling",
            process: "Sorting",
            tips: "Clean before recycling",
            icon: nil
        )
        
        let paperCategory = WasteCategory(
            categoryId: 2,
            name: "Papel",
            desc: "Paper recycling",
            process: "Sorting",
            tips: "Remove staples",
            icon: nil
        )
        
        return [
            RecyclingCenter(
                centerId: 1,
                name: "Centro Téc",
                desc: "tecnologico mty",
                address: "123 garza sada",
                city: "Monterrey",
                state: "Nuevo Leon",
                country: "Mexico",
                postalCode: "12345",
                latitude: 25.6866,
                longitude: -100.3161,
                phone: nil,
                email: nil,
                website: nil,
                operatingHours: [],
                wasteCategories: [plasticCategory]
            ),
            RecyclingCenter(
                centerId: 2,
                name: "Papel Recycling",
                desc: "Papel especialista",
                address: "456 Av. papel",
                city: "San Pedro",
                state: "NL",
                country: "Mexico",
                postalCode: "67890",
                latitude: 25.6867,
                longitude: -100.3162,
                phone: nil,
                email: nil,
                website: nil,
                operatingHours: [],
                wasteCategories: [paperCategory]
            )
        ]
    }
    
    @Test("Busqueda vacia regresa todos los centros")
    func emptySearchReturnsAll() throws {
        let centers = createTestCenters()
        let modelContext = try ModelContainer(for: StoredRecyclingCenter.self).mainContext
        let viewModel = MapViewModel(modelContext: modelContext)
        viewModel.filteredCenters = centers
        viewModel.searchText = ""
        
        #expect(viewModel.filteredMarkers.count == centers.count)
    }
    
    @Test("busqueda encuentra con caracteres especiales", arguments: ["tec", "téc", "TEC"])
    func nameSearchWithDiacritics(searchTerm: String) throws {
        let centers = createTestCenters()
        let modelContext = try ModelContainer(for: StoredRecyclingCenter.self).mainContext
        let viewModel = MapViewModel(modelContext: modelContext)
        viewModel.filteredCenters = centers
        viewModel.searchText = searchTerm
        
        #expect(viewModel.filteredMarkers.count == 1)
        #expect(viewModel.filteredMarkers.first?.name == "Centro Téc")
    }
    
    @Test("busqueda encuentra por residuo")
    func wasteCategorySearch() throws {
        let centers = createTestCenters()
        let modelContext = try ModelContainer(for: StoredRecyclingCenter.self).mainContext
        let viewModel = MapViewModel(modelContext: modelContext)
        viewModel.filteredCenters = centers
        viewModel.searchText = "Plastico Duro"
        
        #expect(viewModel.filteredMarkers.count == 1)
        #expect(viewModel.filteredMarkers.first?.wasteCategories.contains { $0.name == "Plastico Duro" } != nil)
    }
    
    @Test("Busqueda encuentra por ciudad")
    func citySearch() throws {
        let centers = createTestCenters()
        let modelContext = try ModelContainer(for: StoredRecyclingCenter.self).mainContext
        let viewModel = MapViewModel(modelContext: modelContext)
        viewModel.filteredCenters = centers
        viewModel.searchText = "Monterrey"
        
        #expect(viewModel.filteredMarkers.count == 1)
        #expect(viewModel.filteredMarkers.first?.city == "Monterrey")
    }
    
    @Test("No matches returns empty array")
    func noMatches() throws {
        let centers = createTestCenters()
        let modelContext = try ModelContainer(for: StoredRecyclingCenter.self).mainContext
        let viewModel = MapViewModel(modelContext: modelContext)
        viewModel.filteredCenters = centers
        viewModel.searchText = "Noexisteelcentro"
        
        #expect(viewModel.filteredMarkers.isEmpty)
    }
}
