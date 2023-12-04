//
//  IndividualParentMeetingTeachersView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 02.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualParentMeetingTeachersView: View {
    var teacher: MeetingTeacher
    
  //  @State var index: Int
   // @Binding var meetingIsBooked: Bool
    
    @ObservedObject var meetingViewModel: ParentMeetingViewModel
    
    @State var openBookMeetingSheet = false
    @State var showCancelMeetingAlert = false
    
    @State var selectedSubjectName = ""
    @State var selectedTeacherName = ""
    
    var body: some View {
        if meetingViewModel.meetingCheck.count > 0 {
            HStack {
                WebImage(url: URL(string: teacher.photo))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("MyEduCare"), lineWidth: 1))
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(teacher.teacher)
                        .bold()
                        .foregroundColor(.black)
                    Text(teacher.subject)
                        .foregroundColor(.gray)
                        .lineLimit(1)
                    Text(teacher.meetingBooked ? "\(teacher.meetingTimeDate)" : "NO MEETING WITH YOU")
                        .foregroundColor(.gray)
                    
                    Button(action: {
                        if teacher.meetingBooked {
                            openBookMeetingSheet = false
                            showCancelMeetingAlert = true
                           // meetingViewModel.isCancelLoading = true
                        } else {
                            openBookMeetingSheet = true
                            selectedSubjectName = teacher.subject
                            selectedTeacherName = teacher.teacher
                            showCancelMeetingAlert = false
                        }
                        
                        meetingViewModel.getTeacherMeetingTimes(meetingIdx: meetingViewModel.selectedMeetingIdx, teacherIdx: teacher.teacherIdx)
                    }) {
                        Text(teacher.meetingBooked ? "CANCEL MEETING" : "BOOK A MEETING")
                            .padding(3)
                            .frame(maxWidth: .infinity)
                            .background(teacher.meetingBooked ? Color.red : Color("MyEduCare"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $openBookMeetingSheet) {
                        BookMeetingSheetView(meetingViewModel: meetingViewModel, selectedSubjectName: $selectedSubjectName, selectedTeacherName: $selectedTeacherName, teacherIdx: teacher.teacherIdx, showBookMeetingSheet: $openBookMeetingSheet)
                    }
                    .alert(isPresented: $showCancelMeetingAlert) {
                        switch meetingViewModel.activeCancelMeetingAlert {
                        case .success:
                            return Alert(title: Text("Warning!"), message: Text("Are you sure you want to cancel your meeting?"), primaryButton: .destructive(Text("YES")) {
                                meetingViewModel.isCancelLoading = true
                                meetingViewModel.cancelMeeting(teacherIdx: teacher.teacherIdx)
                            }, secondaryButton: .default(Text("NO")))
                            
                        case .failure:
                            return Alert(title: Text("Error!"), message: Text(meetingViewModel.meetingBookedErrorMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                }
                
                if teacher.link != "" {
                    
                }
            }
            .padding(8)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 1)
            .padding([.leading, .trailing], 10)
        }
    }
}

