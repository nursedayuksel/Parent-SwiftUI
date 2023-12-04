//
//  MeetingCheck.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 02.05.2023.
//

import Foundation

struct MeetingCheck: Decodable, Hashable {
    var teacherIdx: String
    var doIHaveMeetingIdx: String
    var time: String
    var hour: String
    var minute: String
}
