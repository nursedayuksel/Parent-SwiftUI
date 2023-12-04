//
//  Club.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import Foundation

struct Club: Decodable, Hashable, Identifiable {
    var id = UUID()
    var clubName: String
    var clubType: String
    var dayOfClub: String
    var feeType: String
    var clubIdx: String
    var isMyClub: Int
    var isOpen: String
    var link: String
    var clubTeacherName: String
}
