//
//  Teacher.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import Foundation

struct Teacher: Decodable, Hashable {
    var teacherName: String
    var teacherPhoto: String
    var teacherIdx: String
    var subject: String
    var link: String
    var lastMessage: String
    var lastMessageDate: String
    var isTeacher: String
}
