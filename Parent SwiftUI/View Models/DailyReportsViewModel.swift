//
//  DailyReportsViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class DailyReportsViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var dailyReports: [DailyReports] = []
    @Published var dailyReportsSemesters: [DailyReportSemesters] = []
    
    @Published var readReportsCount = 0
    @Published var unreadReportsCount = 0
    
    var originalIdsArray: [String] = []
    @Published var copyIdsArray: [String] = []
    
    private var dailyReportsArray: NSArray = []
    private var dailyReportsSemestersArray: NSArray = []
    
    var reportIdsArray: [String] = []
    
    var currentSelectedSemesterIdx = ""
    var currentSelectedSemesterName = ""
    
    var html = ""
    @Published var messageUrl = ""
    
    func getDailyReportsSemesters() {
        self.resetBadge(table: "daily_reports", studentIdx: studentIdx)
        let parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/student"
        ]
        
        AF.request(URL_GET_SEMESTERS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.dailyReportsSemestersArray = dict.value(forKey: "data") as! NSArray
                
                self.dailyReportsSemesters = []
                
                if error == 0 {
                    
                    for obj in self.dailyReportsSemestersArray {
                        let singleSemester = obj as! NSDictionary
                        
                        let semesterIdx = singleSemester.value(forKey: "idx") as? String ?? ""
                        let termName = singleSemester.value(forKey: "term_name") as? String ?? ""
                        let isSelected = singleSemester.value(forKey: "selected") as? Int ?? 0
                        
                        let oneSemester = DailyReportSemesters(semesterIdx: semesterIdx, termName: termName, isSelected: isSelected)
                        
                        self.dailyReportsSemesters.append(oneSemester)
                        
                        if isSelected == 1 {
                            self.currentSelectedSemesterIdx = semesterIdx
                            self.currentSelectedSemesterName = termName
                        }
                    }
                    
                   self.getDailyReports(semester_idx: self.currentSelectedSemesterIdx)
                    
                }
            case . failure(let error):
                print(error)
            }
        }
    }
    
    func getDailyReports(semester_idx: String) {
        let parameters = [
            "user_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "semester_idx": semester_idx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print("PARAMETERS: \(parameters)")
        
        AF.request(URL_GET_DAILY_REPORTS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.dailyReportsArray = dict.value(forKey: "data") as! NSArray
                
                self.dailyReports = []
                
                
                let idsString = UserDefaults.standard.string(forKey: "savedReportsIdd") ?? ""
                self.originalIdsArray = idsString.components(separatedBy: ";")
                
                if error == 0 {
                    var totalCount = 0
                    
                    self.readReportsCount = 0
                    for obj in self.dailyReportsArray {
                        let singleDailyReport = obj as! NSDictionary
                        
                        let dailyReportIdx = singleDailyReport.value(forKey: "idx") as? String ?? ""
                        let attachments = singleDailyReport.value(forKey: "attachments") as? String ?? ""
                        let createDate = singleDailyReport.value(forKey: "dates") as? String ?? ""
                        let dateForDisplay = singleDailyReport.value(forKey: "dates_display") as? String ?? ""
                        let message = singleDailyReport.value(forKey: "messages") as? String ?? ""
                        let subject = singleDailyReport.value(forKey: "subjects") as? String ?? ""
                        
                        self.reportIdsArray.append(dailyReportIdx)
                        
                        for item in self.originalIdsArray {
                            if item == dailyReportIdx && item != "" {
                                self.readReportsCount += 1
                            }
                        }
                        
                        totalCount += 1
                        
                        self.html = message
                        if attachments != "" {
                            let data = attachments.data(using: .utf8)!
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [Dictionary<String, Any>] {
                                    self.html = self.html + "<br/><span style='color:red'>Tap to view, long press for other options:</span><br/>"
                                    
                                    for i in 0..<jsonArray.count {
                                        let singleJson = jsonArray[i] as NSDictionary
                                        let path = singleJson.value(forKey: "path") as! String
                                        
                                        let mainDb = self.defaults.string(forKey: "school_group") ?? ""
                                        
                                        let myString = "<br/><a href='" + "https://attach.my-educare.com/attachments/" + mainDb + "/" + path + "'>" + "DOWNLOAD ATTACHMENT " + String(i + 1) + "</a><br>"
                                        
                                        self.html = self.html + myString
                                        //print(self.html)
     
                                    }
                                } else {
                                    print("bad json")
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                        
                        let oneDailyReport = DailyReports(dailyReportIdx: dailyReportIdx, attachment: attachments, createDate: createDate, dateForDisplay: dateForDisplay, message: message, subject: subject, html: self.html)
                        self.dailyReports.append(oneDailyReport)
                    }
                    
                    self.unreadReportsCount = totalCount - self.readReportsCount
                    self.messageUrl = self.html
                    print(self.html)
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterColors(status: String) -> Color {
        if status == "All" {
            return .blue
        } else if status == "Read" {
            return .green
        } else {
            return .red
        }
    }
    
    func reportStatus(reportIdx: String) {
        let savedIds = UserDefaults.standard.string(forKey: "savedReportsIdd") ?? ""
        var reportIdsArray = savedIds.components(separatedBy: ";")

        if reportIdsArray[0] == ""
        {
            reportIdsArray = []
        }
        var idFound = false
        for item in reportIdsArray
        {
            if item == reportIdx
            {
                idFound = true
            }
        }

        if !idFound
        {
            reportIdsArray.append(reportIdx)
        }
        let newStr = reportIdsArray.joined(separator: ";")
        UserDefaults.standard.setValue(newStr, forKey: "savedReportsIdd")

        readReportsCount = reportIdsArray.count
        unreadReportsCount = dailyReports.count - readReportsCount
    }
    
    func indivReportColors(reportIdx: String) -> Color {
        let savedIds = UserDefaults.standard.string(forKey: "savedReportsIdd") ?? ""
        let reportIdsArray = savedIds.components(separatedBy: ";")
        
        if reportIdsArray.contains(reportIdx) {
            return Color.green
        } else {
            return Color.red
        }
    }
    
    func filterReports(reportStatus: String) {

        let savedIds = UserDefaults.standard.string(forKey: "savedReportsIdd") ?? ""
        let reportIdsArray = savedIds.components(separatedBy: ";")
        
        copyIdsArray = []
        
        if reportStatus == "All" {
            for report in dailyReports {
                copyIdsArray.append(report.dailyReportIdx)
            }

            
        } else if reportStatus == "Read" {
            for report in dailyReports {
                if reportIdsArray.contains(report.dailyReportIdx){
                    copyIdsArray.append(report.dailyReportIdx)
                }
            }
            
        } else if reportStatus == "Unread" {
            for report in dailyReports {
                if !reportIdsArray.contains(report.dailyReportIdx){
                    copyIdsArray.append(report.dailyReportIdx)
                }
            }
        }
    }
}
