//
//  DailySummaryViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

struct DailySummaryCategory {
    var category: String
    var value: String
    var image: String
}

class DailySummaryViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var dailySummaryCategories: [DailySummary] = []
    
    @Published var parentCanWrite = false
    @Published var selectedDate = Date()
    
    @Published var feedback = ""

    @Published var message = ""
    @Published var alertTitle = ""
    
    func getDailySummary() {

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyyMMdd"

        // Convert Date to String
        let convertedDate = dateFormatter.string(from: selectedDate)
        
        let parameters: Parameters = [
            "student_idx" : studentIdx,
            "school_group" : defaults.string(forKey: "school_group")!,
            "db" : defaults.string(forKey: "db")!,
            "date" : convertedDate,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_DAILY_SUMMARY, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.dailySummaryCategories = []
                    
                    let settings = dict.value(forKey: "settings") as? NSDictionary ?? nil
                    let dailySummary = dict.value(forKey: "daily_summary") as? NSDictionary ?? nil
                    
                    if settings != nil && dailySummary != nil {
                        let morningSnack = settings!.value(forKey: "morningsnack") as? String ?? "0"
                        if morningSnack == "1" {
                            let morningsnackValue = dailySummary!.value(forKey: "morningsnack") as? String ?? "0"
                            let temp = DailySummary(category: "Morning snack", value: morningsnackValue, image: "morning_snack")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let amsnack = settings!.value(forKey: "amsnack") as? String ?? "0"
                        if amsnack == "1" {
                            let amsnackValue = dailySummary!.value(forKey: "amsnack") as? String ?? "0"
                            let temp = DailySummary(category: "AM snack", value: amsnackValue, image: "am_snack")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let lunch = settings!.value(forKey: "lunch") as? String ?? "0"
                        if lunch == "1" {
                            let lunchValue = dailySummary!.value(forKey: "lunch") as? String ?? "0"
                            let temp = DailySummary(category: "Lunch", value: lunchValue, image: "lunch")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let afternoonsnack = settings!.value(forKey: "afternoonsnack") as? String ?? "0"
                        if afternoonsnack == "1" {
                            let value = dailySummary!.value(forKey: "afternoonsnack") as? String ?? "0"
                            let temp = DailySummary(category: "Afternoon snack", value: value, image: "afternoon_snack")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let sleep = settings!.value(forKey: "sleep") as? String ?? "0"
                        if sleep == "1" {
                            let value = dailySummary!.value(forKey: "sleep") as? String ?? "0"
                            let temp = DailySummary(category: "Sleep", value: value, image: "sleep-1")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let mood = settings!.value(forKey: "mood") as? String ?? "0"
                        if mood == "1"{
                            var value = dailySummary!.value(forKey: "mood") as? String ?? ""
                            if value != "" {
                                let temp_arr = value.components(separatedBy: ";")
                                value = temp_arr.joined(separator: ", ")
                            }
                            let temp = DailySummary(category: "Today I feel", value: value, image: "mood")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let toilet = settings!.value(forKey: "toilet") as? String ?? "0"
                        if toilet == "1" {
                            let value = dailySummary!.value(forKey: "pee") as? String ?? ""
                            let temp = DailySummary(category: "Toilet", value: value, image: "toilet")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let comment = settings!.value(forKey: "comment") as? String ?? "0"
                        if comment == "1" {
                            let value = dailySummary!.value(forKey: "comment") as? String ?? ""
                            let temp = DailySummary(category: "Teacher's comment", value: value, image: "comment")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let fun = settings!.value(forKey: "fun_text") as? String ?? "0"
                        if fun == "1" {
                            let value = dailySummary!.value(forKey: "had_fun_when") as? String ?? ""
                            let temp = DailySummary(category: "Today I had fun when...", value: value, image: "fun")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let learned = settings!.value(forKey: "learned_text") as? String ?? "0"
                        if learned == "1" {
                            let value = dailySummary!.value(forKey: "learned") as? String ?? ""
                            let temp = DailySummary(category: "Today I learned...", value: value, image: "learn")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let home = settings!.value(forKey: "home_text") as? String ?? "0"
                        if home == "1" {
                            let value = dailySummary!.value(forKey: "home") as? String ?? ""
                            let temp = DailySummary(category: "Task for home...", value: value, image: "home")
                            self.dailySummaryCategories.append(temp)
                        }
                        
                        let parent = settings!.value(forKey: "parent_text") as? String ?? "0"
                        if parent == "0" {
                            self.parentCanWrite = false
                        }
                        else{
                            self.parentCanWrite = true
                            //DAILY_SUMMARY_PARENT_TEXT = daily_summary!.value(forKey: "parent") as? String ?? ""
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getFeedback() {
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyyMMdd"

        // Convert Date to String
        let convertedDate = dateFormatter.string(from: selectedDate)

        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": UserDefaults.standard.string(forKey: "db")!,
            "school_group": UserDefaults.standard.string(forKey: "school_group")!,
            "date" : convertedDate,
            "caller_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_FEEDBACK_DAILY_SUMMARY, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.feedback = dict.value(forKey: "feedback") as? String ?? ""
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendFeedback() {
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yyyyMMdd"

        // Convert Date to String
        let convertedDate = dateFormatter.string(from: selectedDate)

        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": UserDefaults.standard.string(forKey: "db")!,
            "school_group": UserDefaults.standard.string(forKey: "school_group")!,
            "date" : convertedDate,
            "feedback" : feedback,
            "caller_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_SEND_DAILY_SUMMARY_FEEDBACK, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.alertTitle = "Success!"
                    self.message = "Your feedback has been sent!"
                } else {
                    self.alertTitle = "Error!"
                    self.message = dict.value(forKey: "error_message") as? String ?? ""
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func dailySummaryValueSmileyFace(value: String) -> String {
        if value > "24" {
            return "ds_meh"
        } else if value > "74" {
            return "ds_smile"
        } else {
            return "ds_sad"
        }
    }
    
    func dailySummaryValueSmileyFaceDesc(value: String, category: String) -> String {
        if value > "24" {
            if category == "Sleep" {
                return "Sleep"
            } else {
                return "Normal appetite"
            }
        } else if value > "74" {
            if category == "Sleep" {
                return "Good sleep"
            } else {
                return "Good appetite"
            }
        } else {
            if category == "Sleep" {
                return "Didn't sleep well"
            } else {
                return "Bad appetite"
            }
        }
    }
}
