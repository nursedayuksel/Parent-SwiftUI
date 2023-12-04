//
//  DailySummary.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import Foundation

struct DailySummary: Decodable, Hashable {
    var category: String
    var value: String
    var image: String
}
