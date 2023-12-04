//
//  Grades.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import Foundation

struct Grades: Decodable, Hashable {
    var courseIdx: String
    var comments: String
    var subject: String
    var teacherName: String
    var gradeDate: String
    var typeOfGrading: String
    var percentage: String
    var gradingWeightValueName: String
    var gradeValue: String
    var color: String
}
