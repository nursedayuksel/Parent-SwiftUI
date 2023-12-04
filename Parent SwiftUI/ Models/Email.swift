//
//  Email.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation

struct Email: Decodable, Hashable, Identifiable {
    var id = UUID()
    var idx: String
    var subject: String
    var message: String
    var create_date: String
    var date_for_display: String
    var attachments: String
    var name: String
    var surname: String
    var senderPhoto: String
    var emailUserIdx: String
}
