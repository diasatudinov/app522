//
//  CurrencyUIView.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI

enum Currency: Codable {
    case usd, eur, jpy, chf, turk, kzt, gbp, thb
}

let currencies: [(Currency, String, String, String)] = [
    (.usd, "usdFlag", "USD", "US dollar"),
    (.eur, "eurFlag", "EUR", "Euro"),
    (.jpy, "jpyFlag", "JPY", "Japanese yen"),
    (.chf, "chfFlag", "CHF", "Swiss franc"),
    (.turk, "tryFlag", "TRY", "Turkish lira"),
    (.kzt, "kztFlag", "KZT", "Kazakhstani tenge"),
    (.gbp, "gbpFlag", "GBP", "Pound sterling"),
    (.thb, "thbFlag", "THB", "Thai baht")
]

struct CurrencyUIView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var currency: Currency
    @State var selectedCurrency: Currency = .usd
    
    
    var body: some View {
        VStack {
            VStack(spacing: 28) {
                ForEach(currencies, id: \.0) { currencyInfo in
                    currencyRow(currencyInfo: currencyInfo)
                }
            }.padding(.horizontal, 20)
            
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
                    currency = selectedCurrency
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.white)
                .padding()
                .padding(.horizontal, 50)
                .background(Color.main)
                .cornerRadius(20)
            }
        }
        .navigationTitle("Currency")
        .padding(.horizontal)
        .onAppear {
            selectedCurrency = currency
        }
    }
    
    func currencyRow(currencyInfo: (Currency, String, String, String)) -> some View {
        let (currency, flagImage, code, name) = currencyInfo
        
        return HStack {
            Image(flagImage)
            VStack(alignment: .leading, spacing: 4) {
                Text(code)
                    .font(.system(size: 15, weight: .semibold))
                Text(name)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.gray.opacity(0.7))
            }
            Spacer()
            HStack {
                Text(currencySymbol(for: currency))
                Image(selectedCurrency == currency ? "selected" : "unselected")
            }
        }
        .onTapGesture {
            selectedCurrency = currency
        }
    }
    
    func currencySymbol(for currency: Currency) -> String {
        switch currency {
        case .usd: return "$"
        case .eur: return "€"
        case .jpy: return "¥"
        case .chf: return "₣"
        case .turk: return "₺"
        case .kzt: return "₸"
        case .gbp: return "£"
        case .thb: return "฿"
        }
    }
}

#Preview {
    CurrencyUIView(currency: .constant(.usd))
}
