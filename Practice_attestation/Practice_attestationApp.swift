//
//  Practice_attestationApp.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 11.04.2023.
//

import SwiftUI

@main
struct Practice_attestationApp: App {
    
    @StateObject var general = GeneralEnvironment()
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .onAppear {
                    UserDefaults.standard.set(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                }
                .environmentObject(general)
        }
    }
}
