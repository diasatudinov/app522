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
    @State private var percentage: Double = 75 // Adjust the percentage here
    @State private var selectedTab: Tab = .income
    @State private var selectedCurrency: Currency = .usd
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
                        
                        HStack(spacing: 4) {
                            Image("usdFlag")
                            Text("USD")
                                .font(.system(size: 16, weight: .semibold))
                            Image(systemName: "chevron.down")
                                .font(.system(size: 20, weight: .semibold))
                        }
                        
                        ZStack {
                            VStack(alignment: .leading) {
                                Text("$20 543.50")
                                    .font(.system(size: 22, weight: .bold))
                                Text("Income")
                                    .foregroundColor(.gray.opacity(0.7))
                            }.frame(maxWidth: .infinity).padding(10).padding(.vertical, 14)
                            
                        }.background(Color.grayBg).cornerRadius(20)
                        
                        ZStack {
                            VStack(alignment: .leading) {
                                Text("$10 543.50")
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
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                }
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(10)
                        .padding(.horizontal, 8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.main, lineWidth: 2)
                        )
                    ScrollView(.horizontal) {
                        Text("All")
                            .font(.system(size: 16))
                            .padding(10)
                            .padding(.horizontal, 8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.main, lineWidth: 2)
                            )
                            .padding(2)
                    }
                    
                }
                
                ZStack {
                        Text("There are no records")
                        .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 90)
                   
                }.background(Color.grayBg).cornerRadius(32)
                
                Spacer()
                
            }.padding(.horizontal)
        }
    }
}

#Preview {
    BudgetUIView()
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

