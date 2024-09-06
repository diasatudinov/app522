//
//  AddIncomeUIView.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI

struct AddIncomeView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @Environment(\.presentationMode) var presentationMode
    @State var selectedTab: Tab
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedCategory: Category?
    @State private var newCategory: Bool = false
    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Rectangle()
                    .frame(width: 36, height: 5)
                    .cornerRadius(2)
                    .opacity(0.3)
                    .padding(.vertical, 5)
                
                Text("Record")
                    .font(.system(size: 22, weight: .bold))
                
                Picker("Select a tab", selection: $selectedTab) {
                    Text("Income").tag(Tab.income)
                    Text("Expenditure").tag(Tab.expenditure)
                }.frame(height: 46).pickerStyle(SegmentedPickerStyle())
                    .scaleEffect(CGSize(width: 1.1, height: 1.4))
                    .padding(.horizontal)
                    .onAppear {
                        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
                        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
                        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
                        
                    }
                    .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                
                TextField("Name", text: $name)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                HStack {
                    ForEach(currencies, id: \.0) { currencyInfo in
                        if viewModel.currencySymbol(for: currencyInfo.0) == viewModel.currencySymbol(for: viewModel.currency) {
                            viewModel.currencyRow(currencyInfo: currencyInfo)
                        }
                    }
                    Spacer()
                }
                HStack {
                    Button {
                        newCategory = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.black)
                            .font(.system(size: 20, weight: .semibold))
                            .padding(10)
                            .padding(.horizontal, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.main, lineWidth: 2)
                            )
                            .opacity(0.5)
                    }
                    ScrollView(.horizontal) {
                        
                        HStack {
                            ForEach(viewModel.categories, id: \.self) { category in
                                if category.name != "All" {
                                    Text(category.name)
                                        .font(.system(size: 16))
                                        .padding(10)
                                        .padding(.horizontal, 8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.main, lineWidth: 2)
                                        )
                                        .padding(2)
                                        .opacity(selectedCategory == category ? 1 : 0.5)
                                        .onTapGesture {
                                            selectedCategory = category
                                        }
                                }
                            }
                        }
                    }
                }
                
                TextField("Sum", text: $amount)
                    .keyboardType(.numberPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                Spacer()
                HStack {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.black)
                    .padding()
                    .padding(.horizontal, 42)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.main, lineWidth: 2))
                    
                    Button("Save") {
                        if selectedTab == .income {
                            if let category = selectedCategory,
                               let amount = Double(amount), !name.isEmpty {
                                let newIncome = Income(name: name, amount: amount, category: category)
                                viewModel.addIncome(newIncome)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            if let category = selectedCategory,
                               let amount = Double(amount), !name.isEmpty {
                                let newExpenditure = Income(name: name, amount: amount, category: category)
                                viewModel.addExpenditure(newExpenditure)
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 50)
                    .background(Color.main)
                    .cornerRadius(20)
                }
            }.padding(.horizontal)
            
            if newCategory {
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.5)).ignoresSafeArea()
                    CategoryUIView(viewModel: viewModel, openSheet: $newCategory)
                }
            }
        }
    }
}

#Preview {
    AddIncomeView(viewModel: BudgetViewModel(), selectedTab: .income)
}

