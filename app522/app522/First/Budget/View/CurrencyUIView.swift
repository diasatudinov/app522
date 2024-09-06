//
//  CurrencyUIView.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI

enum Currency {
    case usd, eur, jpy, chf, turk, kzt, gbp, thb
}

struct CurrencyUIView: View {
    @Binding var currency: Currency
    @State var selectedCurrency: Currency = .usd
    var body: some View {
        VStack {
            Spacer()
            
            
        }
        .onAppear {
            selectedCurrency = currency
        }
    }
}

#Preview {
    CurrencyUIView(currency: .constant(.usd))
}
