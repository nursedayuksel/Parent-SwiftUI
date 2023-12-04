//
//  TimetableViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class TimetableViewModel: ObservableObject {
    let defaults = UserDefaults.standard

    @Published var timeTable: [TimeTable] = []
    @Published var timeTableLessons: [String : [TimeTable]] = [:]
    
    var timetableArray: NSArray = []
    var timetableClubsArray: NSArray = []
    
    @Published var dayNumbers: [String] = []
    
    var thisFridayDateString = ""
    
    @Published var arrayDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    let arrayDaysShort = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
    
    let weekdayNumbersToGetCurrentDay: NSDictionary = ["Monday" : 0, "Tuesday" : 1, "Wednesday" : 2, "Thursday" : 3, "Friday" : 4, "Saturday" : 5, "Sunday" : 6]
    
    let weekdayNumbers: NSDictionary = ["0" : "Monday", "1": "Tuesday", "2" : "Wednesday", "3" : "Thursday", "4" : "Friday", "5" : "Saturday", "6" : "Sunday"]
    
    let weekdayNumbersToGetCurrentDayRomanian: NSDictionary = ["luni" : 0, "marţi" : 1, "miercuri" : 2, "joi" : 3, "vineri" : 4, "sâmbătă" : 5, "sâmbătă" : 6]
    let weekdayNumbersToGetCurrentDayRussian: NSDictionary = ["понедельник" : 0, "вторник" : 1, "среда" : 2, "Четверг" : 3, "Пятница" : 4, "суббота" : 5, "суббота" : 6]
    
    let date = Date()
    let calendar = Calendar.current
    var weekday = -1
    
    var allLessonCount: [Int] = []
    
    @Published var currentDayIndex = 0
    var previousDayIndex: [Int] = []
    
    @Published var holidayName = ""
    
    @Published var weekdayNumbersArray: [String] = []
    @Published var saturdayNoLessons: Bool = false
    @Published var saturdayTeachersArray: [String] = []
    
    func loadTimeTable() {
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_TIMETABLE, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    var dayNumbersArr: [String] = []
                    self.timeTable = []
                    self.timeTableLessons = [:]
                    
                    let dataDictionary = dict.value(forKey: "data") as! NSDictionary
                    
                    var oldDay = "Monday"
                    for day in self.arrayDays {
                        
                        let daysDictionary = dataDictionary.value(forKey: "\(day)") as! NSDictionary
                        
                        self.timetableArray = daysDictionary.value(forKey: "lessons") as! NSArray
                        self.timetableClubsArray = daysDictionary.value(forKey: "clubs") as! NSArray
                        
                        for lesson in self.timetableArray {
                            let singleLesson = lesson as! NSDictionary
                            
                            let subject = singleLesson.value(forKey: "subject") as? String ?? ""
                            let teacher = singleLesson.value(forKey: "teacher") as? String ?? ""
                            let link = singleLesson.value(forKey: "link") as? String ?? ""
                            let startTime = singleLesson.value(forKey: "start_time") as? String ?? ""
                            let endTime = singleLesson.value(forKey: "end_time") as? String ?? ""
                            let date = singleLesson.value(forKey: "date") as? String ?? ""
                            let lessonOrder = singleLesson.value(forKey: "lesson_order") as? String ?? ""
                            let dayStr = singleLesson.value(forKey: "day_str") as? String ?? ""
                            let roomName = singleLesson.value(forKey: "room") as? String ?? "NO ROOM"
                            
                            if (oldDay != day) {
                                self.timeTable = []
                                oldDay = day
                            }
                            
                            if day == "Saturday" {
                                self.saturdayTeachersArray.append(teacher)
                                self.saturdayNoLessons = self.saturdayTeachersArray.allSatisfy({$0 == ""})
                            }
                            
                            if teacher != "Holiday" {
                                self.holidayName = ""
                            } else {
                                self.holidayName = subject
                            }
                            
                            let oneLesson = TimeTable(subject: subject, teacher: teacher, link: link, startTime: startTime, endTime: endTime, date: date, lessonOrder: lessonOrder, dayStr: dayStr, roomName: roomName)
                            self.timeTable.append(oneLesson)
                            self.timeTableLessons[day] = self.timeTable
                            
                            dayNumbersArr.append(dayStr)
                            self.dayNumbers = NSOrderedSet(array: dayNumbersArr).array as! [String]
                            
                           // print(self.dayNumbers)
                        }
                        
                        for club in self.timetableClubsArray {
                            let singleClub = club as! NSDictionary
                            
                            let subject = singleClub.value(forKey: "name") as? String ?? ""
                            let teacher = singleClub.value(forKey: "teacher") as? String ?? ""
                            let link = singleClub.value(forKey: "link") as? String ?? ""
                            let startTime = singleClub.value(forKey: "start_time") as? String ?? ""
                            let endTime = singleClub.value(forKey: "end_time") as? String ?? ""
                            let date = singleClub.value(forKey: "date") as? String ?? ""
                            let dayStr = singleClub.value(forKey: "date") as? String ?? ""
                            let roomName = singleClub.value(forKey: "room") as? String ?? "NO ROOM"
                            
                            if (oldDay != day) {
                                self.timeTable = []
                                oldDay = day
                            }
                            
                            let oneClub = TimeTable(subject: subject, teacher: teacher, link: link, startTime: startTime, endTime: endTime, date: date, lessonOrder: "", dayStr: dayStr, roomName: roomName)
                            self.timeTable.append(oneClub)
                            self.timeTableLessons[day] = self.timeTable
                        }
                        
                        self.timeTableLessons["Sunday"] = []
                    }
                    
                    self.weekday = self.calendar.component(.weekday, from: self.date)
                    
                    if self.timeTable.count > 0 {
                        self.thisFridayDateString = self.timeTable[self.timeTable.count-1].date
                        
                        var dayComponent    = DateComponents()
                        dayComponent.day    = 1 // For removing one day (yesterday): -1
                        let theCalendar     = Calendar.current
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyyMMdd"
                        
                        if self.thisFridayDateString != "" {
                            let date = dateFormatter.date(from: self.thisFridayDateString)
                            dayComponent.day = 1 // For removing one day (yesterday): -1
                            let nextDate1 = theCalendar.date(byAdding: dayComponent, to: date!)
                            let sundayDay = theCalendar.component(.day, from: nextDate1!)
                            if sundayDay < 10 {
                                self.dayNumbers.insert("0" + String(sundayDay), at: 6)
                            } else {
                                self.dayNumbers.insert(String(sundayDay), at: 6)
                            }
                        }
                        
                        for i in 0...6 {
                            print(i)
                            // showing days in timetable
                            let date = Date().daysOfWeek(using: self.calendar)
                            let components = date[i].get(.day, .month, .year)
                            if let day = components.day {
                                self.weekdayNumbersArray.insert(String(day), at: i)
                            }
                        }
                    }
                    
                    self.currentDayIndex = self.weekdayNumbersToGetCurrentDay[DateFormatter().weekdaySymbols[Calendar.current.component(.weekday, from: Date()) - 1]] as! Int
                    print(self.currentDayIndex)
                    
                    print(self.timeTableLessons)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setSubjectImage(subject: String) -> Image
    {
        var imageName = ((randomImages as NSArray).shuffled())[0]
        for i in 0...lessonImages.count - 1
        {
            if (subject.lowercased()).contains((lessonImages[i] as! NSArray)[0] as! String)
            {
                imageName = (lessonImages[i] as! NSArray)[1] as! String
                break
            }
        }
        return Image("\(imageName as! String)")
    }
}
