//
//  ParentMeetingViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 02.05.2023.
//

import Foundation
import Alamofire
import SwiftUI

enum ActiveBookMeetingAlert {
    case success, failure
}

enum ActiveCancelMeetingAlert {
    case success, failure
}

class ParentMeetingViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var teachers: [MeetingTeacher] = []
    @Published var meetingCheck: [MeetingCheck] = []
    @Published var meetingDays: [MeetingDays] = []
    @Published var meetingTimes: [MeetingTimes] = []
    
    private var teachersArray: NSArray = []
    private var meetingCheckArray: NSArray = []
    private var meetingDaysArray: NSArray = []
    private var meetingTimesArray: NSArray = []
    
    @Published var selectedDateText = ""
    @Published var selectedDate = ""
    @Published var selectedMeetingIdx = ""
    
    @Published var meetingIsBooked: [Bool] = []
    
    @Published var selectedMeetingIndex = 0
    
    @Published var meetingDatesArray: [String] = []
    @Published var meetingNamesArray: [String] = []
    
    @Published var activeBookMeetingAlert: ActiveBookMeetingAlert = .success
    @Published var activeCancelMeetingAlert: ActiveCancelMeetingAlert = .success
    
    @Published var showMeetingBookedAlert = false
    
    @Published var meetingBookedErrorMessage = ""
    @Published var meetingCancelledErrorMessage = ""
    
    @Published var isCancelLoading = false
    
    func getTeacherList() {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db" : defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "module": "parent_meeting",
            "selected_date": selectedDate,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_TEACHERS_LIST, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.teachers = []
                    
                    self.teachersArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.teachersArray {
                        let singleTeacher = obj as! NSDictionary
                        
                        let teacher = singleTeacher.value(forKey: "teacher") as? String ?? ""
                        let photo = singleTeacher.value(forKey: "photo") as? String ?? ""
                        let teacherIdx = singleTeacher.value(forKey: "teacher_idx") as? String ?? ""
                        let subject = singleTeacher.value(forKey: "subject") as? String ?? ""
                        let link = singleTeacher.value(forKey: "link") as? String ?? ""
                        
                        let oneTeacher = MeetingTeacher(teacher: teacher, photo: photo, teacherIdx: teacherIdx, subject: subject, link: link, meetingBooked: false, meetingTimeDate: "")
                        
                        self.teachers.append(oneTeacher)
                    }
                    
                    self.teacherParentMeetingTimes()
                    
                    print(self.teachers)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func teacherParentMeetingTimes() {
        var teacherIdxs = ""
        if self.teachers.count > 0 {
            for i in 0..<self.teachers.count {
                teacherIdxs = teacherIdxs + self.teachers[i].teacherIdx + ";"
            }
        }
        
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "teacher_idxs": teacherIdxs,
            "date": selectedDate,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_DO_I_HAVE_MEETING, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.meetingCheck = []
                    self.meetingIsBooked = []
                    
                    self.meetingCheckArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.meetingCheckArray {
                        let singleMeetingCheck = obj as! NSDictionary
                        
                        let teacherIdx = singleMeetingCheck.value(forKey: "teacher") as? String ?? ""
                        let doIHaveMeetingIdx = singleMeetingCheck.value(forKey: "idx") as? String ?? ""
                        let time = singleMeetingCheck.value(forKey: "time") as? String ?? ""
                        let hour = singleMeetingCheck.value(forKey: "hour") as? String ?? ""
                        let minute = singleMeetingCheck.value(forKey: "minute") as? String ?? ""
                        
                        let oneMeetingCheck = MeetingCheck(teacherIdx: teacherIdx, doIHaveMeetingIdx: doIHaveMeetingIdx, time: time, hour: hour, minute: minute)
                        
                        if teacherIdx != "" {
                            self.meetingCheck.append(oneMeetingCheck)
                            if doIHaveMeetingIdx == "-1" {
                                self.meetingIsBooked.append(false)
                            } else {
                                self.meetingIsBooked.append(true)
                            }
                        }
                    }
                    
                    if self.meetingIsBooked.count > 0 {
                        for i in 0..<self.meetingIsBooked.count {
                            print(i)
                            self.teachers[i].meetingBooked = self.meetingIsBooked[i]
                            self.teachers[i].meetingTimeDate = self.meetingCheck[i].time
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMeetingDays() {
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_MEETING_DAYS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.meetingDays = []
                    self.meetingDatesArray = []
                    self.meetingNamesArray = []
                    
                    self.meetingDaysArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.meetingDaysArray {
                        let singleMeetingDay = obj as! NSDictionary
                        
                        let date = singleMeetingDay.value(forKey: "date") as? String ?? ""
                        let week = singleMeetingDay.value(forKey: "week") as? String ?? ""
                        let weekDisplay = singleMeetingDay.value(forKey: "weekDisplay") as? String ?? ""
                        let meetingName = singleMeetingDay.value(forKey: "label") as? String ?? ""
                        let schoolIdx = singleMeetingDay.value(forKey: "school_idx") as? String ?? ""
                        let meetingIdx = singleMeetingDay.value(forKey: "meeting_idx") as? String ?? ""
                        let dateFormatted = singleMeetingDay.value(forKey: "dateFormatted") as? String ?? ""
                        
                        let oneMeetingDay = MeetingDays(date: date, week: week, weekDisplay: weekDisplay, meetingName: meetingName, schoolIdx: schoolIdx, meetingIdx: meetingIdx, dateFormatted: dateFormatted)
                        self.meetingDays.append(oneMeetingDay)
                        self.meetingDatesArray.append(dateFormatted)
                        self.meetingNamesArray.append(dateFormatted + " (" + meetingName + ")")
                    }
                    
                    if self.meetingDays.count > 0 {
                        self.selectedDateText = self.meetingDays[0].dateFormatted
                        self.selectedDate = self.meetingDays[0].date
                        self.selectedMeetingIdx = self.meetingDays[0].meetingIdx
                    }
                }
                
                self.getTeacherList()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTeacherMeetingTimes(meetingIdx: String, teacherIdx: String) {
        let parameters: Parameters = [
            "date": selectedDate,
            "teacher_idx": teacherIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "meeting_idx": meetingIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_TEACHER_MEETING_TIMES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.meetingTimes = []
                    
                    self.meetingTimesArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.meetingTimesArray {
                        let singleTime = obj as! NSDictionary
                        
                        let startTime = singleTime.value(forKey: "start_time") as? String ?? ""
                        var displayTime = singleTime.value(forKey: "meetingDisplay") as? String ?? ""
                        
                        for i in 0..<self.meetingCheck.count {
                            if self.meetingCheck[i].time == startTime && self.meetingCheck[i].doIHaveMeetingIdx != "-1" {
                                displayTime = displayTime + " (You already have a meeting)"
                            }
                        }
                        
                        let startTimeArr = startTime.components(separatedBy: ":")
                        let startTimeInt = startTimeArr[0] + startTimeArr[1]
                        
                        let oneTime = MeetingTimes(startTime: startTime, displayTime: displayTime, startTimeInt: startTimeInt)
                        self.meetingTimes.append(oneTime)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func bookMeeting(startTime: String, teacherIdx: String) {
        let parameters: Parameters = [
            "date": selectedDate,
            "time": startTime,
            "teacher_idx": teacherIdx,
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "meeting_idx": selectedMeetingIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_BOOK_MEETING, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.showMeetingBookedAlert = true
                if error == 0 {
                    self.activeBookMeetingAlert = .success
                    self.teacherParentMeetingTimes()
                } else {
                    self.activeBookMeetingAlert = .failure
                    self.meetingBookedErrorMessage = dict.value(forKey: "error_message") as? String ?? ""
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func cancelMeeting(teacherIdx: String) {
        let parameters: Parameters = [
            "date": selectedDate,
            "teacher_idx": teacherIdx,
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "meeting_idx": selectedMeetingIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_CANCEL_MEETING, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.showMeetingBookedAlert = true
                if error == 0 {
                    self.activeCancelMeetingAlert = .success
                } else {
                    self.activeCancelMeetingAlert = .failure
                    self.meetingCancelledErrorMessage = dict.value(forKey: "error_message") as? String ?? ""
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func meetingCheckColor(index: Int) -> Color {
        if self.meetingCheck[index].doIHaveMeetingIdx == "-1" {
            return Color("MyEduCare")
        } else {
            return .red
        }
    }
    
    func meetingCheckButtonText(index: Int) -> String {
        if self.meetingCheck[index].doIHaveMeetingIdx == "-1" {
            return "BOOK A MEETING"
        } else {
            return "CANCEL MEETING"
        }
    }
}
