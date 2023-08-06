//
//  IncomeView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 11.04.2023.
//

import SwiftUI

struct IncomeView: View {
    
    @EnvironmentObject var incomeViewModel: IncomeViewModel
    @FocusState var isFocusTextField: Bool
    
    var body: some View {
            VStack {
                HeaderView(allIncomes: incomeViewModel.sumIncomes)
                    .padding(.horizontal)
                
                Spacer()
                
                List {
                    ForEach(incomeViewModel.incomes) { item in
                        HStack {
                            Text("\(item.value)")
                            Spacer()
                            Text(item.dateString)
                        }
                    }
                    .onDelete(perform: incomeViewModel.deleteRow)
                }
                .listStyle(.plain)
                .padding([.trailing], 10)
                .scrollDismissesKeyboard(.immediately)
                
                VStack {
                    if incomeViewModel.isShowTextField {
                        TextField("Сумма дохода", text: $incomeViewModel.textField)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .focused($isFocusTextField)
                            .onChange(of: incomeViewModel.textField) { _ in
                                incomeViewModel.buttonAvailabilityCheck()
                            }
                        DatePicker("Когда был получен:", selection: $incomeViewModel.datePicker, displayedComponents: [.date])
                            .animation(.default, value: incomeViewModel.isShowTextField)
                            .padding([.leading, .trailing])
                            .id(incomeViewModel.calendarId)
                            .onChange(of: incomeViewModel.datePicker) { _ in
                                incomeViewModel.calendarId = UUID()
                            }
                    }
                    
                    Button {
                        isFocusTextField.toggle()
                        incomeViewModel.buttonPressed()
                    } label: {
                        Text("Добавить доход")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
                    }
                    .opacity(incomeViewModel.buttonIsActive ? 1 : 0.6)
                    .disabled(incomeViewModel.buttonIsActive == false)
                    .padding()
                }

            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Не добавлять") {
                        isFocusTextField = false
                        incomeViewModel.isShowTextField = false
                        incomeViewModel.textField = ""
                        incomeViewModel.datePicker = .now
                        incomeViewModel.buttonIsActive = true
                    }
                }
            }
    }
    
}
