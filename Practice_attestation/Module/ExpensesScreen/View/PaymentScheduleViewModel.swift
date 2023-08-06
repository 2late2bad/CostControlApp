//
//  PaymentScheduleViewModel.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 07.08.2023.
//

import SwiftUI

final class PaymentScheduleViewModel: ObservableObject {
    
    let expenses: [Expense]
    @Published var actExpense: [ModelForGraph] = []
    @Published var currentTab: TabGraph = .Week
    
    init(expenses: [Expense]) {
        self.expenses = expenses
    }
    
    func loadWeeksExpenses() {
        var newExpenses: [ModelForGraph] = []
        
        let week = (-7...0).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: Date())?.displayFormatDayMonthYear
        }
        let weekExspenses = expenses.filter { week.contains($0.date.displayFormatDayMonthYear) }
        
        for item in week {
            let value = weekExspenses.reduce(0) { partialResult, expense in
                if expense.date.displayFormatDayMonthYear == item {
                    return (partialResult + expense.value)
                } else {
                    return partialResult
                }
            }
            newExpenses.append(ModelForGraph(date: String(item.dropLast(3)), value: value))
        }
        
        actExpense = newExpenses
    }
    
    func loadMonthExpenses() {
        var newExpenses: [ModelForGraph] = []
        
        let month = Date().getDaysOfMonth().map {$0.displayFormatDayMonthYear}
        let actDate = Date.now.displayFormatDayMonthYear
        
        guard let index = month.firstIndex(of: actDate) else { return }
        let newMonth = month[0...index]
        
        let monthExspenses = expenses.filter { newMonth.contains($0.date.displayFormatDayMonthYear) }

        for item in newMonth {
            let value = monthExspenses.reduce(0) { partialResult, expense in
                if expense.date.displayFormatDayMonthYear == item {
                    return (partialResult + expense.value)
                } else {
                    return partialResult
                }
            }

            newExpenses.append(ModelForGraph(date: String(item.dropLast(6)), value: value))
        }

        actExpense = newExpenses
    }
    
    func loadQuarterExpenses() {
        var newExpenses: [ModelForGraph] = []
        
        let actQuarter = Date.now.formatted(Date.FormatStyle().quarter(.oneDigit))

        var value1 = 0
        var value2 = 0
        var value3 = 0
        
        let filterForYearExpenses = expenses.filter { expense in
            expense.date.displayFormatDayMonthYear.suffix(2) == Date.now.displayFormatDayMonthYear.suffix(2)
        }
                        
        switch Int(actQuarter) {
        case 1:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 1: value1 += item.value
                case 2: value2 += item.value
                case 3: value3 += item.value
                default: break
                }
            }
            newExpenses.append(contentsOf: [
                ModelForGraph(date: "Январь", value: value1),
                ModelForGraph(date: "Февраль", value: value2),
                ModelForGraph(date: "Март", value: value3)])
        case 2:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 4: value1 += item.value
                case 5: value2 += item.value
                case 6: value3 += item.value
                default: break
                }
            }
            newExpenses.append(contentsOf: [
                ModelForGraph(date: "Апрель", value: value1),
                ModelForGraph(date: "Май", value: value2),
                ModelForGraph(date: "Июнь", value: value3)])
        case 3:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 7: value1 += item.value
                case 8: value2 += item.value
                case 9: value3 += item.value
                default: break
                }
            }
            newExpenses.append(contentsOf: [
                ModelForGraph(date: "Июль", value: value1),
                ModelForGraph(date: "Август", value: value2),
                ModelForGraph(date: "Сентябрь", value: value3)])
        case 4:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 10: value1 += item.value
                case 11: value2 += item.value
                case 12: value3 += item.value
                default: break
                }
            }
            newExpenses.append(contentsOf: [
                ModelForGraph(date: "Октябрь", value: value1),
                ModelForGraph(date: "Ноябрь", value: value2),
                ModelForGraph(date: "Декабрь", value: value3)])
        default:
            break
        }

        actExpense = newExpenses
    }
    
    func loadAllExpenses() {
        var newExpenses: [ModelForGraph] = [
            ModelForGraph(date: "ЯНВ", value: 0),
            ModelForGraph(date: "ФЕВ", value: 0),
            ModelForGraph(date: "МАРТ", value: 0),
            ModelForGraph(date: "АПР", value: 0),
            ModelForGraph(date: "МАЙ", value: 0),
            ModelForGraph(date: "ИЮНЬ", value: 0),
            ModelForGraph(date: "ИЮЛЬ", value: 0),
            ModelForGraph(date: "АВГ", value: 0),
            ModelForGraph(date: "СЕНТ", value: 0),
            ModelForGraph(date: "ОКТ", value: 0),
            ModelForGraph(date: "НОЯБ", value: 0),
            ModelForGraph(date: "ДЕК", value: 0),
        ]
        
        let actYear = Date.now.displayFormatActYear
        let filterForYearExpenses = expenses.filter { expense in
            expense.date.displayFormatActYear == actYear
        }
        
        filterForYearExpenses.forEach { item in
            switch Int(item.date.displayFormatMonth) {
            case 1: newExpenses[0].value += item.value
            case 2: newExpenses[1].value += item.value
            case 3: newExpenses[2].value += item.value
            case 4: newExpenses[3].value += item.value
            case 5: newExpenses[4].value += item.value
            case 6: newExpenses[5].value += item.value
            case 7: newExpenses[6].value += item.value
            case 8: newExpenses[7].value += item.value
            case 9: newExpenses[8].value += item.value
            case 10: newExpenses[9].value += item.value
            case 11: newExpenses[10].value += item.value
            case 12: newExpenses[11].value += item.value
            default: break
            }
        }

        actExpense = newExpenses
    }
    
    func getActuallyFontXAxis(_ tab: TabGraph) -> SwiftUI.Font {
        switch tab {
        case .Week:
            return .footnote
        case .Month:
            if actExpense.count > 17 {
                return .system(size: 8)
            } else {
                return .footnote
            }
        case .Quarter: return .caption
        case .All: return .system(size: 7, weight: .semibold, design: .rounded)
        }
    }
    
    func getUpperBoundRange(_ max: Int) -> Int {
        switch max {
        case let x where (x <= 1000):
            return (max + 100)
        case let x where (x > 1000) && (x <= 10000):
            return (max + 1000)
        case let x where (x > 10000):
            return (max + 10000)
        default: return 0
        }
    }
    
    func calculationTotalExpenses(general: Bool) -> String {
        
        if general {
            let totalValue = expenses.reduce(0) { partialResult, item in
                item.value + partialResult
            }
            return "Общие траты по категории составили \(totalValue.formatted()) рублей"
        } else {
            let totalValue = actExpense.reduce(0) { partialResult, item in
                item.value + partialResult
            }
            
            switch currentTab {
            case .Week:
                return "Суммарные траты за неделю составили: \(totalValue.formatted()) руб."
            case .Month:
                return "Суммарные траты за \(Date.now.displayFormatMonthRusLocale) составили: \(totalValue.formatted()) руб."
            case .Quarter:
                return "Суммарные траты за \(Date.now.formatted(Date.FormatStyle().quarter(.oneDigit))) квартал составили: \(totalValue.formatted()) руб."
            case .All:
                return "Суммарные траты за \(Date.now.displayFormatActYear) год составили: \(totalValue.formatted()) руб."
            }
        }
    }
}
