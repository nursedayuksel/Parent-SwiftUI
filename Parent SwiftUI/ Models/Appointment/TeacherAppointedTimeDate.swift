//
//  TeacherAppointedTimeDate.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 25.04.2023.
//

import Foundation

struct TeacherAppointedTimeDate: Decodable, Hashable {
    var teacherIdx: String
    var appointedTime: String
    var appointedDate: String
    var appointedFormattedDate: String
    var isOnline: String
}
