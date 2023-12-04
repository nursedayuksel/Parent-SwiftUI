//
//  LoginViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import OneSignal
import Alamofire
import CommonCrypto
import SwiftUI
import LocalAuthentication

extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
            CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}

class LoginViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    @Published var institutions: [Institutions] = []
    
    var institutionsArray: NSArray = []
    
    @Published var dbNamesArray: [String] = []
    
    @Published var errorMessage = ""
    @Published var error = 0
    
    @Published var loginDetailsAreIncorrect = false
    @Published var shouldGoToNextPage = false
    
    @Published var totalNotifs = 0
    
    @Published var appUnlocked = false
    @Published var authorizationError: Error?
    
    func userLogin(username: String, password: String, school_group: String) {
        let device: OSDeviceState = OneSignal.getDeviceState()
        let userToken = device.userId ?? "1"

        let parameters = [
            "email": username,
            "password": password,
            "logintype": "Parent",
            "token": userToken,
            "school_group": school_group,
            "caller_idx": "-1",
            "app_name": "ios/parent",
        ]
        
        print(parameters)
        
        AF.request(URL_USER_LOGIN, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.error = error
                let errorMessage = dict.value(forKey: "error_message") as? String ?? ""
                self.errorMessage = errorMessage
                
                let fullName = dict.value(forKey: "full_name") as? String ?? ""
                let photo = dict.value(forKey: "photo") as? String ?? ""
                let db = dict.value(forKey: "db") as? String ?? ""
                let school_year = dict.value(forKey: "year") as? String ?? ""
                let school_idx = dict.value(forKey: "school_idx") as? String ?? ""
                let role_idx = dict.value(forKey: "role_idx") as? String ?? ""
                let email = dict.value(forKey: "email") as? String ?? ""
                let school_name = dict.value(forKey: "school_name") as? String ?? ""
                
                
                let rolled_idx = dict.value(forKey: "rolled_idx") as? String ?? ""
                if rolled_idx == ""
                {
                    self.defaults.setValue(dict.value(forKey: "user_idx") as? String ?? "", forKey: "user_idx")
                } else {
                    self.defaults.setValue(rolled_idx, forKey: "user_idx")
                }
                
                self.defaults.setValue(fullName, forKey: "full_name")
                self.defaults.setValue(photo, forKey: "photo")
                self.defaults.setValue(db, forKey: "db")
                self.defaults.setValue(school_year, forKey: "school_year")
                self.defaults.setValue(school_idx, forKey: "school_idx")
                self.defaults.setValue(school_group, forKey: "school_group")
                self.defaults.setValue(role_idx, forKey: "role_idx")
                self.defaults.setValue(email, forKey: "email")
                self.defaults.setValue(school_name, forKey: "school_name")
                
                // we set these back to empty strings whenever a user logs in so that the read email and report count doesnt accumulate
                self.defaults.setValue("", forKey: "savedEmailsIdd")
                self.defaults.setValue("", forKey: "savedReportsIdd")
                
                if self.error == 1 {
                    self.loginDetailsAreIncorrect = true
                    self.errorMessage = errorMessage
                    self.shouldGoToNextPage = false
                    UserDefaults.standard.set("false", forKey: "is___logged1")
                    UserDefaults.standard.set("false", forKey: "logged")
                } else {
                    self.requestBiometricUnlock()
                    self.shouldGoToNextPage = true
                }
                
                self.getMessageCounter()

            case .failure(let error):
                print(error)
            }
        }
    }
    
    func userLogout() {
        let device: OSDeviceState = OneSignal.getDeviceState()
        let userToken = device.userId!
        let parameters : Parameters = [
            "school_group": defaults.string(forKey: "school_group") ?? "",
            "db": defaults.string(forKey: "db")!,
            "user_type": "Parent",
            "token": userToken,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_USER_LOGOUT, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(_):
                UserDefaults.standard.set("false", forKey: "is___logged1")
                UserDefaults.standard.set("false", forKey: "logged")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getInstitutionNames() {
        let str = "mltR2rvWDYwpz0BsNr52yhIwLf2KZq9VjcL0zjgl"
        let parameters = [
            "request": str.md5,
            "caller_idx": "-1",
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_COUNTRY, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as! String
                if error == "0" {
                    self.institutions = []
                    self.institutionsArray = dict.value(forKey: "data") as! NSArray
                    print(self.institutionsArray)
                    
                    for obj in self.institutionsArray {
                        let singleInstitution = obj as! NSDictionary
                        let db = singleInstitution.value(forKey: "db") as? String ?? ""
                        let dbName = singleInstitution.value(forKey: "name") as? String ?? ""
        
                        let oneInstitution = Institutions(db: db, dbName: dbName)
                        self.institutions.append(oneInstitution)
                        self.dbNamesArray.append(dbName)
                    }
                    
                    self.institutions.insert(Institutions(db: "-1", dbName: "SELECT INSTITUTION"), at: 0)
                    self.dbNamesArray.insert("SELECT INSTITUTION", at: 0)
                    
                    print(self.dbNamesArray)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMessageCounter() {
        let parameters: Parameters = [
            "db": UserDefaults.standard.string(forKey: "db")!,
            "parent_idx": UserDefaults.standard.string(forKey: "user_idx") ?? "",
            "school_group": UserDefaults.standard.string(forKey: "school_group")!,
            "student_idx" : UserDefaults.standard.string(forKey: "user_idx")!,
            "caller_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_MESSAGE_COUNTER, method: .post, parameters: parameters).responseJSON { response in
           // print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.totalNotifs = dict.value(forKey: "total") as? Int ?? 0
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
                        print(self.authorizationError)
                    }
                }
            } else {}
        }
    }
}
