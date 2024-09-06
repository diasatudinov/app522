//
//  Income.swift
//  app522
//
//  Created by Dias Atudinov on 06.09.2024.
//

import Foundation

struct Income: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var amount: Double
    var category: Category
}

struct Category: Identifiable, Hashable,Equatable, Codable {
    var id = UUID()
    var name: String
}
