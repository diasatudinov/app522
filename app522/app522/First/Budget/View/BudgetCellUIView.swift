//
//  BudgetCellUIView.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI

struct BudgetCellUIView: View {
    @State var income: Income
    @State var symbol: String
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.main)
                .frame(height: 74)
                .cornerRadius(32)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(income.name)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    Text(income.category.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
                Spacer()
                
                Text("\(symbol)\(String(format: "%.2f", income.amount))")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
                
            }.padding(.horizontal, 20)
            
        }
    }
}

#Preview {
    BudgetCellUIView(income: Income(name: "BMW X5", amount: 200, category: Category(name: "Cars")), symbol: "$")
}
