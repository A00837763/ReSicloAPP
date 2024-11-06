//
//  ResicloAppApp.swift
//  ResicloApp
//
//  Created by Santiago Sánchez Reyes on 16/10/24.
//

import SwiftUI
import FirebaseCore

@main
struct ResicloApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

