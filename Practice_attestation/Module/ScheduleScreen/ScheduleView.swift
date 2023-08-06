//
//  ScheduleView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 24.04.2023.
//

import SwiftUI
import Charts

struct ScheduleView: View {
    
    @EnvironmentObject var expenseViewModel: ExpensesViewModel
    @EnvironmentObject var incomeViewModel: IncomeViewModel
    
    @State var actExpAndInc: [ModelForGraph] = []
    @State var currentTab: TabGraph = .Week
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 14) {
                    Text("Доходы и расходы")
                        .fontWeight(.semibold)
                    
                    Text(calculationBalance())
                        .font(.caption2)
                    
                    Picker("", selection: $currentTab) {
                        Text("неделя")
                            .tag(TabGraph.Week)
                        Text("месяц")
                            .tag(TabGraph.Month)
                        Text("квартал")
                            .tag(TabGraph.Quarter)
                        Text("год")
                            .tag(TabGraph.All)
                    }
                    .pickerStyle(.segmented)
                }
                
                AnimatedCharts()
            }
            .padding(10)
            .background {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(.white.shadow(.drop(radius: 20)))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding()
            .navigationTitle("Сводный график")
            
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: currentTab) { newValue in
                switch newValue {
                case .Week:
                    loadWeeksExpenses()
                case .Month:
                    loadMonthExpenses()
                case .Quarter:
                    loadQuarterExpenses()
                case .All:
                    loadAllExpenses()
                }
                
                animateGraph(fromChange: true)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrowshape.backward.fill")
        })
        .onAppear {
            loadWeeksExpenses()
        }
        .toolbarRole(.editor)
        
    }
    
    @ViewBuilder
    func AnimatedCharts() -> some View {
        let max = actExpAndInc.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        Chart {
            ForEach(actExpAndInc) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Values", item.animate ? item.value : 0)
                )
                .foregroundStyle(by: .value("Type", "\(item.type!)"))
                
                //                PointMark(
                //                    x: .value("Date3", item.date),
                //                    y: .value("Values4", item.animate ? item.value : 0)
                //                )
                //                .foregroundStyle(by: .value("Type", "\(item.type!.uppercased())"))
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let item = value.as(String.self) {
                        Text(item)
                            .font(getActuallyFontXAxis(currentTab))
                    }
                }
                AxisGridLine(centered: true, stroke: .none)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading,
                      values: .automatic(minimumStride: 50, desiredCount: 6))
        }
        .chartYScale(domain: 0...(getUpperBoundRange(max)))
        .frame(height: 400)
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in actExpAndInc.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.015 : 0.035)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.5) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5)) {
                    actExpAndInc[index].animate = true
                }
            }
        }
    }
}

