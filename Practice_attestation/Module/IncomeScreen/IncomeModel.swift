//
//  IncomeModel.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 12.04.2023.
//

import Foundation

struct Income: Identifiable, Codable {
    private(set) var id = UUID()
    let value: Int
    let date: Date
    
    var dateString: String {
        let dateTest = DateFormatter()
        dateTest.locale = Locale(identifier: "ru_RU")
        dateTest.dateFormat = "dd/MM/yy"
        return dateTest.string(from: self.date)
    }
}
