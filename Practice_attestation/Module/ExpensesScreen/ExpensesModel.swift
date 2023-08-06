//
//  ExpensesModel.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 12.04.2023.
//

import Foundation

struct Category: Identifiable, Codable {
    private(set) var id = UUID()
    let name: String
    var expenses: [Expense]
}

struct Expense: Identifiable, Codable {
    private(set) var id = UUID()
    let name: String
    let date: Date
    var value: Int
    var animate: Bool = false
    
    var dateString: String {
        let dateTest = DateFormatter()
        dateTest.locale = Locale(identifier: "ru_RU")
        dateTest.dateFormat = "dd/MM/yy"
        return dateTest.string(from: self.date)
    }
}
