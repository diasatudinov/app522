//
//  NewBalanceUIView.swift
//  app522
//
//  Created by Dias Atudinov on 09.09.2024.
//

import SwiftUI

struct NewBalanceUIView: View {
    @ObservedObject var viewModel: MonetizationViewModel
    @State private var balance = ""
    @State private var showAlert = false
    @Binding var openSheet: Bool
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                Text("Balance")
                    .font(.system(size: 22, weight: .bold))
                
                TextField("Balance", text: $balance)
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
                    Button("Cancel") {
                        openSheet = false
                    }
                    .foregroundColor(.black)
                    .padding()
                    .padding(.horizontal, 38)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.main, lineWidth: 2))
                    
                    Button("Add") {
                        if !balance.isEmpty {
                            if let balance = Double(balance) {
                                viewModel.addBalance(balance)
                                openSheet = false
                            }
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    .padding(.horizontal, 45)
                    .background(Color.main.opacity(balance.isEmpty ? 0.5 : 1))
                    .cornerRadius(20)
                }
            }.padding().padding(.vertical, 6)
                
        }.background(Color.white).cornerRadius(20).padding(.horizontal)
    }
}


#Preview {
    NewBalanceUIView(viewModel: MonetizationViewModel(), openSheet: .constant(true))
}
