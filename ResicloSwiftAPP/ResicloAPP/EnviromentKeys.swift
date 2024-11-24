//
//  EnviromentKeys.swift
//  ResicloApp
//
//  Created by Diego Esparza on 07/11/24.
//

import SwiftUI

// Definir la clave de entorno personalizada para `profileImageURL`
struct ProfileImageURLKey: EnvironmentKey {
    static let defaultValue: URL? = nil // Valor predeterminado de `nil`
}

// Extender `EnvironmentValues` para agregar la clave `profileImageURL`
extension EnvironmentValues {
    var profileImageURL: URL? {
        get { self[ProfileImageURLKey.self] }
        set { self[ProfileImageURLKey.self] = newValue }
    }
}
