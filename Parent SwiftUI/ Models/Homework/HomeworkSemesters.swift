//
//  HomeworkSemesters.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation

struct HomeworkSemesters: Decodable, Hashable {
    var semesterIdx: String
    var termName: String
    var isSelected: Int
}
