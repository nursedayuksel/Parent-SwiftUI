//
//  HomeworkViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class HomeworkViewModel: ObservableObject {
    var defaults = UserDefaults.standard
    
    @Published var homeworkSemesters : [HomeworkSemesters] = []
    @Published var homework: [Homework] = []
    @Published var singleHomework: [SingleHomework] = []
    
    private var homeworkSemestersArray: NSArray = []
    private var homeworksArray: NSArray = []
    private var singleHomeworkArray: NSArray = []
    
    @Published var homeworkSemesterNamesArray: [String] = []
    
    var currentSelectedSemesterIdx = ""
    var currentSelectedSemesterName = ""
    
    @Published var selectedSemesterIndex = 0
    
    var homeworkCategoriesArray: [String] = []
    var uniqueHomeworkCategoriesArray: [String] = []
    
    var homeworkColorDictionary: [String:Color] = [:]
    
    @Published var firstButtonFileType = ""
    @Published var secondButtonFileType = ""
    @Published var thirdButtonFileType = ""
    
    @Published var linkOfFirstFile: URL? = nil
    @Published var linkOfSecondFile: URL? = nil
    @Published var linkOfThirdFile: URL? = nil
    
    @Published var firstFileExtension = ""
    @Published var secondFileExtension = ""
    @Published var thirdFileExtension = ""
    
    @Published var firstButtonImage = UIImage()
    @Published var secondButtonImage = UIImage()
    @Published var thirdButtonImage = UIImage()
    
    @Published var firstButtonTitle = ""
    @Published var secondButtonTitle = ""
    @Published var thirdButtonTitle = ""
    
    var homeworkValueColorsArray: [Color] = [.blue, .green, .orange, .pink, .purple, .gray, .red]
    var homeworkValueColorsDict: [String: Color] = [:]
    
    @Published var firstImage = ""
    
    var path = ""
    var html = ""
    @Published var messageUrl = ""
    
    @Published var comment = ""
    @Published var category: [String] = []
    
    func getHomeworkSemesters() {
        self.resetBadge(table: "homeworks", studentIdx: studentIdx)
        let parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_SEMESTERS, method: .post, parameters: parameters).responseJSON { response in
           // print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.homeworkSemestersArray = dict.value(forKey: "data") as! NSArray
                
                self.homeworkSemesters = []
                
                if error == 0 {
                    
                    for obj in self.homeworkSemestersArray {
                        let singleSemester = obj as! NSDictionary
                        
                        let semesterIdx = singleSemester.value(forKey: "idx") as? String ?? ""
                        let termName = singleSemester.value(forKey: "term_name") as? String ?? ""
                        let isSelected = singleSemester.value(forKey: "selected") as? Int ?? 0
                        
                        let oneSemester = HomeworkSemesters(semesterIdx: semesterIdx, termName: termName, isSelected: isSelected)
                        
                        self.homeworkSemesters.append(oneSemester)
                        self.homeworkSemesterNamesArray.append(termName)
                        
                        if isSelected == 1 {
                            self.currentSelectedSemesterIdx = semesterIdx
                            self.currentSelectedSemesterName = termName
                        }
                    }
                    
                    for i in 0..<self.homeworkSemesters.count {
                        if self.homeworkSemesters[i].isSelected == 1 {
                            self.selectedSemesterIndex = i
                        }
                    }
                    
                    self.getHomeworks(semester_idx: self.currentSelectedSemesterIdx)
                    
                }
            case . failure(let error):
                print(error)
            }
        }
    }
    
    func getHomeworks(semester_idx: String) {
        let parameters = [
            "student_idx": studentIdx,
            "semester_idx": semester_idx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_HOMEWORKS, method: .post, parameters: parameters).responseJSON { response in
            //print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                self.homework = []
                
                if error == 0 {
                    
                    self.homeworksArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.homeworksArray {
                        let singleHomework = obj as! NSDictionary
                        
                        let startDate = singleHomework.value(forKey: "start_date") as? String ?? ""
                        let endDate = singleHomework.value(forKey: "end_date") as? String ?? ""
                        let diff = singleHomework.value(forKey: "diff") as? String ?? ""
                        let teacherName = singleHomework.value(forKey: "teacher") as? String ?? ""
                        let courseName = singleHomework.value(forKey: "course") as? String ?? ""
                        let short = singleHomework.value(forKey: "short") as? String ?? "NE"
                        let value = singleHomework.value(forKey: "value") as? String ?? "Not evaluated"
                        let homeworkIdx = singleHomework.value(forKey: "idx") as? String ?? ""
                        let attachment = singleHomework.value(forKey: "attachment") as? String ?? ""
                        
                        let oneHomework = Homework(startDate: startDate, endDate: endDate, diff: diff, teacherName: teacherName, courseName: courseName, short: short, value: value, homeworkIdx: homeworkIdx, attachment: attachment)
                        
                        self.homework.append(oneHomework)
                        
                        self.homeworkCategoriesArray.append(value)
                        self.uniqueHomeworkCategoriesArray = self.homeworkCategoriesArray.removeDuplicates()
                    }
                    
                    for i in 0..<self.uniqueHomeworkCategoriesArray.count {
                        if self.uniqueHomeworkCategoriesArray[i].contains("Not evaluated") {
                            self.homeworkValueColorsDict["\(self.uniqueHomeworkCategoriesArray[i])"] = .gray
                        } else {
                            self.homeworkValueColorsDict["\(self.uniqueHomeworkCategoriesArray[i])"] = self.homeworkValueColorsArray[i % self.uniqueHomeworkCategoriesArray[i].count]
                        }
                    }

                    print(self.uniqueHomeworkCategoriesArray)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSingleHomework(homework: Homework) {
        let parameters = [
            "homework_idx": homework.homeworkIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_SINGLE_HOMEWORK, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    
                    self.category = []
                    
                    let homeworkDesc = dict.value(forKey: "homework") as? String ?? ""
                    let studentFiles = dict.value(forKey: "namestd") as? String ?? ""
                    self.comment = dict.value(forKey: "comment") as? String ?? ""
                    let categories = dict.value(forKey: "value_arr") as? NSArray ?? nil
                    let classroomLink = dict.value(forKey: "classroom_link") as? String ?? ""
                    let teacherFiles = dict.value(forKey: "teacher_files") as? NSArray ?? nil
                    
                    self.html = "<div><p style='font-size:200%'>" + homeworkDesc + "</p><br/></div>"
                    
                    if teacherFiles != nil {
                        self.html = self.html + "<p style='color:red;font-size:140%'>Tap to view, long-press for other options:</p>"
                        self.html = self.html + "<br/>"
                        
                        var fileNumber = 1
                        
                        for file in teacherFiles!
                        {
                            let fileName = file as! String
                            let numberString : String = String(fileNumber)
                            let fileByTeacher = "No. " + numberString + " " + "file uploaded by teacher"
                            let linkPart = "<a  href='" + fileName + "'>"
                            let tail = linkPart + fileByTeacher + "</a><br/>"
                            self.html = self.html + tail
                            print(self.html)
                            fileNumber = fileNumber + 1
                        }
                    }
                    
                    if studentFiles != "" {
                        self.html = self.html + "<br/>"
                        let studentFilesComponentsArray = studentFiles.components(separatedBy: ";")
                        for i in 0...studentFilesComponentsArray.count - 1
                        {
                            self.html = self.html + "<a href='" + self.path + studentFilesComponentsArray[i] + "'>" + "No. " + String(i+1) + "file uploaded by student" + "</a><br/>"
                        }
                    }
                    
                    if categories != nil {
                        for category in categories! {
                            self.category.append(category as! String)
                        }
                    }
                    
                    self.messageUrl = self.html
                    //print(self.messageUrl)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    func uploadHomeworkFile(homework_idx: String) {
        let parameters = [
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "homework_idx": homework_idx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
            
            print(self.firstButtonImage)
            if self.firstButtonFileType == "image" {
                let imgData = self.firstButtonImage.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imgData!, withName: "homework", fileName: "homework.png", mimeType: "image/png")
            }
            
            if self.firstButtonFileType == "document" {
                multipartFormData.append(self.linkOfFirstFile!, withName: "homework", fileName: "homework." + self.firstFileExtension, mimeType: "application/pdf")
            }
            
            if self.secondButtonFileType == "image" {
                let imgData = self.secondButtonImage.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imgData!, withName: "homework1", fileName: "homework1.png", mimeType: "image/png")
            }
            
            if self.secondButtonFileType == "document" {
                multipartFormData.append(self.linkOfSecondFile!, withName: "homework1", fileName: "homework1." + self.secondFileExtension, mimeType: "application/pdf")
            }
            
            if self.thirdButtonFileType == "image" {
                let imgData = self.thirdButtonImage.jpegData(compressionQuality: 0.5)
                multipartFormData.append(imgData!, withName: "homework2", fileName: "homework2.png", mimeType: "image/png")
            }
            
            if  self.thirdButtonFileType == "document" {
                multipartFormData.append(self.linkOfThirdFile!, withName: "homework2", fileName: "homework2." + self.thirdFileExtension, mimeType: "application/pdf")
            }

        }, to: URL_UPLOAD_FILE)
        .responseJSON(completionHandler: { response in
            switch response.result {
             case .success(let JSON):
                 print("response is :\(JSON)")
                
             case .failure(_):
                 print("fail")
             }
        })
    }
    
    func homeworkCategoriesCount(categoryName: String) -> Int {
        if categoryName == "Not evaluated" {
            return self.homework.filter{$0.short == "NE"}.count
        } else {
            return self.homework.filter{$0.value == categoryName}.count
        }
    }
    
    func filterHomeworks(categoryName: String) -> [Homework] {
        if categoryName == "Not evaluated" {
            return self.homework.filter{$0.short == "NE"}
        } else {
            return self.homework.filter{$0.value == categoryName}
        }
    }
    
    func getEveryHomeworkColor(index: Int) -> Color {
        if uniqueHomeworkCategoriesArray[index] == "Not evaluated" {
            return .gray
        } else {
            homeworkValueColorsDict["\(uniqueHomeworkCategoriesArray[index])"] = homeworkValueColorsArray[index % uniqueHomeworkCategoriesArray[index].count]
            print(homeworkValueColorsDict)
            return homeworkValueColorsDict["\(uniqueHomeworkCategoriesArray[index])"] ?? .clear
        }
        
    }

    func getExpirationColors(howManyDays: Int) -> Color {
        if howManyDays < 0 {
            return .gray
        } else if howManyDays == 0 {
            return .green
        } else {
            return .red
        }
    }
    
    func getExpirationValues(howManyDays: Int) -> String {
        if howManyDays < 0 {
            return "Expired"
        } else if howManyDays == 0 {
            return "Today"
        } else {
            return "\(howManyDays) days"
        }
    }
}
