//
//  AppointmentViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 25.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

struct WeekDay: Decodable, Hashable {
    var dayName: String
    var dayDate: String
    var realDate: String
    var weekIndex: Int
    var weekday: String
}

enum ActiveBookAppointmentAlert {
    case success, failure
}

let daysArray: [String] = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]

class AppointmentViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var teacherAppointment: [TeacherAppointment] = []
    @Published var availableHours: [AvailableHours] = []
    
    @Published var teacherIdsArray: [String] = []
    @Published var weekdaysArray: [String] = []
    @Published var startTimeArray: [String] = []
    @Published var finishTimeArray: [String] = []
    @Published var intervalArray: [String] = []
    @Published var locationArray: [String] = []
    
    @Published var weeksToDisplayArray: [WeekDay] = []
    @Published var realDateArray: [String] = []
    
    var isCancelLoading = false
    
    private var teacherAppointmentArray: NSArray = []
    private var availableHoursArray: NSArray = []
    
    @Published var selectedTeacherIndex = -1
    
    @Published var dateClicked = true
    
    @Published var selectedDate = ""
    
    @Published var showBookingAlert = false
    
    @Published var activeAlert: ActiveBookAppointmentAlert = .success
    @Published var errorMessage = ""
    
    @Published var teacherUnavailableHours: [String] = []

    @Published var selectedDateBookingArray: [String] = []
    
    @Published var appointmentWeekdayLocationDict: [String: String] = [:]
    
    func getTeacherList() {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db" : defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        //print(parameters)
        
        AF.request(URL_TEACHER_LIST_APPOINTMENT, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.teacherAppointment = []
                    self.teacherIdsArray = []
                    self.appointmentWeekdayLocationDict = [:]
                    
                    self.teacherAppointmentArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.teacherAppointmentArray {
                        let singleTeacher = obj as! NSDictionary
                        
                        let teacherIdx = singleTeacher.value(forKey: "teacher_idx") as? String ?? ""
                        let teacherName = singleTeacher.value(forKey: "teacher_name") as? String ?? ""
                        let photo = singleTeacher.value(forKey: "photo") as? String ?? ""
                        let startTime = singleTeacher.value(forKey: "start_time") as? String ?? ""
                        let endTime = singleTeacher.value(forKey: "finish_time") as? String ?? ""
                        let interval = singleTeacher.value(forKey: "interval") as? String ?? ""
                        let link = singleTeacher.value(forKey: "link") as? String ?? ""
                        let weekday = singleTeacher.value(forKey: "weekday") as? String ?? ""
                        let location = singleTeacher.value(forKey: "location") as? String ?? ""
                        
                        //print(teacherName)
                        //print(weekday)
                        
                        if self.weekdaysArray != [] {
                            self.weekdaysArray = []
                        }
                        
                        self.weekdaysArray.append(weekday)
                        self.teacherIdsArray.append(teacherIdx)
                        self.startTimeArray.append(startTime)
                        self.finishTimeArray.append(endTime)
                        self.intervalArray.append(interval)
                        self.locationArray.append(location)
                        
                        self.appointmentWeekdayLocationDict[weekday] = location
                        
                        
                        let appointedTimeAndDate = singleTeacher.value(forKey: "appointed_time_and_date") as! NSDictionary
                        
                        let appointedTime = appointedTimeAndDate.value(forKey: "time") as? String ?? ""
                        let appointedDate = appointedTimeAndDate.value(forKey: "date") as? String ?? ""
                        let appointedFormattedDate = appointedTimeAndDate.value(forKey: "formatted_date") as? String ?? ""
                        let isOnline = appointedTimeAndDate.value(forKey: "is_online") as? String ?? ""
                        let appointedLocation = appointedTimeAndDate.value(forKey: "location") as? String ?? ""
                        let displayTime = appointedFormattedDate + " | " + appointedTime
                        
                        var oneTeacher = TeacherAppointment(teacherIdx: teacherIdx, teacherName: teacherName, photo: photo, hasAppointment: false, weekdays: self.weekdaysArray, appTimeDate: displayTime, startTimes: self.startTimeArray, finishTimes: self.finishTimeArray, intervals: self.intervalArray, appointedLocation: appointedLocation, locations: self.locationArray, location: location, link: link, isOnline: isOnline, appDate: appointedDate, appTime: appointedTime)
                        
                        if displayTime != " | "
                        {
                            oneTeacher.setAppointmentStatus(status: true)
                        }
                        if self.teacherAppointment.count == 0
                        {
                            self.teacherAppointment.append(oneTeacher)
                        } else {
                            var found = false
                            var teacherIndex = -1
                            for teacher in self.teacherAppointment
                            {
                                teacherIndex = teacherIndex + 1
                                if teacher.retTeacherIdx() == oneTeacher.retTeacherIdx()
                                {
                                    found = true
                                }
                                
                            }
                            if found {
                                found = false
                                if oneTeacher.hasAppointment
                                {
                                    //print(oneTeacher)
                                    self.teacherAppointment[teacherIndex].setAppointmentStatus(status: true)
                                }
                                self.teacherAppointment[teacherIndex].appendWeekday(weekday: weekday)
                                //print(self.teacherAppointment)
                                self.teacherAppointment[teacherIndex].appendStartTime(startTime: startTime)
                                self.teacherAppointment[teacherIndex].appendFinsihTime(finishTime: endTime)
                                self.teacherAppointment[teacherIndex].appendInterval(interval: interval)
                                self.teacherAppointment[teacherIndex].appendLocation(location: location)
                            } else {
                                self.teacherAppointment.append(oneTeacher)
                            }
                            teacherIndex = -1
                            self.weekdaysArray = []
                            self.startTimeArray = []
                            self.finishTimeArray = []
                            self.intervalArray = []
                            self.locationArray = []
                        }
                    }
                    
                   print(self.teacherAppointment)
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func cancelAppointment(date: String, hour: String, teacherIdx: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "teacher_idx": teacherIdx,
            "date": date,
            "hour": hour,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_CANCEL_APPOINTMENT, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.isCancelLoading = true
                    self.getTeacherList()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func bookAppointment(date: String, hour: String, teacherIdx: String, isOnline: String, location: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "teacher_idx": teacherIdx,
            "date": date,
            "hour": hour,
            "is_online": isOnline,
            "location": location,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_BOOK_APPOINTMENT, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.activeAlert = .success
                    print("success")
                    self.getTeacherList()
                } else {
                    self.activeAlert = .failure
                    self.errorMessage = dict.value(forKey: "message") as? String ?? ""
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTeacherTimesForDate(date: String, teacherIdx: String) {
        let parameters: Parameters = [
            "school_group" : defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "date": date,
            "teacher_idx": teacherIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_APPOINTMENTS_OF_TEACHER, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.teacherUnavailableHours = []
                    let hours = dict.value(forKey: "hours") as? [String] ?? []
                    
                    for hour in hours {
                        let hourFinal = hour.dropLast(3)
                        self.teacherUnavailableHours.append(String(hourFinal))
                    }
                }
                
                //print(self.teacherUnavailableHours)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTeacherAvailableHours(teacherIdx: String, weekday: String) {
        let parameters: Parameters = [
            "school_group" : defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "weekday": weekday,
            "teacher_idx": teacherIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
       // print(parameters)
        
        AF.request(URL_GET_TEACHER_AVAILABLE_HOURS_APPOINTMENT, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.availableHours = []
                    
                    self.availableHoursArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.availableHoursArray {
                        let singleHour = obj as! NSDictionary
                        
                        let meetingDisplay = singleHour.value(forKey: "meetingDisplay") as? String ?? ""
                        let startTime = singleHour.value(forKey: "start_time") as? String ?? ""
                        
                        let oneHour = AvailableHours(meetingDisplay: meetingDisplay, startTime: startTime)
                        self.availableHours.append(oneHour)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func appointmentIcon(index: Int) -> String {
        if self.teacherAppointment[index].appTimeDate == " | " {
            
            return "info.circle"
        } else {
            return "clock"
        }
    }
    
    func appointmentTitle(index: Int) -> String {
        if self.teacherAppointment[index].appTimeDate == " | " {
            return "No appointment with you"
        } else {
            return self.teacherAppointment[index].appTimeDate
        }
    }
    
    func appointmentLocation(index: Int) -> String {
        if self.teacherAppointment[index].appointedLocation == "" {
            return ""
        } else {
            return self.teacherAppointment[index].appointedLocation
        }
    }
    
    func appointButtonTitle(index: Int) -> String {
        //print(self.teacherAppointment[index].appointmentStatus())
        if self.teacherAppointment[index].appTimeDate == " | "  {
            return "Get an appointment"
        } else {
            return "Cancel appointment"
        }
    }
    
    func appointButtonColor(index: Int) -> Color {
        if self.teacherAppointment[index].appTimeDate == " | " {
            return Color("MyEduCare")
        } else {
            return .red
        }
    }
    
    func dateBackgroundColor(clicked: Bool) -> Color {
        if clicked {
            return Color("MyEduCare")
        } else {
            return .white
        }
    }
    
    func dateForegroundColor(clicked: Bool) -> Color {
        if clicked {
            return .white
        } else {
            return .gray
        }
    }
    
    func getWeekday() -> Int {
        let myCalendar = Calendar(identifier: .gregorian)
        let date = Date()
        let weekDay = myCalendar.component(.weekday, from: date)
        return weekDay
    }
    
    func getTodayDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        let date = Date()
        dateFormatter.dateFormat = "dd-MM-YYYY"
        return  dateFormatter.string(from: date)
    }
    
    func dayDifference(teacherWeekday : Int, todayWeekday:Int) -> Int {
        return teacherWeekday - todayWeekday - 1
    }
    
    func generateDate(index: Int, date: String, diff: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date_ = dateFormatter.date(from:date)!
        var daysToAdd = diff + 7 * index + 2
        var dateComponent = DateComponents()
        dateComponent.day = daysToAdd
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: date_)
        return dateFormatter.string(from: futureDate!)
    }
    
    func getTeacherDates(index: Int) {
        self.weeksToDisplayArray = []
        
        if teacherAppointment[index].appTimeDate == " | " {
            selectedTeacherIndex = index
            
            let weekday = getWeekday() // int starting from Sunday as 1
            let todayDate = getTodayDate() // string in dd-MM-yyyy format
            if teacherAppointment[selectedTeacherIndex].weekdays.count > 0
            {
                for i in 0...3
                {
                    for j in 0...teacherAppointment[selectedTeacherIndex].weekdays.count - 1
                    {
                        // print(teacherAppointment[selectedTeacherIndex].weekdays)
                        let difference = dayDifference(teacherWeekday: Int(teacherAppointment[selectedTeacherIndex].weekdays[j])!, todayWeekday: weekday)
                        let dayNameIndex: Int = weekday + difference
                        let dayName = daysArray[dayNameIndex]
                        let _date = generateDate(index: i, date: todayDate, diff: difference)
                        print("index: \(i)")
                        print("todayDate: \(todayDate)")
                        print("weekday: \(weekday)")
                        print("teacherWeekday: \( Int(teacherAppointment[selectedTeacherIndex].weekdays[j])!)")
                        print("difference: \(difference)")
                        print("dayNameIndex: \(dayNameIndex)")
                        print("dayName: \(dayName)")
                        print("_date: \(_date)")
                        let my_temp_arr = _date.components(separatedBy: "-")
                        let realDate = my_temp_arr[2] + my_temp_arr[1] + my_temp_arr[0]
                        self.selectedDateBookingArray.append(realDate)
                        // print(self.selectedDateBookingArray)
                        let singleWeekDay = WeekDay(dayName: dayName, dayDate: my_temp_arr[0] + "/" + my_temp_arr[1], realDate: realDate, weekIndex: j, weekday: teacherAppointment[selectedTeacherIndex].weekdays[j])
                        self.weeksToDisplayArray.append(singleWeekDay)
                        self.realDateArray.append(realDate)
                    }
                }
            }
        }
       // print(self.weeksToDisplayArray)
       // print("teacher appointment")
      //  print(self.teacherAppointment)
    }
}
