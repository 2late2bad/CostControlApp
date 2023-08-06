//
//  IncomeViewModel.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 12.04.2023.
//

import Foundation
import SwiftUI

final class IncomeViewModel: ObservableObject {

    @Published var incomes: [Income] = [] {
        didSet {
            saveIncomes()
            calculateBalance()
        }
    }
    @Published var sumIncomes: Int = 0
    @Published var textField: String = ""
    @Published var datePicker: Date = .now
    @Published var isShowTextField: Bool = false
    @Published var buttonIsActive = true
    @Published var calendarId: UUID = UUID()
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        incomes = loadIncomes()
        calculateBalance()
    }
    
    func buttonPressed() {
        isShowTextField.toggle()
        if textField.isEmpty {
            buttonIsActive = false
        } else {
            incomes.append(Income(value: Int(textField)!, date: datePicker))
            incomes.sort { $0.date > $1.date }
            calculateBalance()
            textField = ""
            datePicker = .now
        }
    }
    
    func buttonAvailabilityCheck() {
        if textField.isEmpty {
            buttonIsActive = false
        } else {
            buttonIsActive = true
        }
    }
    
    func deleteRow(at offsets: IndexSet) {
        incomes.remove(atOffsets: offsets)
        incomes.sort { $0.date > $1.date }
        calculateBalance()
    }
    
}

private extension IncomeViewModel {
    
    func saveIncomes() {
        do {
            let encodedData = try JSONEncoder().encode(incomes)
            userDefaults.set(encodedData, forKey: "Incomes")
        } catch {
            print(">>> ENCODE ERROR")
        }
    }
    
    func loadIncomes() -> [Income] {
        if let savedData = userDefaults.object(forKey: "Incomes") as? Data {
            do {
                let savedIncomes = try JSONDecoder().decode([Income].self, from: savedData)
                return savedIncomes
            } catch {
                print(">>> DECODE ERROR")
            }
        }
        // Тестовый массив, если он не нужен - возвращаем пустой массив.
        return []
    }
    
    func calculateBalance() {
        var newBalance = 0
        incomes.forEach { item in
            newBalance += item.value
        }
        sumIncomes = newBalance
    }
    
}



