//
//  SingleHomework.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation

struct SingleHomework: Decodable, Hashable {
    var homework: String
    var name: String
    var type: String
    var size: String
    var teacherName: String
    var teacherFiles: String
    var schoolIdx: String
    var files: Int
    var classroomLink: String
}
