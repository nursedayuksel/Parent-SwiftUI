//
//  NurseryReportViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire

class NurseryReportViewModel: ObservableObject {
    
    let defaults = UserDefaults.standard
    
    @Published var monthDict: [String] = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    @Published var nurseryCategoriesArray: NSArray = []
    
    @Published var nurseryCategories: [NurseryCategories] = []
    @Published var nurseryRecords: [NurseryRecords] = []
    
    @Published var selectedMonthName = DateFormatter().monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
    
    @Published var generalComment: String = ""
    
    func initialNurseryReportProgress() {
        self.getNurseryReportProgress(month: Calendar.current.component(.month, from: Date()))
    }
    
    func getNurseryReportProgress(month: Int) {
        
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "month": "\(month)",
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        //print(parameters)
        
        AF.request(URL_GET_NURSERY_PROGRESS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
                
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 0
                if error == 0 {
                    self.nurseryCategories = []
                    self.nurseryRecords = []
                    
                    let nurseryReportsArray = dict.value(forKey: "data") as! NSDictionary
                    
                    self.generalComment = nurseryReportsArray.value(forKey: "general_comment") as? String ?? ""
                    
                    self.nurseryCategoriesArray = nurseryReportsArray.value(forKey: "categories") as! NSArray
                    //print(self.nurseryCategoriesArray)
                    
                    for obj in self.nurseryCategoriesArray {
                        
                        let singleNurseryCategory = obj as! NSDictionary

                        let color = singleNurseryCategory.value(forKey: "color") as? String ?? ""
                        let categoryName = singleNurseryCategory.value(forKey: "name") as? String ?? ""
                        
                        let oneCategory = NurseryCategories(color: color, categoryName: categoryName, generalComment: self.generalComment)
                        
                        self.nurseryCategories.append(oneCategory)
                        
                        let nurseryRecords = singleNurseryCategory.value(forKey: "records") as! NSArray
                        
                        for obj1 in nurseryRecords {
                            let singleNurseryRecord = obj1 as! NSDictionary
                            
                            let category_Name = singleNurseryRecord.value(forKey: "category_name") as? String ?? ""
                            let comment = singleNurseryRecord.value(forKey: "comment") as? String ?? ""
                            let month = singleNurseryRecord.value(forKey: "month") as? String ?? ""
                            let score = singleNurseryRecord.value(forKey: "score") as? String ?? ""
                            let subCategoryName = singleNurseryRecord.value(forKey: "sub_category_name") as? String ?? ""
                            
                            let oneRecord = NurseryRecords(categoryName: category_Name, comment: comment, month: month, score: score, subCategoryName: subCategoryName)
                            
                            self.nurseryRecords.append(oneRecord)
                        }
                    }
                    //print(self.nurseryRecords)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
