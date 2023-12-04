//
//  TrackingViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class TrackingViewModel: ObservableObject {
    
    let defaults = UserDefaults.standard
    
    var courseIdsArray: [String] = []
    var coursesArray: NSArray = []
    var trackingArray: NSArray = []
    var historyArray: NSArray = []
    var subjectsArray: [String] = []
    
    @Published var childCourses: [Courses] = []
    @Published var trackingObjectives: [Tracking] = []
    @Published var trackingHistory: [History] = []
    
    @Published var objectiveIdx = ""
    @Published var courseIdx = ""
    @Published var warning_message = ""
    @Published var subject = ""
    
    @Published var trackingDictionary: NSDictionary = [:]
    
    func getCoursesForChild() {
        self.getTrackingObjectives()
        let parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_COURSES_FOR_CHILD, method: .post, parameters: parameters).responseJSON { response in

            print(response)
            
            switch response.result {
                
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                if error == 0{
                    self.coursesArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.coursesArray {
                        let singleCourse = obj as! NSDictionary
                            
                        //print(singleCourse)
                        
                        let course = singleCourse.value(forKey: "course") as? String ?? ""
                        self.courseIdx = singleCourse.value(forKey: "idx") as? String ?? ""
                        self.subject = singleCourse.value(forKey: "subject") as? String ?? ""
                        
                        let singleCourseChild = Courses(course: course, idx: self.courseIdx, subject: self.subject)
                        
                        //print(singleCourseChild)
                        
                        self.childCourses.append(singleCourseChild)
                        self.subjectsArray.append(self.subject)
                        self.courseIdsArray.append(self.courseIdx)
                    }
                }

                print(self.subjectsArray)
                    
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTrackingObjectives() {
        let parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "course_idx": self.courseIdx,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        //print(parameters)
        
        AF.request(URL_GET_TRACKING_OBJECTIVES, method: .post, parameters: parameters).responseJSON { response in
            
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                let warning = dict.value(forKey: "warning") as? Int ?? 1
                
                if error == 0 {
                    self.trackingObjectives = []
                    self.trackingArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.trackingArray {
                        let singleTrackingObjective = obj as! NSDictionary
                        
                        let EN = singleTrackingObjective.value(forKey: "EN") as? String ?? ""
                        let RO = singleTrackingObjective.value(forKey: "RO") as? String ?? ""
                        let RU = singleTrackingObjective.value(forKey: "RU") as? String ?? ""
                        let UK = singleTrackingObjective.value(forKey: "UK") as? String ?? ""
                        self.objectiveIdx = singleTrackingObjective.value(forKey: "idx") as? String ?? ""
                        let object_name = singleTrackingObjective.value(forKey: "object_name") as? String ?? ""
                        let school_idx = singleTrackingObjective.value(forKey: "school_idx") as? String ?? ""
                        let stars = singleTrackingObjective.value(forKey: "stars") as? String ?? ""
                        
                        self.trackingDictionary = [
                            "EN" : [EN, "Tracking", "Select Subject", "Select", "History", "Tracking Hisotry"],
                            "RO" : [RO, "Urmărire", "Selectați Subiect", "Selectați", "Istorie", "Istoricul de urmărire"],
                            "RU" : [RU, "Отслеживание", "Выберите тему", "Выбирать", "История", "История отслеживания"],
                            "UK" : [UK, "Відстеження", "Виберіть Тема", "Виберіть", "Історія", "Історія відстеження"]
                        ]
    
                        let singleTrackingObj = Tracking(EN: EN, RO: RO, RU: RU, UK: UK, idx: self.objectiveIdx, object_name: object_name, school_idx: school_idx, stars: stars)
                        
                        self.trackingObjectives.append(singleTrackingObj)
                    }
                    
                    if warning == 1 {
                        self.warning_message = dict.value(forKey: "warning_message") as? String ?? ""
                        //print(warning_message)
                    }
                    
                    print(self.trackingObjectives)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getTrackingHistory(objectiveIdx: String) {
        let parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent",
            "student_idx": studentIdx,
            "objective_idx": objectiveIdx
        ]
        
        AF.request(URL_GET_TRACKING_HISTORY, method: .post, parameters: parameters).responseJSON { response in
            
            //print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    
                    self.trackingHistory = []
                    self.historyArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.historyArray {
                        let singleTrackingHistory = obj as! NSDictionary
                        
                        let date = singleTrackingHistory.value(forKey: "date") as? String ?? ""
                        let evaluation_mark = singleTrackingHistory.value(forKey: "evaluation_mark") as? String ?? ""
                        let idx = singleTrackingHistory.value(forKey: "idx") as? String ?? ""
                        let target = singleTrackingHistory.value(forKey: "target") as? String ?? ""
                        
                        let singleTrackingHistoryObj = History(date: date, evaluation_mark: evaluation_mark, idx: idx, target: target)
                        
                        self.trackingHistory.append(singleTrackingHistoryObj)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func starColor(stars: String) -> Color {
        
        if (stars == "1") {
            return Color.red
        } else if (stars == "2") {
            return Color.orange
        } else if (stars == "3") {
            return Color.green
        } else if (stars == "4") {
            return Color.blue
        }
        return Color.red
    }
    
    func barHeight(stars: String) -> CGFloat {
        
        if (stars == "1") {
            return 50
        } else if (stars == "2") {
            return 150
        } else if (stars == "3") {
            return 250
        } else if (stars == "4") {
            return 350
        }
        return 0
    }
}
