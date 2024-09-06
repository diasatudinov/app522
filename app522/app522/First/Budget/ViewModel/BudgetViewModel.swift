//
//  BudgetViewModel.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import SwiftUI

class BudgetViewModel: ObservableObject {

    @Published var currency: Currency = .usd {
        didSet {
            saveCurrency()
        }
    }
    
    @Published var incomes: [Income] = [] {
        didSet {
            saveIncome()
        }
    }
    
    @Published var expenditures: [Income] = [] {
        didSet {
            saveExpenditure()
        }
    }
    
    
    @Published var categories: [Category] = [
        Category(name: "All")
    ] {
        didSet {
            saveCategory()
        }
    }
    
    private let currencyFileName = "currency.json"
    private let incomesFileName = "incomes.json"
    private let expendituresFileName = "expenditures.json"
    private let categoriesFileName = "categories.json"
    
    init() {
        loadCurrency()
        loadIncome()
        loadExpenditure()
        loadCategory()
    }
    
    func sumIncomes() -> Double {
        var sum = 0.0
        for income in incomes {
            sum += income.amount
        }
        
        return sum
    }
    
    func sumExpenditures() -> Double {
        var sum = 0.0
        for expenditure in expenditures {
            sum += expenditure.amount
        }
        
        return sum
    }
    
    func addCategory(_ category: Category) {
        categories.append(category)
    }
    
    func deleteCategory(for category: Category) {
        if let index = categories.firstIndex(where: { $0.id == category.id }) {
            categories.remove(at: index)
        }
    }
    
    func addIncome(_ income: Income) {
        incomes.append(income)
    }
    
    func addExpenditure(_ expenditure: Income) {
        expenditures.append(expenditure)
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
    
    func currencyRow(currencyInfo: (Currency, String, String, String)) -> some View {
        let (currency, flagImage, code, name) = currencyInfo
        
        return HStack(spacing: 4) {
            Image(flagImage)
            Text(code)
                .font(.system(size: 16, weight: .semibold))
            Image(systemName: "chevron.down")
                .font(.system(size: 20, weight: .semibold))
        }.foregroundColor(.black)
        
    }
//    func addCurrency(_ procedure: Procedure) {
//        procedures.append(procedure)
//    }
//    
//    
//    func updateProcedure(for procedure: Procedure, name: String, price: String, time: String, notes: String) {
//        
//        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
//            procedures[index].name = name
//            procedures[index].price = price
//            procedures[index].time = time
//            procedures[index].notes = notes
//            
//        }
//    }
//    
//    func deleteProcedure(for procedure: Procedure) {
//        if let index = procedures.firstIndex(where: { $0.id == procedure.id }) {
//            procedures.remove(at: index)
//        }
//    }
//    
//    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    private func categoriesFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(categoriesFileName)
    }
    
    private func saveCategory() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(self.categories)
                try data.write(to: self.categoriesFilePath())
            } catch {
                print("Failed to save players: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadCategory() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: categoriesFilePath())
            categories = try decoder.decode([Category].self, from: data)
        } catch {
            print("Failed to load players: \(error.localizedDescription)")
        }
    }
    
    private func currencyFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(currencyFileName)
    }
    
    
    
    private func loadCurrency() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: currencyFilePath())
            currency = try decoder.decode(Currency.self, from: data)
        } catch {
            print("Failed to load players: \(error.localizedDescription)")
        }
    }
    
    private func incomesFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(incomesFileName)
    }
    
    private func saveCurrency() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(self.currency)
                try data.write(to: self.currencyFilePath())
            } catch {
                print("Failed to save players: \(error.localizedDescription)")
            }
        }
    }
    
    private func saveIncome() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(self.incomes)
                try data.write(to: self.incomesFilePath())
            } catch {
                print("Failed to save players: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadIncome() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: incomesFilePath())
            incomes = try decoder.decode([Income].self, from: data)
        } catch {
            print("Failed to load players: \(error.localizedDescription)")
        }
    }
    
    private func expendituresFilePath() -> URL {
        return getDocumentsDirectory().appendingPathComponent(expendituresFileName)
    }
    
    private func saveExpenditure() {
        DispatchQueue.global().async {
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(self.expenditures)
                try data.write(to: self.expendituresFilePath())
            } catch {
                print("Failed to save players: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadExpenditure() {
        let decoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: expendituresFilePath())
            expenditures = try decoder.decode([Income].self, from: data)
        } catch {
            print("Failed to load players: \(error.localizedDescription)")
        }
    }
    
}
