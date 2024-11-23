import SwiftUI

// PressAction.swift
struct PressAction: ViewModifier {
    let onPress: (Bool) -> Void
    
    func body(content: Content) -> some View {
        content.onLongPressGesture(minimumDuration: .infinity, maximumDistance: .infinity, pressing: onPress, perform: {})
    }
}

extension View {
    func pressAction(onPress: @escaping (Bool) -> Void) -> some View {
        modifier(PressAction(onPress: onPress))
    }
}
