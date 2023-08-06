//
//  ScheduleView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 24.04.2023.
//

import SwiftUI
import Charts

struct ScheduleView: View {
    
    @ObservedObject var scheduleViewModel: ScheduleViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 14) {
                    Text("Доходы и расходы")
                        .fontWeight(.semibold)
                    
                    Text(scheduleViewModel.calculationBalance())
                        .font(.caption2)
                    
                    Picker("", selection: $scheduleViewModel.currentTab) {
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
            .onChange(of: scheduleViewModel.currentTab) { newValue in
                switch newValue {
                case .Week:
                    scheduleViewModel.loadWeeksExpenses()
                case .Month:
                    scheduleViewModel.loadMonthExpenses()
                case .Quarter:
                    scheduleViewModel.loadQuarterExpenses()
                case .All:
                    scheduleViewModel.loadAllExpenses()
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
            scheduleViewModel.loadWeeksExpenses()
        }
        .toolbarRole(.editor)
    }
    
    @ViewBuilder
    func AnimatedCharts() -> some View {
        let max = scheduleViewModel.actExpAndInc.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        Chart {
            ForEach(scheduleViewModel.actExpAndInc) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Values", item.animate ? item.value : 0)
                )
                .foregroundStyle(by: .value("Type", "\(item.type!)"))
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let item = value.as(String.self) {
                        Text(item)
                            .font(scheduleViewModel.getActuallyFontXAxis(scheduleViewModel.currentTab))
                    }
                }
                AxisGridLine(centered: true, stroke: .none)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading,
                      values: .automatic(minimumStride: 50, desiredCount: 6))
        }
        .chartYScale(domain: 0...(scheduleViewModel.getUpperBoundRange(max)))
        .frame(height: 400)
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in scheduleViewModel.actExpAndInc.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.015 : 0.035)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.5) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5)) {
                    scheduleViewModel.actExpAndInc[index].animate = true
                }
            }
        }
    }
}

private extension ScheduleView {
    
}
