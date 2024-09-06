//
//  BudgetUIView.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI


enum Tab {
    case income,expenditure
}

struct BudgetUIView: View {
    @ObservedObject var viewModel: BudgetViewModel
    @State private var selectedTab: Tab = .income
    @State private var newIncomeSheet: Bool = false
    @State private var newExpenditureSheet: Bool = false
    @State private var newCategory: Bool = false
    @State private var selectedCategory: Category?
    
    private var percentage: Double {
        return (viewModel.sumIncomes() * 100.0)/(viewModel.sumIncomes() + viewModel.sumExpenditures())
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
                HStack(spacing: 15) {
                    ZStack {
                        VStack {
                            Text("Budget")
                                .font(.system(size: 28, weight: .bold))
                            CircleDiagramView(percentage: percentage)
                                .padding()
                        }
                    }.padding(10).padding(.vertical, 5).background(Color.grayBg).cornerRadius(20)
                    
                    VStack(spacing: 20) {
                        NavigationLink {
                            CurrencyUIView(currency: $viewModel.currency)
                        } label: {
                            ForEach(currencies, id: \.0) { currencyInfo in
                                if viewModel.currencySymbol(for: currencyInfo.0) == viewModel.currencySymbol(for: viewModel.currency) {
                                    viewModel.currencyRow(currencyInfo: currencyInfo)
                                }
                            }
                            
                        }
                        ZStack {
                            VStack(alignment: .leading) {
                                Text("\(viewModel.currencySymbol(for: viewModel.currency))\(String(format: "%.2f", viewModel.sumIncomes()))")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Income")
                                    .foregroundColor(.gray.opacity(0.7))
                            }.frame(maxWidth: .infinity).padding(10).padding(.vertical, 14)
                            
                        }.background(Color.grayBg).cornerRadius(20)
                        
                        ZStack {
                            VStack(alignment: .leading) {
                                Text("\(viewModel.currencySymbol(for: viewModel.currency))\(String(format: "%.2f", viewModel.sumExpenditures()))")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Expenditure")
                                    .foregroundColor(.gray.opacity(0.7))
                            }.frame(maxWidth: .infinity).padding(10).padding(.vertical, 14)
                            
                        }.background(Color.grayBg).cornerRadius(20)
                    }
                    
                    
                }
                
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
                    if viewModel.incomes.isEmpty {
                        Text("There are no records")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 90)
                    } else {
                        ScrollView {
                            if selectedTab == .income {
                                ForEach(filteredIncomes, id: \.self) { income in
                                    BudgetCellUIView(income: income, symbol: viewModel.currencySymbol(for: viewModel.currency))
                                        .padding(.horizontal)//.padding(.top,8)
                                }
                            } else {
                                ForEach(filteredExpenditures, id: \.self) { income in
                                    BudgetCellUIView(income: income, symbol: viewModel.currencySymbol(for: viewModel.currency))
                                        .padding(.horizontal)//.padding(.top,8)
                                }
                                
                            }
                        }.padding(.bottom, 30)
                    }
                   
                }
                
                Spacer()
                
            }.padding(.horizontal)
            
            if newCategory {
                ZStack {
                    Rectangle()
                        .foregroundColor(.black.opacity(0.5)).ignoresSafeArea()
                    CategoryUIView(viewModel: viewModel, openSheet: $newCategory)
                }
            }
            
        }.sheet(isPresented: $newIncomeSheet) {
            AddIncomeView(viewModel: viewModel, selectedTab: selectedTab)
        }
    }
    
}

#Preview {
    BudgetUIView(viewModel: BudgetViewModel())
}

struct CircleDiagramView: View {
    var percentage: Double // percentage to display
    
    var body: some View {
        ZStack {
            // Background circle (the "hole")
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 30)
                .frame(width: 150, height: 150)
            
            // Foreground circle (the percentage)
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage / 100))
                .stroke(Color.main, lineWidth: 30)
                .rotationEffect(.degrees(90)) // Starts the trim at the top
                .frame(width: 150, height: 150)
            
            // Text in the center showing the percentage
            Text("\(Int(percentage))%")
                .font(.system(size: 22, weight: .bold))
        }
    }
}

