//
//  AddRecordUIView.swift
//  app522
//
//  Created by Dias Atudinov on 09.09.2024.
//

import SwiftUI

struct AddRecordUIView: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedCategory: Category?
    @State private var newCategory: Bool = false
    @State private var isRecieved: Bool = false
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
                
                HStack(spacing: 8) {
                    Toggle("", isOn: $isRecieved)
                        .labelsHidden()
                    Text("Received")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
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
                    
                    Button("Add") {
                        if !isRecieved {
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
                    MonetizationCategoryUIView(viewModel: viewModel, openSheet: $newCategory)
                }
            }
        }
    }
}

#Preview {
    AddRecordUIView(viewModel: MonetizationViewModel())
}

#Preview {
    EditRecordView(viewModel: MonetizationViewModel(), income: Income(name: "AAAAA", amount: 1234, category: Category(name: "ASDASDAD")), isRecieved: true)
}

struct EditRecordView: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @State var income: Income
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var amount = ""
    @State private var selectedCategory: Category?
    @State private var newCategory: Bool = false
    @State var isRecieved: Bool
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
                
                HStack(spacing: 8) {
                    Toggle("", isOn: $isRecieved)
                        .labelsHidden()
                    Text("Received")
                        .font(.system(size: 16, weight: .semibold))
                    Spacer()
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
                        if !isRecieved {
                            if let category = selectedCategory,
                               let amount = Double(amount), !name.isEmpty {
                                viewModel.updateIncome(for: income, name: name, amount: amount, category: category)
                                presentationMode.wrappedValue.dismiss()
                            }
                        } else {
                            if let category = selectedCategory,
                               let amount = Double(amount), !name.isEmpty {
                                viewModel.updateExpenditure(for: income, name: name, amount: amount, category: category)
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
                .onAppear {
                    name = income.name
                    amount = "\(income.amount)"
                    selectedCategory = income.category
                }
            
            if newCategory {
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.5)).ignoresSafeArea()
                    MonetizationCategoryUIView(viewModel: viewModel, openSheet: $newCategory)
                }
            }
        }
    }
}
