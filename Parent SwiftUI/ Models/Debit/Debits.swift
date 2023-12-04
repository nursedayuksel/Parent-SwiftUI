//
//  Debits.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation

struct Debits: Decodable, Hashable {
    var name: String
    var debitIdx: String
    var totalAmount: String
    var finalAmount: String
    var discount: String
    var currency: String
    var url: String
    var schoolName: String
    var onlinePaypass: String
    var onlinePayUser: String
    var remaining: String
}
