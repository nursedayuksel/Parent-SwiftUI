//
//  ExamDatesViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire

class ExamDatesViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var examDates: [ExamDate] = []
    
    private var examDatesArray: NSArray = []
    
    func getExamDates() {
        let parameters: Parameters = [
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/student"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_EXAM_DATES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                self.examDatesArray = dict.value(forKey: "data") as! NSArray
                
                if error == 0 {
                    self.examDates = []
                    
                    for obj in self.examDatesArray {
                        let singleExamDate = obj as! NSDictionary
                        
                        let courseName = singleExamDate.value(forKey: "course") as? String ?? ""
                        let examDate = singleExamDate.value(forKey: "date") as? String ?? ""
                        let teacherFirstName = singleExamDate.value(forKey: "name") as? String ?? ""
                        let teacherLastName = singleExamDate.value(forKey: "surname") as? String ?? ""
                        let examDescription = singleExamDate.value(forKey: "description") as? String ?? ""
                        
                        let oneExamDate = ExamDate(courseName: courseName, examDate: examDate, teacherName: teacherFirstName + " " + teacherLastName, examDescription: examDescription)
                        
                        self.examDates.append(oneExamDate)
                    }
                    
                    print(self.examDates.count)
                }
        
            case .failure(let error):
                print(error)
            }
        }
    }
}
