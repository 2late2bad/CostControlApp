//
//  PaymentScheduleView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 14.04.2023.
//

import SwiftUI
import Charts

struct PaymentScheduleView: View {
    
    let title: String
    
    @ObservedObject var paymentViewModel: PaymentScheduleViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(paymentViewModel.calculationTotalExpenses(general: true))
                    .font(.caption)
                    .fontDesign(.serif)
                    .frame(maxWidth: .infinity, maxHeight: 40, alignment: .center)
                    .background {
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.secondary.opacity(0.2))

                    }
                    .padding(.bottom, 10)
                VStack(alignment: .leading, spacing: 20) {
                    VStack(spacing: 14) {
                        Text("График платежей")
                            .fontWeight(.semibold)
                        
                        Text(paymentViewModel.calculationTotalExpenses(general: false))
                            .font(.caption2)
                        
                        Picker("", selection: $paymentViewModel.currentTab) {
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationTitle(title)
            
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: paymentViewModel.currentTab) { newValue in
                switch newValue {
                case .Week:
                    paymentViewModel.loadWeeksExpenses()
                case .Month:
                    paymentViewModel.loadMonthExpenses()
                case .Quarter:
                    paymentViewModel.loadQuarterExpenses()
                case .All:
                    paymentViewModel.loadAllExpenses()
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
            paymentViewModel.loadWeeksExpenses()
        }
        .toolbarRole(.editor)
    }
    
    @ViewBuilder
    func AnimatedCharts() -> some View {
        let max = paymentViewModel.actExpense.max { item1, item2 in
            return item2.value > item1.value
        }?.value ?? 0
        
        Chart {
            ForEach(paymentViewModel.actExpense) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Values", item.animate ? item.value : 0)
                )
                .foregroundStyle(Color.red.gradient.opacity(0.5))
                
                PointMark(
                    x: .value("Date", item.date),
                    y: .value("Values", item.animate ? item.value : 0)
                )
                .foregroundStyle(Color.brown.gradient)
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let item = value.as(String.self) {
                        Text(item)
                            .font(paymentViewModel.getActuallyFontXAxis(paymentViewModel.currentTab))
                    }
                }
                AxisGridLine(centered: true, stroke: .none)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading,
                      values: .automatic(minimumStride: 50, desiredCount: 6))
        }
        .chartYScale(domain: 0...(paymentViewModel.getUpperBoundRange(max)))
        .frame(height: 320)
        .onAppear {
            animateGraph()
        }
    }
    
    func animateGraph(fromChange: Bool = false) {
        for (index, _) in paymentViewModel.actExpense.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * (fromChange ? 0.01 : 0.03)) {
                withAnimation(fromChange ? .easeInOut(duration: 0.5) : .interactiveSpring(response: 0.8, dampingFraction: 0.8, blendDuration: 0.5)) {
                    paymentViewModel.actExpense[index].animate = true
                }
            }
        }
    }
}
