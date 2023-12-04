//
//  Message.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import Foundation

struct Message: Decodable, Hashable, Identifiable {
    var id = UUID()
    var date: String
    var dateDisplay: String
    var messageIdx: String
    var message: String
    var receiverIdx: String
    var senderIdx: String
    var time: String
    var timeDisplay: String
    var attachment: String
    var pathExtension: String
    var fileName: String
    var softDelete: String
}
