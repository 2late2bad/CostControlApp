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
        return [
            Category(name: "Дом", expenses: [
                Expense(name: "Сковородка", date: .from(year: 2023, month: 7, day: 30), value: 1500),
                Expense(name: "Чайник", date: .from(year: 2023, month: 8, day: 2), value: 900),
                Expense(name: "Лампочка", date: .from(year: 2023, month: 7, day: 31), value: 200),
                Expense(name: "Телевизор", date: .from(year: 2023, month: 8, day: 3), value: 35000),
                Expense(name: "СВЧ", date: .from(year: 2023, month: 8, day: 2), value: 1500),
                Expense(name: "Кресло", date: .from(year: 2023, month: 7, day: 31), value: 28000),
                Expense(name: "Холодильник", date: .from(year: 2023, month: 8, day: 1), value: 40000),
                Expense(name: "Светильник", date: .from(year: 2023, month: 8, day: 1), value: 11000),
                Expense(name: "Смеситель", date: .from(year: 2023, month: 8, day: 1), value: 4700)
            ].sorted { $0.date > $1.date }),
            Category(name: "Продукты", expenses: [
                Expense(name: "Чай", date: .from(year: 2023, month: 8, day: 3), value: 213),
                Expense(name: "Кофе", date: .from(year: 2023, month: 8, day: 4), value: 849),
                Expense(name: "Хлеб", date: .from(year: 2023, month: 8, day: 4), value: 40),
                Expense(name: "Молоко", date: .from(year: 2023, month: 8, day: 4), value: 75),
                Expense(name: "Яйца", date: .from(year: 2023, month: 8, day: 5), value: 92),
                Expense(name: "Вафли", date: .from(year: 2023, month: 8, day: 5), value: 88),
                Expense(name: "Мороженое", date: .from(year: 2023, month: 8, day: 5), value: 120),
                Expense(name: "Коньяк", date: .from(year: 2023, month: 7, day: 31), value: 4299),
                Expense(name: "Говядина", date: .from(year: 2023, month: 8, day: 6), value: 980),
                Expense(name: "Сахар", date: .from(year: 2023, month: 8, day: 6), value: 69)
            ].sorted { $0.date > $1.date }),
            Category(name: "Досуг", expenses: [
                Expense(name: "Кинотеатр", date: .from(year: 2023, month: 8, day: 1), value: 450),
                Expense(name: "Театр", date: .from(year: 2023, month: 8, day: 3), value: 4000),
                Expense(name: "Горнолыжка", date: .from(year: 2023, month: 8, day: 5), value: 20000)
            ].sorted { $0.date > $1.date }),
            Category(name: "Постоянные траты", expenses: [
                Expense(name: "Онлайн-кино", date: .from(year: 2023, month: 4, day: 1), value: 300),
                Expense(name: "Онлайн-кино", date: .from(year: 2023, month: 5, day: 1), value: 300),
                Expense(name: "Онлайн-кино", date: .from(year: 2023, month: 6, day: 1), value: 300),
                Expense(name: "Онлайн-кино", date: .from(year: 2023, month: 7, day: 1), value: 300),
                Expense(name: "Собачий корм", date: .from(year: 2023, month: 8, day: 1), value: 1300)
            ]),
            Category(name: "Путешествия", expenses: [
                Expense(name: "Казахстан", date: .from(year: 2023, month: 7, day: 14), value: 50000),
            ].sorted { $0.date > $1.date })]
    }
    
    func calculateExpenses() {
        var newValue = 0
        categories.forEach { $0.expenses.forEach { newValue += $0.value } }
        sumExpenses = newValue
    }
    
}
