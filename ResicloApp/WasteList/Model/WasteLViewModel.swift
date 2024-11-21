//
//  WasteLViewModel.swift
//  ResicloApp
//
//  Created by Hugo Ochoa  on 06/11/24.
//

import Foundation
import SwiftData

@Observable
class ModelData {
    func initializeData(context: ModelContext) {
        loadData(context: context) // Carga datos desde el JSON y los guarda
    }

}

func loadData(context: ModelContext) {
    guard let url = Bundle.main.url(forResource: "wasteLData.json", withExtension: nil) else {
        fatalError("No se encontró el archivo JSON.")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let wastes = try decoder.decode([WasteL].self, from: data)

        let descriptor = FetchDescriptor<WasteL>()
        let existingWastes = try context.fetch(descriptor)

        print("Datos existentes: \(existingWastes.count)") // Verifica si hay datos existentes

        for waste in wastes {
            if existingWastes.contains(where: { $0.id == waste.id }) {
                continue // Evita duplicados
            }
            context.insert(waste)
        }

        try context.save() // Guarda los datos

        print("Datos cargados correctamente: \(wastes.count)") // Confirma que los datos se cargaron
    } catch {
        fatalError("Error al cargar el JSON: \(error)")
    }
}

