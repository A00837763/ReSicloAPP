extension RecyclingCenter {
    static var preview: RecyclingCenter {
        RecyclingCenter(
            centerId: 1,
            name: "Centro de Reciclaje",
            desc: "Un centro ecológico dedicado al reciclaje responsable.",
            address: "123 Calle Verde",
            city: "Monterrey",
            state: "Nuevo León",
            country: "México",
            postalCode: "64000",
            latitude: 25.6866,
            longitude: -100.3161,
            phone: "81-1234-5678",
            email: "contacto@reciclaje.com",
            website: "www.reciclaje.com",
            operatingHours: [
                OperatingHours(day: "Lunes", openingTime: "9:00", closingTime: "18:00"),
                OperatingHours(day: "Martes", openingTime: "9:00", closingTime: "18:00")
            ],
            wasteCategories: [
                WasteCategory(categoryId: 1, name: "Papel", desc: "Todo tipo de papel", process: "Separar", tips: "Mantener seco", icon: nil),
                WasteCategory(categoryId: 2, name: "Plástico", desc: "PET y HDPE", process: "Limpiar", tips: "Aplastar", icon: nil)
            ]
        )
    }
}

extension WasteCategory {
    static var preview: WasteCategory {
        WasteCategory(
            categoryId: 1,
            name: "Papel",
            desc: "Todo tipo de papel",
            process: "Separar",
            tips: "Mantener seco",
            icon: nil
            
        )
    }
}
