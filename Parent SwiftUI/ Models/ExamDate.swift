//
//  ExamDate.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation

struct ExamDate: Decodable, Hashable {
    var courseName: String
    var examDate: String
    var teacherName: String
    var examDescription: String
}
