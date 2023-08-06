//
//  GeneralEnvironment.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 13.04.2023.
//

import Foundation

final class GeneralEnvironment: ObservableObject {
    
    @Published var allExpensesValue: Int = 0 {
        didSet {
            saveAllExpenses()
        }
    }
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        allExpensesValue = loadAllExpenses()
    }
    
    func getBalance(_ incomes: Int) -> Int { (incomes - allExpensesValue) }
    
}

private extension GeneralEnvironment {
    func saveAllExpenses() {
        userDefaults.set(allExpensesValue, forKey: "allExpenses")
    }
    
    func loadAllExpenses() -> Int {
        return userDefaults.integer(forKey: "allExpenses")
    }
}
