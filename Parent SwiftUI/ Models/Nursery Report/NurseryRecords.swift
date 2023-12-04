//
//  NurseryRecords.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation

struct NurseryRecords: Decodable, Hashable {
    var categoryName: String
    var comment: String
    var month: String
    var score: String
    var subCategoryName: String
}
