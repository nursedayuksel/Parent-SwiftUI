//
//  BadgesViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 04.05.2023.
//

import Foundation
import Alamofire


class BadgesViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var modules: [Module] = []
    
    func loadBadges() {
        let defaults = UserDefaults.standard
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "database")!,
            "school_group": defaults.string(forKey: "main_db")!,
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
                                let code = codes![i] as? Int ?? 0
                                let counter = counters![i] as? String ?? ""
                                var j = 0
                                for module in self.modules {
                                    if module.code == code {
                                        self.modules[j].badgeLabel = counter
                                    }
                                    j = j + 1
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
