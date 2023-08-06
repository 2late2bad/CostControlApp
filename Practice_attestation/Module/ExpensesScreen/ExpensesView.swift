//
//  ExpensesView.swift
//  Practice_attestation
//
//  Created by Alexander Vagin on 11.04.2023.
//

import SwiftUI

struct ExpensesView: View {
    
    @EnvironmentObject var expenseViewModel: ExpensesViewModel
    @EnvironmentObject var general: GeneralEnvironment
    @FocusState var isFocusTextField: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Расходы")
                    .font(.title)
                    .bold()
                    .padding()
                
                Spacer(minLength: 20)
                
                List {
                    ForEach(expenseViewModel.categories) { item in
                        ZStack {
                            NavigationLink(destination: DetailExpensesView(vM: expenseViewModel, broadcastID: item.id)) {
                                EmptyView()
                            }
                            HStack {
                                Text(item.name)
                                    .font(.headline)
                                    .frame(height: 40)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 7)
                                    .foregroundColor(.blue)
                            }
                        }
                        .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: expenseViewModel.deleteRowCategory)
                    .onMove(perform: expenseViewModel.moveRowCategory)
                }
                .listStyle(.plain)
                .padding([.trailing], 10)
                .scrollDismissesKeyboard(.immediately)
                
                VStack {
                    if expenseViewModel.categoryIsShowTextField {
                        TextField("Наименование категории", text: $expenseViewModel.categoryTextField)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .focused($isFocusTextField)
                            .onChange(of: expenseViewModel.categoryTextField) { _ in
                                expenseViewModel.buttonCategoryAvailabilityCheck()
                            }
                    }
                    
                    Button {
                        isFocusTextField.toggle()
                        expenseViewModel.categoryButtonPressed()
                    } label: {
                        Text("Добавить категорию расходов")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 55)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(20)
                            .shadow(color: Color.blue.opacity(0.3), radius: 10, x: 0.0, y: 10)
                    }
                    .opacity(expenseViewModel.categoryButtonIsActive ? 1 : 0.6)
                    .disabled(expenseViewModel.categoryButtonIsActive == false)
                    .padding()
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Не добавлять") {
                        isFocusTextField = false
                        expenseViewModel.categoryIsShowTextField = false
                        expenseViewModel.categoryTextField = ""
                        expenseViewModel.categoryButtonIsActive = true
                    }
                }
            }
        }
        .onAppear {
            general.allExpensesValue = expenseViewModel.sumExpenses
        }
    }
}

struct ExpensesView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesView()
    }
}
