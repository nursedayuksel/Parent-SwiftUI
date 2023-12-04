//
//  GDPR.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation

struct GDPR: Decodable, Hashable {
    var ruleIdx: String
    var rule: String
    var defaultOption: String
    var parentAnswer: String
}
