//
//  AttendanceList.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import Foundation

struct AttendanceList: Decodable, Hashable {
    var attendanceIdx: String
    var attendanceDate: String
    var attendanceValue: String
    var attendanceCourse: String
    var activity: String
    var attendanceHours: String
    var attendanceShort: String
}
