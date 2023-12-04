//
//  IndividualTeacherView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualTeacherView: View {
    var teacher: Teacher
    
    @ObservedObject var messagingViewModel: MessagingViewModel

    var body: some View {
        HStack(spacing: 10) {
            if messagingViewModel.messageCounterTeachersArray.contains(teacher.teacherIdx) && messagingViewModel.messageNotifsDict != [:] && messagingViewModel.messageIsTeacherDict[teacher.teacherIdx] == teacher.isTeacher {
                WebImage(url: URL(string: teacher.teacherPhoto))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
                    .overlay(
                        Text("\(messagingViewModel.messageNotifsDict[teacher.teacherIdx] ?? "")")
                            .padding(8)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .background(.red)
                            .clipShape(Circle())
                            .offset(x: -30, y: -30)
                    )
            } else {
                WebImage(url: URL(string: teacher.teacherPhoto))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 70, height: 70)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("\(teacher.teacherName)")
                        .bold()
                        .foregroundColor(.black)
                    Spacer()
                    Text("\(teacher.lastMessageDate)")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                }
                
                Text("\(teacher.subject)")
                .bold()
                .foregroundColor(.gray)
                .font(.system(size: 14))
                
                Text("\(teacher.lastMessage)")
                    .foregroundColor(.gray)
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(8)
    }
}
