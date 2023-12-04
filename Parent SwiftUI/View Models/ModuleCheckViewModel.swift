//
//  ModuleCheckViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import Alamofire

struct Module {
    var name: String
    var code: Int
    var color: String
    var icon: String
    var badgeLabel: String
}


class ModuleCheckViewModel: ObservableObject {
    var defaults = UserDefaults.standard
    
    @Published var moduleBan: [ModuleBan] = []
    @Published var modules: [Module] = []
    
    private var moduleBanArray: NSArray = []
    
    @Published var moduleDict: [String: Int] = [:]
    
    @Published var moduleBanCode: [String] = []
    
    @Published var moduleBadgeCode: [Int] = []
    @Published var moduleBadgeCounter: [Int: String] = [:]
    
    func getModuleBans() {
        
        for i in 0..<moduleNames.count {
            self.moduleDict[moduleNames[i]] = moduleCodes[i]
        }
        
        print(self.moduleDict)
        
        let parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "school_idx": defaults.string(forKey: "school_idx")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ipad/student"
        ]
        
        AF.request(URL_GET_BANNED_MODULES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.moduleBan = []
                    self.moduleBanCode = []
                    
                    self.moduleBanArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.moduleBanArray {
                        let singleModuleBan = obj as! NSDictionary
                        
                        let banIdx = singleModuleBan.value(forKey: "idx") as? String ?? ""
                        let schoolIdx = singleModuleBan.value(forKey: "schoolIdx") as? String ?? ""
                        let moduleName = singleModuleBan.value(forKey: "module") as? String ?? ""
                        let moduleCode = singleModuleBan.value(forKey: "module_code") as? String ?? ""
                        
                        let oneModuleBan = ModuleBan(idx: banIdx, schoolIdx: schoolIdx, moduleName: moduleName, moduleCode: moduleCode)
                        self.moduleBan.append(oneModuleBan)
                        self.moduleBanCode.append(moduleCode)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadBadges() {
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
                    let counters = dict.value(forKey: "counters") as? NSArray ?? nil
                    
                    let codes = dict.value(forKey: "module_codes") as? NSArray ?? nil
                    if counters != nil && codes != nil {
                        if counters!.count == codes!.count && counters!.count > 0 {
                            for i in 0...counters!.count - 1 {
                                print(counters?[i])
                                self.moduleBadgeCode.append(codes?[i] as? Int ?? 0)
                                self.moduleBadgeCounter[codes?[i] as? Int ?? 0] = counters?[i] as? String ?? ""
                            }
                        }
                        print(self.moduleBadgeCounter)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
