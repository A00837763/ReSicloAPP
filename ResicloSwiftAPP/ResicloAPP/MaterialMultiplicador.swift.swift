//
//  MaterialMultiplicador.swift.swift
//  ResicloApp
//
//  Created by Diego Esparza on 25/11/24.
//

import Foundation

/// Clase que contiene la lógica para obtener el multiplicador de impacto según el material
class MaterialMultiplicador {
    /// Obtiene el multiplicador de impacto basado en el material
    static func obtenerMultiplicador(para material: String) -> Double {
        switch material {
        case "ABS": return 64.0
        case "Aceite vegetal usado": return 85.0
        case "Acero inoxidable": return 70.0
        case "Acumuladores": return 94.0
        case "Aluminio": return 100.0
        case "Antimonio": return 61.0
        case "Árboles de Navidad": return 46.0
        case "Balastra": return 55.0
        case "Bolsas de plástico": return 49.0
        case "Bolsas HDPE (Plástico NO. 2)": return 58.0
        case "Bolsas reutilizables (PP)": return 52.0
        case "BOPP (Polipropileno Biorientado- Plástico No. 5)": return 55.0
        case "Botella de Grupo Modelo": return 70.0
        case "Bronce": return 67.0
        case "Cables": return 64.0
        case "Caple": return 49.0
        case "Cápsulas NESCAFÉ® Dolce Gusto®": return 58.0
        case "Cartón": return 70.0
        case "Cartuchos de tinta": return 85.0
        case "CD": return 46.0
        case "Celulares y accesorios": return 94.0
        case "Cepillo de dientes": return 43.0
        case "Charolas de plástico (PET,PP, PE y PS)": return 52.0
        case "Chatarra": return 73.0
        case "Cobre": return 91.0
        case "Dermocosméticos": return 46.0
        case "Disco de vinilo": return 49.0
        case "Electrónicos": return 97.0
        case "Empaques de Alimento para Mascotas": return 58.0
        case "Envases de Productos de Belleza": return 55.0
        case "Envases de productos SVR": return 49.0
        case "Flexible PE/PP": return 52.0
        case "Flexibles LDPE (Plástico No. 4)": return 58.0
        case "Focos": return 79.0
        case "HDPE": return 64.0
        case "Lata": return 82.0
        case "LDPE": return 61.0
        case "Libros": return 67.0
        case "Línea blanca y refrigeración": return 88.0
        case "Llantas": return 76.0
        case "Magnesio": return 70.0
        case "Medicamentos": return 70.0
        case "Metal": return 73.0
        case "Monedas viejas": return 55.0
        case "Níquel": return 82.0
        case "Papel": return 67.0
        case "Papel mixto": return 64.0
        case "Periódico": return 70.0
        case "PET": return 91.0
        case "Pilas alcalinas": return 85.0
        case "Plástico Duro": return 64.0
        case "Plástico No. 7": return 52.0
        case "Playo": return 58.0
        case "Playo Negro (Plástico #4)": return 61.0
        case "Plomo": return 97.0
        case "Policarbonato (PC)": return 64.0
        case "Poliestireno": return 49.0
        case "Polipropileno (Plástico #5)": return 58.0
        case "Productos Natura": return 55.0
        case "Radiografía": return 67.0
        case "Revistas": return 61.0
        case "Ropa": return 52.0
        case "Ropa para donación": return 76.0
        case "Sanitarios": return 46.0
        case "Tapitas": return 64.0
        case "Tarimas de madera": return 61.0
        case "Tarjetas de plástico (ej. crédito débito...)": return 49.0
        case "Tetra Pak": return 70.0
        case "Tubos de pasta dental": return 52.0
        case "Unicel": return 43.0
        case "Vidrio": return 85.0
        case "Vidrio plano": return 79.0
        default: return 50.0 // Multiplicador por defecto
        }
    }
}
