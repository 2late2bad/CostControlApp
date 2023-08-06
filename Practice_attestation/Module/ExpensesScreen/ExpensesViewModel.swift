//
//  ExpensesViewModel.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 12.04.2023.
//

import Foundation
import SwiftUI

final class ExpensesViewModel: ObservableObject {
        
    @Published var categories: [Category] = [] {
        didSet {
            saveCategories()
            calculateExpenses()
        }
    }
    @Published var sumExpenses: Int = 0
    
    // For ExpensesView
    @Published var categoryIsShowTextField: Bool = false
    @Published var categoryTextField: String = ""
    @Published var categoryButtonIsActive = true
    
    // For DetailExpensesView
    @Published var expensesIsShowFields: Bool = false
    @Published var expensesNameTextField: String = ""
    @Published var expensesValueTextField: String = ""
    @Published var expensesButtonIsActive = true
    @Published var datePicker: Date = .now
    @Published var calendarId: UUID = UUID()

    private let userDefaults = UserDefaults.standard
    
    init() {
        categories = loadCategories()
        calculateExpenses()
    }
    
    func categoryButtonPressed() {
        categoryIsShowTextField.toggle()
        if categoryTextField.isEmpty {
            categoryButtonIsActive = false
        } else {
            categories.append(Category(name: categoryTextField, expenses: []))
            categoryTextField = ""
        }
    }
    
    func buttonCategoryAvailabilityCheck() {
        if categoryTextField.isEmpty {
            categoryButtonIsActive = false
        } else {
            categoryButtonIsActive = true
        }
    }
    
    func expensesButtonPressed(uuid: UUID) {
        expensesIsShowFields.toggle()
        if expensesNameTextField.isEmpty || expensesValueTextField.isEmpty {
            expensesButtonIsActive = false
        } else {
            for (index, value) in categories.enumerated() {
                if value.id == uuid {
                    categories[index].expenses.append(Expense(name: expensesNameTextField,
                                                              date: datePicker,
                                                              value: Int(expensesValueTextField)!))
                    categories[index].expenses.sort { $0.date > $1.date }
                }
            }
            expensesNameTextField = ""
            expensesValueTextField = ""
            datePicker = .now
        }
    }
    
    func buttonExpensesAvailabilityCheck() {
        if expensesNameTextField.isEmpty || expensesValueTextField.isEmpty {
            expensesButtonIsActive = false
        } else {
            expensesButtonIsActive = true
        }
    }
    
    func deleteRowCategory(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }
    
    func deleteRowExpense(at offsets: IndexSet, uuid: UUID) {
        for (index, value) in categories.enumerated() {
            if value.id == uuid {
                categories[index].expenses.remove(atOffsets: offsets)
            }
        }
    }
    
    func moveRowCategory(indices: IndexSet, newOffset: Int) {
        categories.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func getCategory(for UUID: UUID) -> Category? {
        return categories.first { $0.id == UUID }
    }
    
}

private extension ExpensesViewModel {
    
    func saveCategories() {
        do {
            let encodedData = try JSONEncoder().encode(categories)
            userDefaults.set(encodedData, forKey: "Category")
        } catch {
            print(">>> ENCODE ERROR")
        }
    }
    
    func loadCategories() -> [Category] {
        if let savedData = userDefaults.object(forKey: "Category") as? Data {
            do {
                let savedIncomes = try JSONDecoder().decode([Category].self, from: savedData)
                return savedIncomes
            } catch {
                print(">>> DECODE ERROR")
            }
        }
        // Тестовый массив, если он не нужен - возвращаем пустой массив.
        return []
    }
    
    func calculateExpenses() {
        var newValue = 0
        categories.forEach { $0.expenses.forEach { newValue += $0.value } }
        sumExpenses = newValue
    }
    
}
