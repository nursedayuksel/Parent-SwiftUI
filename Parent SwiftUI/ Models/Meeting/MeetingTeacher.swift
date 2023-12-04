//
//  Teacher.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 02.05.2023.
//

import Foundation

struct MeetingTeacher: Decodable, Hashable {
    var id = UUID()
    var teacher: String
    var photo: String
    var teacherIdx: String
    var subject: String
    var link: String
    var meetingBooked: Bool
    var meetingTimeDate: String
}
