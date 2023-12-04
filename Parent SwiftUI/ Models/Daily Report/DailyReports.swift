//
//  DailyReports.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation

struct DailyReports: Decodable, Hashable, Identifiable {
    var id = UUID()
    var dailyReportIdx: String
    var attachment: String
    var createDate: String
    var dateForDisplay: String
    var message: String
    var subject: String
    var html: String
}
