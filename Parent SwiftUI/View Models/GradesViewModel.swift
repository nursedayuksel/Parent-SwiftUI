//
//  GradesViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class GradesViewModel: ObservableObject {
    var defaults = UserDefaults.standard
    
    @Published var gradeSemesters: [GradeSemesters] = []
    @Published var grades: [Grades] = []
    @Published var gradeCourses: [GradeCourses] = []
    
    private var gradeSemestersArray: NSArray = []
    private var gradesArray: NSArray = []
    private var gradeCoursesArray: NSArray = []
    
    var currentSelectedSemesterIdx = ""
    var currentSelectedSemesterName = ""
    @Published var selectedSemesterIndex = 0
    
    private var gradingWeightValuesArray: [String] = []
    @Published var uniqueGradingWeightValuesArray: [String] = []
    
    private var subjectNameArray: [String] = []
    @Published var uniqueSubjectNameArray: [String] = []
    
    @Published var gradeSemesterNamesArray: [String] = []
    
    @Published var existingCourseIdxsForGradesArray: [String] = []
    
    var gradeColorsArray: [Color] = [.blue, .orange, .teal, .blue, .purple, .gray, .green]
    var gradeColorsDict: [String: Color] = [:]
    
    @Published var isExpanded: [Bool] = []
    
    @Published var singleGradeClicked = false
    
    @Published var selectedGradeValue = ""
    @Published var selectedGradingWeightValueName = ""
    @Published var selectedGradeSubject = ""
    @Published var selectedTeacherName = ""
    @Published var selectedGradeDate = ""
    @Published var selectedPercentage = ""
    @Published var selectedGradeComment = ""
    @Published var selectedCourseIdx = ""
    
    @Published var gradingColorsArray: [Color] = []
    @Published var uniqueGradingColorsArray: [Color] = []
    
    func getGradeSemesters() {
        self.resetBadge(table: "grading", studentIdx: studentIdx)
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
                self.gradeSemestersArray = dict.value(forKey: "data") as! NSArray
                
                self.gradeSemesters = []
                self.gradeSemesterNamesArray = []
                
                if error == 0 {
                    
                    for obj in self.gradeSemestersArray {
                        let singleSemester = obj as! NSDictionary
                        
                        let semesterIdx = singleSemester.value(forKey: "idx") as? String ?? ""
                        let termName = singleSemester.value(forKey: "term_name") as? String ?? ""
                        let isSelected = singleSemester.value(forKey: "selected") as? Int ?? 0
                        
                        let oneSemester = GradeSemesters(semesterIdx: semesterIdx, termName: termName, isSelected: isSelected)
                        
                        self.gradeSemesterNamesArray.append(termName)
                        self.gradeSemesters.append(oneSemester)
                        
                        if isSelected == 1 {
                            self.currentSelectedSemesterIdx = semesterIdx
                            self.currentSelectedSemesterName = termName
                        }
                    }
                    
                    for i in 0..<self.gradeSemesters.count {
                        if self.gradeSemesters[i].isSelected == 1 {
                            self.selectedSemesterIndex = i
                        }
                    }
                    
                    self.getGrades(semester_idx: self.currentSelectedSemesterIdx)
                    
                }
            case . failure(let error):
                print(error)
            }
        }
    }
    
    func getGrades(semester_idx: String) {
        let parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "semester_idx": semester_idx,
            "school_idx": defaults.string(forKey: "school_idx")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_GRADES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                self.grades = []
                self.gradeCourses = []
                
                var gradeValue = ""
                
                if error == 0 {
                    self.gradeCoursesArray = dict.value(forKey: "courses") as! NSArray
                    self.gradesArray = dict.value(forKey: "data") as! NSArray
                    for gradeCoursesObj in self.gradeCoursesArray {
                        let singleGradeCourse = gradeCoursesObj as! NSDictionary
                        
                        let courseIdx = singleGradeCourse.value(forKey: "course_idx") as? String ?? ""
                        let subject = singleGradeCourse.value(forKey: "subject") as? String ?? ""
                        let average = singleGradeCourse.value(forKey: "avg") as? String ?? ""
                        
                        let oneGradeCourse = GradeCourses(courseIdx: courseIdx, subject: subject, average: average)
                        
                        self.gradeCourses.append(oneGradeCourse)
                        self.isExpanded.append(false)
                        
                    }
                    
                    for gradeObj in self.gradesArray {
                        let singleGrade = gradeObj as! NSDictionary
                        
                        let courseIdx = singleGrade.value(forKey: "course_idx") as? String ?? ""
                        let comments = singleGrade.value(forKey: "comments") as? String ?? ""
                        let subject = singleGrade.value(forKey: "subject") as? String ?? ""
                        let teacherName = singleGrade.value(forKey: "teacher") as? String ?? ""
                        let gradeDate = singleGrade.value(forKey: "date") as? String ?? ""
                        let typeOfGrading = singleGrade.value(forKey: "typeOfGrading") as? String ?? ""
                        
                        if typeOfGrading == "string-values" {
                            gradeValue = singleGrade.value(forKey: "value_text") as? String ?? ""
                        } else {
                            gradeValue = singleGrade.value(forKey: "value_int") as? String ?? ""
                        }
                        let percentage = singleGrade.value(forKey: "percentage") as? String ?? ""
                        let gradingWeightValueName = singleGrade.value(forKey: "gwv_name") as? String ?? ""
                        let gradingColor = singleGrade.value(forKey: "color") as? String ?? ""
                        
                        
                        // DATE FORMATTER
                        let fmt = DateFormatter()
                        fmt.locale = Locale(identifier: "en_US_POSIX")
                        fmt.dateFormat = "dd-MM-yyyy"

                        //first, convert string to Date
                        let dt = fmt.date(from: gradeDate)!

                        //then convert Date back to String in a different format
                        fmt.dateFormat = "dd MMM"
                        let convertedGradeDate = fmt.string(from: dt)
                        
                        let oneGrade = Grades(courseIdx: courseIdx, comments: comments, subject: subject, teacherName: teacherName, gradeDate: convertedGradeDate, typeOfGrading: typeOfGrading, percentage: percentage, gradingWeightValueName: gradingWeightValueName, gradeValue: gradeValue, color: gradingColor)
                        
                        self.grades.append(oneGrade)
                        
                        self.gradingWeightValuesArray.append(gradingWeightValueName)
                        self.uniqueGradingWeightValuesArray = self.gradingWeightValuesArray.removeDuplicates()
                        
                        self.existingCourseIdxsForGradesArray.append(courseIdx)
                        
                        self.gradeColorsDict[gradingWeightValueName] = Color(hex: gradingColor)
                        self.gradingColorsArray.append(Color(hex: gradingColor))
                        self.uniqueGradingColorsArray = self.gradingColorsArray.removeDuplicates()
                    }
                    print(self.uniqueGradingColorsArray)
                    print(self.uniqueGradingWeightValuesArray)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterGrades(gradeValueName: String) -> [Grades] {
        return grades.filter{$0.gradingWeightValueName == gradeValueName}
    }
    
    func gradeWithData(courseName: String) -> Int {
        for gradeCourse in gradeCourses {
            if courseName == gradeCourse.subject {
                return 1
            } else {
                return 0
            }
        }
        return 0
    }
}
