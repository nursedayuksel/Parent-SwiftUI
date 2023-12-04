//
//  EduSocialCourses.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.09.2023.
//

import Foundation

struct EduSocialPosts: Decodable, Hashable {
    var postIdx: String
    var teacherIdx: String
    var teacherPhoto: String
    var teacherName: String
    var message: String
    var attachments: String
    var postDate: String
    var postTime: String
    var imagesArray: [String]
    var messageGroup: String
    var title: String
    var subject: String
}
