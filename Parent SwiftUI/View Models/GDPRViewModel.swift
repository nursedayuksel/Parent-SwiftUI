//
//  GDPRViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire
import SwiftUI
import OrderedDictionary

class GDPRViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var gdpr: [GDPR] = []
    @Published var gdprYears: [GDPRYears] = []
    
    var gdprArray: NSArray = []
    var gdprYearsArray: NSArray = []
    
    @Published var errorMessage = ""
    @Published var successMessage = ""
    
    @Published var ruleIdxsArray: [String] = []
    @Published var parentAnswersArray: [String] = []
    @Published var selectedDefaultCheckboxIndexArray: [Int] = []
    @Published var selectedCheckboxArray: [Int] = []
    @Published var yesNoBoolDict: [String: Bool] = [:]
    
    @Published var yesChecked: [Bool] = []
    @Published var noChecked: [Bool] = []
    
    @Published var ruleIdxsAndValuesDict = OrderedDictionary<String, String>()
    
    @Published var areYouSureClicked = false
    
    @Published var selectedCheckboxIndex = -1
    
    @Published var displayYearArray: [String] = []
    
    @Published var selectedYearName = ""
    @Published var selectedDb = ""
    
    func getGDPRRules(db: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": db,
            "school_idx": defaults.string(forKey: "school_idx")!,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_GDPR_RULES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.gdpr = []
                    self.ruleIdxsArray = []
                    self.ruleIdxsAndValuesDict = [:]
                    self.yesNoBoolDict = [:]
                    self.selectedDefaultCheckboxIndexArray = []
                    self.selectedCheckboxArray = []
                    self.parentAnswersArray = []
                    self.yesChecked = []
                    self.noChecked = []
                    
                    self.gdprArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.gdprArray {
                        let singleGDPR = obj as! NSDictionary
                        
                        let ruleIdx = singleGDPR.value(forKey: "rule_idx") as? String ?? ""
                        let rules = singleGDPR.value(forKey: "rules") as? String ?? ""
                        let defaultOption = singleGDPR.value(forKey: "default_option") as? String ?? ""
                        let parentAnswer = singleGDPR.value(forKey: "parent_answer") as? String ?? ""
                        
                        let oneGDPR = GDPR(ruleIdx: ruleIdx, rule: rules, defaultOption: defaultOption, parentAnswer: parentAnswer)
                        self.gdpr.append(oneGDPR)
                        
                        self.ruleIdxsArray.append(ruleIdx)
                        self.ruleIdxsAndValuesDict[ruleIdx] = defaultOption
                        self.yesNoBoolDict[ruleIdx] = false
                        self.yesChecked.append(false)
                        self.noChecked.append(false)
                        self.selectedDefaultCheckboxIndexArray.append(Int(defaultOption)!-1)
                        self.selectedCheckboxArray.append(-1)
                        
                        if defaultOption == "0" {
                            self.yesNoBoolDict[ruleIdx] = false
                        } else if defaultOption == "1" {
                            self.yesNoBoolDict[ruleIdx] = true
                        } else {
                            self.yesNoBoolDict[ruleIdx] = false
                        }

                        if parentAnswer != "" {
                            self.parentAnswersArray.append(parentAnswer)
                        }
                    }
                    
                    print(self.yesNoBoolDict)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendGDPRForm(db: String) {
        let answersArr = ruleIdxsAndValuesDict.map { "\($1)" }
        
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": db,
            "user_idx": defaults.string(forKey: "user_idx")!,
            "student_idx": studentIdx,
            "rule_idx_arr": ruleIdxsArray,
            "answers_arr": answersArr,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_SEND_GDPR_FORM, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1

                if error == 0 {
                    self.areYouSureClicked = true
                    self.successMessage = dict.value(forKey: "message") as? String ?? ""
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getGDPREducationalYears() {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_GDPR_EDUCATIONAL_YEARS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.gdprYears = []
                    self.displayYearArray = []
                    
                    self.gdprYearsArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.gdprYearsArray {
                        let singleYear = obj as! NSDictionary
                        
                        let yearIdx = singleYear.value(forKey: "idx") as? String ?? ""
                        let displayYear = singleYear.value(forKey: "value") as? String ?? ""
                        let db = singleYear.value(forKey: "db") as? String ?? ""
                        
                        let oneYear = GDPRYears(yearIdx: yearIdx, displayYear: displayYear, db: db)
                        self.gdprYears.append(oneYear)
                        self.displayYearArray.append(displayYear)
                    }
                    
                    self.getGDPRRules(db: self.defaults.string(forKey: "db")!)
                    
                    self.selectedYearName = self.gdprYears[0].displayYear
                    self.selectedDb = self.defaults.string(forKey: "db")!
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkmarkColor(checkboxIndex: Int) -> Color {
        if checkboxIndex == -1 {
            return .clear
        } else if checkboxIndex == 0 {
            return Color("MyEduCare")
        } else {
            return .red
        }
    }
    
    func yesOrNo(parentAnswer: String) -> String {
        if parentAnswer == "0" {
            return "No data"
        } else if parentAnswer == "1" {
            return "Yes"
        } else {
            return "No"
        }
    }
    
    func parentAnswerColor(parentAnswer: String) -> Color {
        if parentAnswer == "0" {
            return .gray
        } else if parentAnswer == "1" {
            return Color("MyEduCare")
        } else {
            return .red
        }
    }
}
