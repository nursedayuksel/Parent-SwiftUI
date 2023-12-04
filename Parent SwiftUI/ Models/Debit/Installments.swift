//
//  Installments.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation

struct Installments: Decodable, Hashable {
    var period: String
    var instIdx: String
    var instNumber: String
    var amount: String
    var remaining: String
    var checkBox: String
    var debitIdx: String
    var allPaid: String
    var remainingFormatted: String
}
