//
//  IndividualTimeTableLessonView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import SwiftUI

struct IndividualTimeTableLessonView: View {
    var timetable: [TimeTable]
    
    @ObservedObject var timetableViewModel: TimetableViewModel

    var body: some View {
        VStack {
            if timetable.count > 0 {
                ForEach(timetable, id: \.self) { lesson in
                    HStack(spacing: 15) {
                        VStack(spacing: 10) {
                            Text("\(lesson.startTime)")
                                .bold()
                            Text("\(lesson.endTime)")
                                .bold()
                            
                        }
                        .font(.system(size: 15))
                        .padding(.leading, 10)
                        .frame(width: 60)
                        .foregroundColor(.gray)
                        
                        Rectangle()
                            .fill(Color("MyEduCare"))
                            .frame(width: 1, height: nil, alignment: .trailing)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Text("\(lesson.subject)")
                                    .bold()
                                    .foregroundColor(.black)
                                Spacer()
                                if lesson.lessonOrder == "" {
                                    Text("(Club)")
                                        .foregroundColor(.gray)
                                        .offset(x: 20, y: -7)
                                }
                                
                            }
                            if lesson.roomName == "" {
                                Text("NO ROOM")
                                    .foregroundColor(.gray)
                            } else {
                                Text("\(lesson.roomName)")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text("\(lesson.teacher)")
                                .foregroundColor(.gray)
                        }
                        .padding([.top, .bottom], 10)
                        
                        Spacer()
                    }
                    .background(lesson.lessonOrder == "" ? Color("ClubColor") : Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 1)
                    .padding([.leading, .trailing], 10)
                }
            }
        }
    }
}
