//
//  BehaviorViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class BehaviorViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var behaviorList: [Behavior] = []
    
    @Published var positivePoints: Double = 0.0
    @Published var negativePoints: Double = 0.0
    
    private var behaviorArray: NSArray = []
    
    var behaviorCoursesArray: [String] = []
    var uniqueBehaviorCoursesArray: [String] = []
    
    var behaviourCourseIdxsArray: [String] = []
    var uniqueBehaviorCourseIdxsArray: [String] = []
    
    @Published var selectedCourseIdx = ""
    
    func getBehaviors() {
        let parameters = [
            "school_group" : defaults.string(forKey: "school_group")!,
            "db" : defaults.string(forKey: "db")!,
            "student_user_idx" : studentIdx,
            "course_idx" : selectedCourseIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        AF.request(URL_GET_BEHAVIORS, method: .post, parameters: parameters).responseJSON { response in
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.behaviorArray = dict.value(forKey: "data") as! NSArray
                
                self.behaviorList = []
                
                if error == 0 {
                    for obj in self.behaviorArray {
                        let oneBehavior = obj as! NSDictionary
                        let behaviorIdx = oneBehavior.value(forKey: "idx") as? String ?? ""
                        let type = oneBehavior.value(forKey: "type") as? String ?? ""
                        let behaviorName = oneBehavior.value(forKey: "name") as? String ?? ""
                        let point = oneBehavior.value(forKey: "point") as? String ?? ""
                        let behaviorIcon = oneBehavior.value(forKey: "icon") as? String ?? ""
                        let subject = oneBehavior.value(forKey: "subject") as? String ?? ""
                        let courseIdx = oneBehavior.value(forKey: "course_idx") as? String ?? ""
                        
                        let singleBehavior = Behavior(behaviorIdx: behaviorIdx, type: type, behaviorName: behaviorName, point: point, behaviorIcon: behaviorIcon, subject: subject, courseIdx: courseIdx)
                        self.behaviorList.append(singleBehavior)
                        
                        self.behaviorCoursesArray.append(subject)
                        self.uniqueBehaviorCoursesArray = self.behaviorCoursesArray.removeDuplicates()
                        
                        self.behaviourCourseIdxsArray.append(courseIdx)
                        self.uniqueBehaviorCourseIdxsArray = self.behaviourCourseIdxsArray.removeDuplicates()
                        
                        self.uniqueBehaviorCoursesArray.insert("All courses", at: 0)
                        self.uniqueBehaviorCourseIdxsArray.insert("", at: 0)
                    }
                    print(self.uniqueBehaviorCourseIdxsArray)
                }
                
                var totalPoints = 0
                self.positivePoints = 0.0
                self.negativePoints = 0.0
                
                for behavior in self.behaviorList {
                    totalPoints = totalPoints + Int(behavior.point)!
                    
                    if behavior.type == "positive" {
                        self.positivePoints = self.positivePoints + Double(behavior.point)!
                    } else {
                        self.negativePoints = self.negativePoints + Double(behavior.point)!
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setPointSign(pointValue: String) -> String {
        if pointValue == "positive" {
            return "+"
        } else {
            return "-"
        }
    }
    
    func pointColor(pointValue: String) -> Color {
        if pointValue == "positive" {
            return .green
        } else {
            return .red
        }
    }
    
    func filterBehaviorsForCourse(courseName: String) -> [Behavior] {
        print(courseName)
        return behaviorList.filter{$0.subject == courseName}
    }
}
