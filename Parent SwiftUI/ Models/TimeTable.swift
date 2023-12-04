///Users/sedatozkul/Documents/iOS Apps/Parent SwiftUI/Parent SwiftUI/ Models/TimeTable.swift
//  TimeTable.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import Foundation

struct TimeTable: Decodable, Hashable {
    var subject: String
    var teacher: String
    var link: String
    var startTime: String
    var endTime: String
    var date: String
    var lessonOrder: String
    var dayStr: String
    var roomName: String
}
