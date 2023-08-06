//
//  DetailExpensesView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 12.04.2023.
//

import SwiftUI

struct DetailExpensesView: View {
    
    @ObservedObject var vM: ExpensesViewModel
    @EnvironmentObject var general: GeneralEnvironment
    @FocusState var isFocusTextField: Bool
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let broadcastID: UUID

    var body: some View {
            VStack {
                NavigationLink {
                    PaymentScheduleView(title: vM.getCategory(for: broadcastID)?.name ?? "Без категории",
                                        paymentViewModel: PaymentScheduleViewModel(expenses: vM.getCategory(for: broadcastID)?.expenses ?? []))
                } label: {
                    Text("График платежей")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(20)
                        .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Group {
                        Text("На что")
                            .padding([.leading], 50)
                        Spacer()
                        Text("Когда")
                            .padding([.trailing], 40)
                        Text("Сколько")
                            .padding([.trailing], 20)
                    }
                    .font(.headline)
                }
                .padding([.leading, .trailing], 20)
                
                Divider()
                
                if let category = vM.getCategory(for: broadcastID) {
                    List {
                        ForEach(category.expenses) { item in
                            HStack(alignment: .center) {
                                Divider()
                                Text("\(item.name)")
                                    .frame(width: 165, alignment: .leading)
                                    .font(.callout)
                                Divider()
                                Text(item.dateString)
                                    .frame(width: 75)
                                    .fontWeight(.light)
                                Divider()
                                Text("\(item.value) Р")
                                    .frame(width: 115, alignment: .leading)
                                    .fontDesign(.serif)
                                Divider()
                            }
                        }
                        .onDelete { indexSet in
                            vM.deleteRowExpense(at: indexSet, uuid: broadcastID)
                            general.allExpensesValue = vM.sumExpenses
                        }
                    }
                    .listStyle(.plain)
                    .padding([.top], -8)
                    .scrollDismissesKeyboard(.immediately)
                }
                
                Spacer()
                
                VStack {
                    if vM.expensesIsShowFields {
                        TextField("Что приобретено", text: $vM.expensesNameTextField)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .focused($isFocusTextField)
                            .onChange(of: vM.expensesNameTextField) { _ in
                                vM.buttonExpensesAvailabilityCheck()
                            }
                        TextField("Стоимость покупки", text: $vM.expensesValueTextField)
                            .keyboardType(.numberPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .onChange(of: vM.expensesValueTextField) { _ in
                                vM.buttonExpensesAvailabilityCheck()
                            }
                        DatePicker("Когда приобретено:", selection: $vM.datePicker, displayedComponents: [.date])
                            .padding([.leading, .trailing])
                            .id(vM.calendarId)
                            .onChange(of: vM.datePicker) { _ in
                                vM.calendarId = UUID()
                            }
                    }
                    
                    Button {
                        isFocusTextField.toggle()
                        vM.expensesButtonPressed(uuid: broadcastID)
                        general.allExpensesValue = vM.sumExpenses
                    } label: {
                        if vM.expensesIsShowFields {
                            Text("Добавить расход")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 55)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(80)
                                .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
                        } else {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                        }
                    }
                    .opacity(vM.expensesButtonIsActive ? 1 : 0.6)
                    .disabled(vM.expensesButtonIsActive == false)
                    .padding()
                }
                .padding()
                
                
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Не добавлять") {
                        isFocusTextField = false
                        vM.expensesIsShowFields = false
                        vM.expensesNameTextField = ""
                        vM.expensesValueTextField = ""
                        vM.datePicker = .now
                        vM.expensesButtonIsActive = true
                    }
                }
            }
        .navigationTitle(vM.getCategory(for: broadcastID)?.name ?? "NO DATA")
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrowshape.backward")
        })
        .onAppear {
            general.allExpensesValue = vM.sumExpenses
        }
    }
}

