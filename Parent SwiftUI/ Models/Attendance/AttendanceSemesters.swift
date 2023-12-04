//
//  AttendanceSemesters.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import Foundation

struct AttendanceSemesters: Decodable, Hashable {
    var semesterIdx: String
    var termName: String
    var isSelected: Int
}
