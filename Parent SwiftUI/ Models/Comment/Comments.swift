//
//  Comments.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation

struct Comments: Decodable, Hashable, Identifiable {
    var id = UUID()
    var commentDate: String
    var commentIdx: String
    var commentMark: String
    var categoryName: String
    var courseName: String
    var teacherFullName: String
}
