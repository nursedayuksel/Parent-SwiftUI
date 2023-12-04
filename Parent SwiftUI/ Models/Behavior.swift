//
//  Behavior.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import Foundation

struct Behavior: Decodable, Hashable {
    var behaviorIdx: String
    var type: String
    var behaviorName: String
    var point: String
    var behaviorIcon: String
    var subject: String
    var courseIdx: String
}
