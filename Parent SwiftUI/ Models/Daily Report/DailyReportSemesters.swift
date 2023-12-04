//
//  DailyReportSemesters.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation

struct DailyReportSemesters: Decodable, Hashable {
    var semesterIdx: String
    var termName: String
    var isSelected: Int
}