private extension ScheduleView {
    func loadWeeksExpenses() {
        var filterData: [ModelForGraph] = []
        
        var allExpenses: [Expense] = []
        for category in expenseViewModel.categories {
            for expense in category.expenses {
                allExpenses.append(expense)
            }
        }
        
        let week = (-7...0).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: Date())?.displayFormatDayMonthYear
        }
        let weekExspenses = allExpenses.filter { week.contains($0.date.displayFormatDayMonthYear) }
        let weekIncomes = incomeViewModel.incomes.filter { week.contains($0.date.displayFormatDayMonthYear) }
        
        for item in week {
            let valueExp = weekExspenses.reduce(0) { partialResult, expense in
                if expense.date.displayFormatDayMonthYear == item {
                    return (partialResult + expense.value)
                } else {
                    return partialResult
                }
            }
            let valueInc = weekIncomes.reduce(0) { partialResult, expense in
                if expense.date.displayFormatDayMonthYear == item {
                    return (partialResult + expense.value)
                } else {
                    return partialResult
                }
            }
            filterData.append(ModelForGraph(date: String(item.dropLast(3)), value: valueExp, type: Constants.expType))
            filterData.append(ModelForGraph(date: String(item.dropLast(3)), value: valueInc, type: Constants.incType))
        }
        
        actExpAndInc = filterData
    }
    
    func loadMonthExpenses() {
        var filterData: [ModelForGraph] = []
        
        let month = Date().getDaysOfMonth().map {$0.displayFormatDayMonthYear}
        let actDate = Date.now.displayFormatDayMonthYear
        
        guard let index = month.firstIndex(of: actDate) else { return }
        let newMonth = month[0...index]
        
        var allExpenses: [Expense] = []
        for category in expenseViewModel.categories {
            for expense in category.expenses {
                allExpenses.append(expense)
            }
        }
        
        let monthExspenses = allExpenses.filter { newMonth.contains($0.date.displayFormatDayMonthYear) }
        let monthIncomes = incomeViewModel.incomes.filter { newMonth.contains($0.date.displayFormatDayMonthYear) }
        
        for item in newMonth {
            let valueExp = monthExspenses.reduce(0) { partialResult, expense in
                if expense.date.displayFormatDayMonthYear == item {
                    return (partialResult + expense.value)
                } else {
                    return partialResult
                }
            }
            let valueInc = monthIncomes.reduce(0) { partialResult, expense in
                if expense.date.displayFormatDayMonthYear == item {
                    return (partialResult + expense.value)
                } else {
                    return partialResult
                }
            }
            
            filterData.append(ModelForGraph(date: String(item.dropLast(6)), value: valueExp, type: Constants.expType))
            filterData.append(ModelForGraph(date: String(item.dropLast(6)), value: valueInc, type: Constants.incType))
        }
        
        actExpAndInc = filterData
    }
    
    func loadQuarterExpenses() {
        var filterData: [ModelForGraph] = []
        
        let actQuarter = Date.now.formatted(Date.FormatStyle().quarter(.oneDigit))
        
        var value1 = 0
        var value2 = 0
        var value3 = 0
        var value4 = 0
        var value5 = 0
        var value6 = 0
        
        var allExpenses: [Expense] = []
        for category in expenseViewModel.categories {
            for expense in category.expenses {
                allExpenses.append(expense)
            }
        }
        
        let filterForYearExpenses = allExpenses.filter { expense in
            expense.date.displayFormatDayMonthYear.suffix(2) == Date.now.displayFormatDayMonthYear.suffix(2)
        }
        let filterForYearIncomes = incomeViewModel.incomes.filter { income in
            income.date.displayFormatDayMonthYear.suffix(2) == Date.now.displayFormatDayMonthYear.suffix(2)
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
            filterData.append(contentsOf: [
                ModelForGraph(date: "Январь", value: value1, type: Constants.expType),
                ModelForGraph(date: "Февраль", value: value2, type: Constants.expType),
                ModelForGraph(date: "Март", value: value3, type: Constants.expType)])
            
            filterForYearIncomes.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 1: value4 += item.value
                case 2: value5 += item.value
                case 3: value6 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Январь", value: value4, type: Constants.incType),
                ModelForGraph(date: "Февраль", value: value5, type: Constants.incType),
                ModelForGraph(date: "Март", value: value6, type: Constants.incType)])
        case 2:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 4: value1 += item.value
                case 5: value2 += item.value
                case 6: value3 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Апрель", value: value1, type: Constants.expType),
                ModelForGraph(date: "Май", value: value2, type: Constants.expType),
                ModelForGraph(date: "Июнь", value: value3, type: Constants.expType)])
            
            filterForYearIncomes.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 4: value4 += item.value
                case 5: value5 += item.value
                case 6: value6 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Апрель", value: value4, type: Constants.incType),
                ModelForGraph(date: "Май", value: value5, type: Constants.incType),
                ModelForGraph(date: "Июнь", value: value6, type: Constants.incType)])
        case 3:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 7: value1 += item.value
                case 8: value2 += item.value
                case 9: value3 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Июль", value: value1, type: Constants.expType),
                ModelForGraph(date: "Август", value: value2, type: Constants.expType),
                ModelForGraph(date: "Сентябрь", value: value3, type: Constants.expType)])
            
            filterForYearIncomes.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 7: value4 += item.value
                case 8: value5 += item.value
                case 9: value6 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Июль", value: value4, type: Constants.incType),
                ModelForGraph(date: "Август", value: value5, type: Constants.incType),
                ModelForGraph(date: "Сентябрь", value: value6, type: Constants.incType)])
        case 4:
            filterForYearExpenses.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 10: value1 += item.value
                case 11: value2 += item.value
                case 12: value3 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Октябрь", value: value1, type: Constants.expType),
                ModelForGraph(date: "Ноябрь", value: value2, type: Constants.expType),
                ModelForGraph(date: "Декабрь", value: value3, type: Constants.expType)])
            
            filterForYearIncomes.forEach { item in
                switch Int(item.date.displayFormatMonth) {
                case 10: value4 += item.value
                case 11: value5 += item.value
                case 12: value6 += item.value
                default: break
                }
            }
            filterData.append(contentsOf: [
                ModelForGraph(date: "Октябрь", value: value4, type: Constants.incType),
                ModelForGraph(date: "Ноябрь", value: value5, type: Constants.incType),
                ModelForGraph(date: "Декабрь", value: value6, type: Constants.incType)])
        default:
            break
        }
        
        actExpAndInc = filterData
    }
    
    func loadAllExpenses() {
        var filterData: [ModelForGraph] = [
            ModelForGraph(date: "ЯНВ", value: 0, type: Constants.expType),
            ModelForGraph(date: "ФЕВ", value: 0, type: Constants.expType),
            ModelForGraph(date: "МАРТ", value: 0, type: Constants.expType),
            ModelForGraph(date: "АПР", value: 0, type: Constants.expType),
            ModelForGraph(date: "МАЙ", value: 0, type: Constants.expType),
            ModelForGraph(date: "ИЮНЬ", value: 0, type: Constants.expType),
            ModelForGraph(date: "ИЮЛЬ", value: 0, type: Constants.expType),
            ModelForGraph(date: "АВГ", value: 0, type: Constants.expType),
            ModelForGraph(date: "СЕНТ", value: 0, type: Constants.expType),
            ModelForGraph(date: "ОКТ", value: 0, type: Constants.expType),
            ModelForGraph(date: "НОЯБ", value: 0, type: Constants.expType),
            ModelForGraph(date: "ДЕК", value: 0, type: Constants.expType),
            ModelForGraph(date: "ЯНВ", value: 0, type: Constants.incType),
            ModelForGraph(date: "ФЕВ", value: 0, type: Constants.incType),
            ModelForGraph(date: "МАРТ", value: 0, type: Constants.incType),
            ModelForGraph(date: "АПР", value: 0, type: Constants.incType),
            ModelForGraph(date: "МАЙ", value: 0, type: Constants.incType),
            ModelForGraph(date: "ИЮНЬ", value: 0, type: Constants.incType),
            ModelForGraph(date: "ИЮЛЬ", value: 0, type: Constants.incType),
            ModelForGraph(date: "АВГ", value: 0, type: Constants.incType),
            ModelForGraph(date: "СЕНТ", value: 0, type: Constants.incType),
            ModelForGraph(date: "ОКТ", value: 0, type: Constants.incType),
            ModelForGraph(date: "НОЯБ", value: 0, type: Constants.incType),
            ModelForGraph(date: "ДЕК", value: 0, type: Constants.incType)
        ]
        
        var allExpenses: [Expense] = []
        for category in expenseViewModel.categories {
            for expense in category.expenses {
                allExpenses.append(expense)
            }
        }
        
        let actYear = Date.now.displayFormatActYear
        let filterForYearExpenses = allExpenses.filter { expense in
            expense.date.displayFormatActYear == actYear
        }
        let filterForYearIncomes = incomeViewModel.incomes.filter { income in
            income.date.displayFormatActYear == actYear
        }
        
        filterForYearExpenses.forEach { item in
            switch Int(item.date.displayFormatMonth) {
            case 1: filterData[0].value += item.value
            case 2: filterData[1].value += item.value
            case 3: filterData[2].value += item.value
            case 4: filterData[3].value += item.value
            case 5: filterData[4].value += item.value
            case 6: filterData[5].value += item.value
            case 7: filterData[6].value += item.value
            case 8: filterData[7].value += item.value
            case 9: filterData[8].value += item.value
            case 10: filterData[9].value += item.value
            case 11: filterData[10].value += item.value
            case 12: filterData[11].value += item.value
            default: break
            }
        }
        
        filterForYearIncomes.forEach { item in
            switch Int(item.date.displayFormatMonth) {
            case 1: filterData[12].value += item.value
            case 2: filterData[13].value += item.value
            case 3: filterData[14].value += item.value
            case 4: filterData[15].value += item.value
            case 5: filterData[16].value += item.value
            case 6: filterData[17].value += item.value
            case 7: filterData[18].value += item.value
            case 8: filterData[19].value += item.value
            case 9: filterData[20].value += item.value
            case 10: filterData[21].value += item.value
            case 11: filterData[22].value += item.value
            case 12: filterData[23].value += item.value
            default: break
            }
        }
        
        actExpAndInc = filterData
    }
    
    func getActuallyFontXAxis(_ tab: TabGraph) -> SwiftUI.Font {
        switch tab {
        case .Week:
            return .footnote
        case .Month:
            if actExpAndInc.count > 17 {
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
    
    func calculationBalance() -> String {
        
        var summInc = 0
        var summExp = 0
        
        actExpAndInc.forEach { item in
            if item.type == Constants.incType {
                summInc += item.value
            }
            if item.type == Constants.expType {
                summExp += item.value
            }
        }
        
        let totalValue = summInc - summExp
        
        switch currentTab {
        case .Week:
            return "Баланс за неделю составляет: \(totalValue.formatted()) руб."
        case .Month:
            return "Баланс за \(Date.now.displayFormatMonthRusLocale) составляет: \(totalValue.formatted()) руб."
        case .Quarter:
            return "Баланс за \(Date.now.formatted(Date.FormatStyle().quarter(.oneDigit))) квартал составляет: \(totalValue.formatted()) руб."
        case .All:
            return "Баланс за \(Date.now.displayFormatActYear) год составляет: \(totalValue.formatted()) руб."
        }
        
    }
}

//struct ScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScheduleView()
//    }
//}
