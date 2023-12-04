//
//  AttendanceViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//


import Foundation
import Alamofire
import SwiftUI

class AttendanceViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var attendanceList: [AttendanceList] = []
    @Published var attendanceSemesters: [AttendanceSemesters] = []
    
    private var attendanceListArray: NSArray = []
    private var attendanceSemesterArray: NSArray = []
    
    var attendanceValueArray: [String] = []
    var attendanceShortArray: [String] = []
    var uniqueAttendanceValueArray: [String] = []
    var uniqueAttendanceShortArray: [String] = []
    var attendanceSemestersArray: [String] = []
    
    var currentSelectedSemesterIdx = ""
    var currentSelectedSemesterName = ""
    
    @Published var selectedSemesterIndex = 0
    
    var attendanceValueColorsArray: [Color] = [.red, .green, .blue, .blue, .purple, .gray]
    var attendanceValueColorsDict: [String: Color] = [:]
    
    func getAttendanceSemesters() {
        self.resetBadge(table: "course_attendance", studentIdx: studentIdx)
        let parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_SEMESTERS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.attendanceSemesterArray = dict.value(forKey: "data") as! NSArray
                
                self.attendanceSemesters = []
                self.attendanceSemestersArray = []
                
                if error == 0 {
                    for obj in self.attendanceSemesterArray {
                        let singleSemester = obj as! NSDictionary
                        
                        let semesterIdx = singleSemester.value(forKey: "idx") as? String ?? ""
                        let termName = singleSemester.value(forKey: "term_name") as? String ?? ""
                        let isSelected = singleSemester.value(forKey: "selected") as? Int ?? 0
                        
                        let oneSemester = AttendanceSemesters(semesterIdx: semesterIdx, termName: termName, isSelected: isSelected)
                        
                        self.attendanceSemesters.append(oneSemester)
                        self.attendanceSemestersArray.append(termName)
                        
                        if isSelected == 1 {
                            self.currentSelectedSemesterIdx = semesterIdx
                            self.currentSelectedSemesterName = termName
                        }
                    }
                    
                    for i in 0..<self.attendanceSemesters.count {
                        if self.attendanceSemesters[i].isSelected == 1 {
                            self.selectedSemesterIndex = i
                        }
                    }
                    print(self.currentSelectedSemesterIdx)
                    self.getAttendanceList(semester_idx: self.currentSelectedSemesterIdx)
                    
                }
            case . failure(let error):
                print(error)
            }
        }
    }
    
    func getAttendanceList(semester_idx: String) {
        let parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "semester_idx": semester_idx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_ATTENDANCES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                
                self.attendanceList = []
                self.attendanceValueArray = []
                self.attendanceShortArray = []
                
                if error == 0 {
                    self.attendanceListArray = dict.value(forKey: "data") as! NSArray
                    for obj in self.attendanceListArray {
                        let singleAttendance = obj as! NSDictionary
                        
                        let attendanceIdx = singleAttendance.value(forKey: "idx") as? String ?? ""
                        let attendanceDate = singleAttendance.value(forKey: "date") as? String ?? ""
                        let attendanceValue = singleAttendance.value(forKey: "value") as? String ?? ""
                        let attendanceCourse = singleAttendance.value(forKey: "course") as? String ?? ""
                        let activity = singleAttendance.value(forKey: "activity") as? String ?? ""
                        let attendanceHours = singleAttendance.value(forKey: "hours") as? String ?? ""
                        let attendanceShort = singleAttendance.value(forKey: "short") as? String ?? ""
                        
                        let oneAttendance = AttendanceList(attendanceIdx: attendanceIdx, attendanceDate: attendanceDate, attendanceValue: attendanceValue, attendanceCourse: attendanceCourse, activity: activity, attendanceHours: attendanceHours, attendanceShort: attendanceShort)
                        
                        self.attendanceList.append(oneAttendance)
                        
                        self.attendanceValueArray.append(attendanceValue)
                        self.uniqueAttendanceValueArray = self.attendanceValueArray.removeDuplicates()
                        
                        self.attendanceShortArray.append(attendanceShort)
                        self.uniqueAttendanceShortArray = self.attendanceShortArray.removeDuplicates()
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func attendanceValueColors(valueName: String) -> Color {
        if valueName == "Excused" {
            return .green
        } else if valueName == "Absent" {
            return .red
        } else {
            return .blue
        }
    }
    
    func attendanceValueColors(index: Int) -> Color {
        attendanceValueColorsDict["\(uniqueAttendanceValueArray[index])"] = attendanceValueColorsArray[index % attendanceValueColorsArray.count]
        
        return attendanceValueColorsDict["\(uniqueAttendanceValueArray[index])"] ?? .clear
    }
    
    func attendanceValueColor(short: String) -> Color {
        switch short {
        case "A":
            return .red
            
        case "T":
            return .blue
            
        case "L":
            return .blue
            
        case "E":
            return .green
            
        case "U":
            return .purple
            
        default:
            return .gray
        }
    }
    
    
    func filterAttendanceList(valueName: String) -> [AttendanceList] {
        return attendanceList.filter{$0.attendanceValue == valueName}
    }
}
