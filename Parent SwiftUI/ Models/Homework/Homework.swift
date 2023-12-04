//
//  Homework.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation

struct Homework: Decodable, Hashable, Identifiable {
    var id = UUID()
    var startDate: String
    var endDate: String
    var diff: String
    var teacherName: String
    var courseName: String
    var short: String
    var value: String
    var homeworkIdx: String
    var attachment: String
}
