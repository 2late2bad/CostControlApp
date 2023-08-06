//
//  TabBarView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 11.04.2023.
//

import SwiftUI

struct TabBarView: View {
    
    @State private var id1 = UUID()
    @State private var id2 = UUID()
            
    @StateObject var router = TabBarRouter()
    @StateObject var expenseViewModel: ExpensesViewModel = ExpensesViewModel()
    @StateObject var incomeViewModel: IncomeViewModel = IncomeViewModel()

    var body: some View {
        TabView(selection: $router.screen) {
            IncomeView()
                .tabItem {
                    Label("Доходы", systemImage: "dollarsign.square")
                }
                .tag(Screen.Income)
            
            ScheduleView(scheduleViewModel: ScheduleViewModel(expenseViewModel: expenseViewModel,
                                                              incomeViewModel: incomeViewModel))
                .tabItem {
                    Label("График", systemImage: "chart.xyaxis.line")
                }
                .tag(Screen.Schedule)
                .id(id2)
            
            ExpensesView()
                .tabItem {
                    Label("Расходы", systemImage: "cart.badge.minus")
                }
                .tag(Screen.Expenses)
                .id(id1)
        }
        .environmentObject(expenseViewModel)
        .environmentObject(incomeViewModel)
        .onReceive(router.$screen) { out in
            if out != .Expenses {
                id1 = UUID()
            }
            if out != .Schedule {
                id2 = UUID()
            }
        }
    }
}
