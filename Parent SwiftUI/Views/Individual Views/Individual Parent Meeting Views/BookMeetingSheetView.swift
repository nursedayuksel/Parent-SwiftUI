//
//  BookMeetingSheetView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 03.05.2023.
//

import SwiftUI

struct BookMeetingSheetView: View {
    @ObservedObject var meetingViewModel: ParentMeetingViewModel
    
    @Binding var selectedSubjectName: String
    @Binding var selectedTeacherName: String
    
    @State var teacherIdx: String
    
    @State var showBookMeetingAlert = false
    @Binding var showBookMeetingSheet: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text(selectedTeacherName)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(10)
            .background(Color.white)
            
            VStack(spacing: 8) {
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    Text(selectedSubjectName)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    Spacer()
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                    Text(meetingViewModel.selectedDateText)
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    
                    Spacer()
                }
            }
            .padding(10)
            
            if meetingViewModel.meetingDays.count > 0 {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15){
                        ForEach(meetingViewModel.meetingTimes, id: \.self) { time in
                            VStack(spacing: 15) {
                                if time.displayTime.contains("Pause") {
                                    Text(time.displayTime)
                                        .foregroundColor(.gray)
                                        .font(.system(size: 15))
                                } else if time.displayTime.contains("(You already have a meeting)") {
                                    Text("\(time.displayTime)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 15))
                                } else {
                                    Button(action: {
                                        showBookMeetingAlert = true
                                        meetingViewModel.bookMeeting(startTime: time.startTimeInt, teacherIdx: teacherIdx)
                                    }) {
                                        Text(time.displayTime)
                                            .bold()
                                            .foregroundColor(.black)
                                            .font(.system(size: 15))
                                    }
                                    .alert(isPresented: $showBookMeetingAlert) {
                                        switch meetingViewModel.activeBookMeetingAlert {
                                        case .success:
                                            return Alert(title: Text("Success!"), message: Text("Your meeting has been booked"), dismissButton: .default(Text("OK")) {
                                                showBookMeetingSheet = false
                                            })
                                            
                                        case .failure:
                                            return Alert(title: Text("Error!"), message: Text(meetingViewModel.meetingBookedErrorMessage), dismissButton: .default(Text("OK")) {
                                                showBookMeetingSheet = false
                                            })
                                        }
                                    }
                                }
                                
                                Divider()
                            }
                        }
                    }
                    .padding(10)
                    .padding(.top, 10)
                }
                .background(.white)
                .cornerRadius(15)
            } else {
                CustomEmptyDataView(noDataText: "No meeting times available")
            }
        }
        .background(Color("Background").edgesIgnoringSafeArea(.bottom))
    }
}
