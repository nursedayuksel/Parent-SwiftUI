//
//  Books.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation

struct Books: Decodable, Hashable {
    var bookName: String
    var date: String
    var pages: String
    var stars: String
    var description: String
    var targetMonth: String
    var targetSession: String
    var test: String
    var sheet: String
    var project: String
    var drawing: String
}
