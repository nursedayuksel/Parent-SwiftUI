//
//  MeetingDays.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 02.05.2023.
//

import Foundation

struct MeetingDays: Decodable, Hashable {
    var date: String
    var week: String
    var weekDisplay: String
    var meetingName: String
    var schoolIdx: String
    var meetingIdx: String
    var dateFormatted: String
}
