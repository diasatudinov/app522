//
//  MonetizationUIView.swift
//  app522
//
//  Created by Dias Atudinov on 09.09.2024.
//

import SwiftUI

enum MonetizationTab {
    case inProcess, received
}



struct MonetizationUIView: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @State private var selectedTab: MonetizationTab = .inProcess
    @State private var newIncomeSheet: Bool = false
    @State private var editIncomeSheet: Bool = false
    @State private var newExpenditureSheet: Bool = false
    @State private var newBalanceSheet: Bool = false
    @State private var newCategory: Bool = false
    @State private var selectedCategory: Category?
    @State  private var percentage1: Double = 70.0
    private var percentage: Double {
        let total = viewModel.sumIncomes() + viewModel.sumExpenditures()
        
        if total == 0 {
            return 0
        }
        
        return (viewModel.sumExpenditures() * 100.0) / total
    }
    
    var filteredIncomes: [Income] {
        if let category = selectedCategory{
            if category.name == "All"  {
                return viewModel.incomes
            } else {
                return viewModel.incomes.filter { $0.category == category }
            }
        } else {
            return viewModel.incomes
        }
    }
    
    var filteredExpenditures: [Income] {
        if let category = selectedCategory, category.name != "All" {
            
            if category.name == "All"  {
                return viewModel.expenditures
            } else {
                return viewModel.expenditures.filter { $0.category == category }
            }
            
        } else {
            return viewModel.expenditures
        }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Monetization")
                            .font(.system(size: 34, weight: .bold))
                        NavigationLink {
                            CurrencyUIView(currency: $viewModel.currency)
                        } label: {
                            ForEach(currencies, id: \.0) { currencyInfo in
                                if viewModel.currencySymbol(for: currencyInfo.0) == viewModel.currencySymbol(for: viewModel.currency) {
                                    viewModel.currencyRow(currencyInfo: currencyInfo)
                                }
                            }
                            
                        }
                    }
                    
                    Spacer()
                }
                
                ZStack {
                    Rectangle()
                        .cornerRadius(32)
                        .foregroundColor(.main)
                    Image("graph")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 32, height: 182)
                    VStack {
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("\(viewModel.currencySymbol(for: viewModel.currency))\(String(format: "%.2f", viewModel.balance))")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Budget goal")
                                
                            }.foregroundColor(.white)
                            
                            Spacer()
                            Button {
                                
                                newBalanceSheet = true
                                
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }.padding(20)
                        
                        ZStack {
                            Rectangle()
                                .cornerRadius(16)
                                .foregroundColor(.gray.opacity(0.3))
                                .padding(.horizontal, 20)
                            HStack(spacing: 10) {
                                CircleDiagramMonetizationView(percentage: percentage)
                                VStack(alignment: .leading, spacing: 3) {
                                    Text("\(viewModel.currencySymbol(for: viewModel.currency))\(String(format: "%.2f", viewModel.sumExpenditures()))")
                                        .font(.system(size: 17, weight: .bold))
                                    Text("Budget now")
                                    
                                }.foregroundColor(.white)
                                Spacer()
                            }.padding(.horizontal, 32)
                        }.frame(height: 70).padding(.bottom, 20)
                        
                    }
                }.frame(height: 182)
                
                Picker("Select a tab", selection: $selectedTab) {
                    Text("In process").tag(MonetizationTab.inProcess)
                    Text("Received").tag(MonetizationTab.received)
                }.frame(height: 46).pickerStyle(SegmentedPickerStyle())
                    .scaleEffect(CGSize(width: 1.1, height: 1.4))
                    .padding(.horizontal)
                    .onAppear {
                        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
                        let titleTextAttributesSelected = [NSAttributedString.Key.foregroundColor: UIColor.black]
                        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
                        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
                        
                    }
                
                HStack {
                    Text("History")
                        .font(.system(size: 28, weight: .bold))
                    Spacer()
                    Button {
                        newIncomeSheet = true
                        
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                    }
                }
                
                HStack {
                    Button {
                        newCategory = true
                    } label : {
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
                                    .onAppear {
                                        if category.name == "All" {
                                            selectedCategory = category
                                        }
                                    }
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                            }
                        }
                    }
                    
                }
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color.grayBg).cornerRadius(32)
                    if selectedTab == .inProcess {
                        if viewModel.incomes.isEmpty {
                            Text("There are no records")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 90)
                        } else {
                            ScrollView {
                                
                                ForEach(filteredIncomes, id: \.self) { income in
                                    BudgetCellUIView(income: income, symbol: viewModel.currencySymbol(for: viewModel.currency))
                                        .padding(.horizontal)//.padding(.top,8)
                                        .contextMenu {
                                            Button(action: {
                                                editIncomeSheet = true
                                            }) {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            Button(action: {
                                                viewModel.deleteIncome(for: income)
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .sheet(isPresented: $editIncomeSheet) {
                                            if selectedTab == .received {
                                                EditRecordView(viewModel: viewModel, income: income, isRecieved: true)
                                            } else {
                                                EditRecordView(viewModel: viewModel, income: income, isRecieved: false)
                                            }
                                            
                                        }
                                }
                                
                                
                            }.padding(.bottom, 30)
                        }
                    } else {
                        if viewModel.expenditures.isEmpty {
                            Text("There are no records")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 90)
                        } else {
                            ScrollView {
                                
                                ForEach(filteredExpenditures, id: \.self) { income in
                                    BudgetCellUIView(income: income, symbol: viewModel.currencySymbol(for: viewModel.currency))
                                        .padding(.horizontal)//.padding(.top,8)
                                        .contextMenu {
                                            Button(action: {
                                                // Edit action
                                                editIncomeSheet = true
                                            }) {
                                                Label("Edit", systemImage: "pencil")
                                            }
                                            Button(action: {
                                                viewModel.deleteExpenditure(for: income)
                                            }) {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        }
                                        .sheet(isPresented: $editIncomeSheet) {
                                            if selectedTab == .received {
                                                EditRecordView(viewModel: viewModel, income: income, isRecieved: true)
                                            } else {
                                                EditRecordView(viewModel: viewModel, income: income, isRecieved: false)
                                            }
                                            
                                        }
                                }
                                
                                
                            }.padding(.bottom, 30)
                        }
                    }
                   
                }
                
                
                Spacer()
            }.padding(.horizontal)
            
            if newCategory {
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.5)).ignoresSafeArea()
                    MonetizationCategoryUIView(viewModel: viewModel, openSheet: $newCategory)
                }
            }
            
            if newBalanceSheet {
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.5)).ignoresSafeArea()
                    NewBalanceUIView(viewModel: viewModel, openSheet: $newBalanceSheet)
                }
            }
            
            
        }.sheet(isPresented: $newIncomeSheet) {
            AddRecordUIView(viewModel: viewModel)
        }
    }
}

#Preview {
    MonetizationUIView(viewModel: MonetizationViewModel())
}

struct CircleDiagramMonetizationView: View {
    var percentage: Double // percentage to display
    
    var body: some View {
        ZStack {
            // Background circle (the "hole")
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 5)
                .frame(width: 50, height: 50)
            
            // Foreground circle (the percentage)
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage / 100))
                .stroke(Color.white, lineWidth: 5)
                .rotationEffect(.degrees(90)) // Starts the trim at the top
                .frame(width: 50, height: 50)
            
            // Text in the center showing the percentage
            Text("\(Int(percentage))%")
                .font(.system(size: 11))
                .foregroundColor(.white)
        }
    }
}
