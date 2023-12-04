//
//  ChildrenViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire
import LocalAuthentication

class ChildrenViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var children: [Children] = []
    
    private var childrenArray: NSArray = []
    
    @Published var totalNotificationsArray: [Int] = []
    
    @Published var appUnlocked = false
    @Published var authorizationError: Error?
    
    func getChildren() {
        let parameters: Parameters = [
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "idx": defaults.string(forKey: "user_idx")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_CHILDREN, method: .post, parameters: parameters).responseJSON { response in
            
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.children = []
                    self.totalNotificationsArray = []
                    
                    for index in stride(from: 0, to: dict.count-1, by: 1) {
                        let item = dict.value(forKey: String(index)) as! NSDictionary
                            
                        let fullName = item.value(forKey: "fullname") as? String ?? ""
                        let schoolName = item.value(forKey: "school") as? String ?? ""
                        let className = item.value(forKey: "class") as? String ?? ""
                        let childPhoto = item.value(forKey: "photo") as? String ?? ""
                        let count = item.value(forKey: "count") as? String ?? ""
                        let childUserIdx = item.value(forKey: "user_idx") as? String ?? ""
                        
                        let oneChild = Children(className: className, count: count, fullName: fullName, childPhoto: childPhoto, school: schoolName, childUserIdx: childUserIdx)
                        self.children.append(oneChild)
                        self.totalNotificationsArray.append(0)
                    }
                }
                
                if self.children.count > 0 {
                    for child in self.children {
                        self.loadBadgesForEachStudent(studentIdx: child.childUserIdx)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadBadgesForEachStudent(studentIdx: String) {
        let defaults = UserDefaults.standard
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "parent_idx": defaults.string(forKey: "user_idx")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_BADGE_COUNTERS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                if dict.value(forKey: "error") as? Int == 0 {
                    self.totalNotificationsArray = []
                    
                    let counters = dict.value(forKey: "counters") as? NSArray ?? nil
                    let codes = dict.value(forKey: "module_codes") as? NSArray ?? nil
                    
                    if counters != nil && codes != nil {
                        if counters!.count == codes!.count && counters!.count > 0 {
                            if self.children.count > 0 {
                                for i in 0..<self.children.count {
                                    self.totalNotificationsArray.append(0)
                                    if self.children[i].childUserIdx == studentIdx {
                                        for j in 0...counters!.count - 1 {
                                            self.totalNotificationsArray[i] = self.totalNotificationsArray[i] + (Int(counters?[j] as? String ?? "") ?? 0)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    print(self.totalNotificationsArray)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestBiometricUnlock() {
        print("it Wroks!")
        let context = LAContext()

        var error: NSError? = nil

        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)

        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "To access your data") { (success, error) in
                    DispatchQueue.main.async {
                        self.appUnlocked = success
                        self.authorizationError = error
                        print(self.appUnlocked)
                    }
                }
            } else {
                
            }
        }
    }
}

