//
//  ModelForGraph.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 24.04.2023.
//

import Foundation

struct ModelForGraph: Identifiable {
    let id = UUID()
    let date: String
    var value: Int
    var type: String?
    var animate: Bool = false
}
