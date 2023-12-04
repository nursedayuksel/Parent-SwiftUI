//
//  ClubViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

var clubTypes: [String] = ["My clubs", "Free", "Paid", "Optional", "Compulsory"]

class ClubViewModel: ObservableObject {
    
    let defaults = UserDefaults.standard
    
    @Published var clubSemesters: [ClubSemesters] = []
    @Published var clubList: [Club] = []
    
    private var clubSemestersArray: NSArray = []
    private var clubListArray: NSArray = []
    
    var clubSemesterNamesArray: [String] = []
    var clubSemesterIdsArray: [String] = []
    var clubTypeArray: [String] = []
    var isMyClubArray: [Int] = []
    var clubFeeTypeArray: [String] = []
    
    var currentSelectedSemesterIdx = ""
    var currentSelectedSemesterName = ""
    
    @Published var selectedTermIndex = 0
    
    @Published var currency = ""
    @Published var fee = ""
    @Published var clubDesc = ""
    @Published var howManyWeeks = ""
    @Published var roomNumber = ""
    @Published var clubDays: [String] = []
    @Published var clubStartHours: [String] = []
    @Published var clubEndHours: [String] = []
    
    @Published var message = ""
    
    func loadSemesters() {
        let parameters = [
            "idx1": studentIdx,
            "db1": defaults.string(forKey: "db")!,
            "app_name": "ios/parent",
            "caller_idx": defaults.string(forKey: "user_idx")!
        ]
        
        AF.request(URL_GET_SEMESTER_FOR_CLUB, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.clubSemestersArray = dict.value(forKey: "data") as! NSArray
                
                self.clubSemesters = []
                self.clubSemesterNamesArray = []
                self.clubSemesterIdsArray = []
                
                if error == 0 {
                    for obj in self.clubSemestersArray {
                        let singleSemester = obj as! NSDictionary
                        
                        let semesterIdx = singleSemester.value(forKey: "idx") as? String ?? ""
                        let termName = singleSemester.value(forKey: "term_name") as? String ?? ""
                        let isSelected = singleSemester.value(forKey: "selected") as? Bool ?? false
                        
                        let oneSemester = ClubSemesters(semesterIdx: semesterIdx, termName: termName, isSelected: isSelected)
                        self.clubSemesters.append(oneSemester)
                        
                        self.clubSemesterNamesArray.append(termName)
                        self.clubSemesterIdsArray.append(semesterIdx)
                        
                        if isSelected {
                            self.currentSelectedSemesterIdx = semesterIdx
                            self.currentSelectedSemesterName = termName
                            self.getClubsList(semester_idx: semesterIdx)
                        } else {
                            self.currentSelectedSemesterName = self.clubSemesterNamesArray[0]
                            self.getClubsList(semester_idx: self.clubSemesters[0].semesterIdx)
                        }
                    }
                    
                    for i in 0..<self.clubSemesters.count {
                        if self.clubSemesters[i].isSelected {
                            self.selectedTermIndex = i
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getClubsList(semester_idx: String) {
        let parameters = [
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "semester_idx": semester_idx,
            "school_idx": defaults.string(forKey: "school_idx")!,
            "db": defaults.string(forKey: "db")!,
            "app_name": "ios/parent",
            "caller_idx": defaults.string(forKey: "user_idx")!
        ]
        AF.request(URL_GET_CLUBS_LIST, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.clubListArray = dict.value(forKey: "data") as! NSArray
                
                self.clubList = []
                self.clubTypeArray = []
                self.isMyClubArray = []
                self.clubFeeTypeArray = []
                
                if error == 0 {
                    for obj in self.clubListArray {
                        let singleClub = obj as! NSDictionary
                        
                        let clubName = singleClub.value(forKey: "club_name") as? String ?? ""
                        let clubType = singleClub.value(forKey: "club_type") as? String ?? ""
                        let dayOfClub = singleClub.value(forKey: "day_of_club") as? String ?? ""
                        let feeType = singleClub.value(forKey: "fee_type") as? String ?? ""
                        let clubIdx = singleClub.value(forKey: "idx") as? String ?? ""
                        let isMyClub = singleClub.value(forKey: "is_my_club") as? Int ?? 0
                        let isOpen = singleClub.value(forKey: "is_open") as? String ?? ""
                        let link = singleClub.value(forKey: "link") as? String ?? ""
                        let clubTeacherName = singleClub.value(forKey: "teacher") as? String ?? ""
                        
                        let oneClub = Club(clubName: clubName, clubType: clubType, dayOfClub: dayOfClub, feeType: feeType, clubIdx: clubIdx, isMyClub: isMyClub, isOpen: isOpen, link: link, clubTeacherName: clubTeacherName)
                        
                        self.clubList.append(oneClub)
                        self.clubTypeArray.append(clubType)
                        self.isMyClubArray.append(isMyClub)
                        self.clubFeeTypeArray.append(feeType)
                    }
                    print(self.clubList)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadSingleClub(clubIdx: String) {
        let parameters: Parameters = [
            "club_idx": clubIdx,
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_CLUB_INFO, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    let currency = dict.value(forKey: "currency") as? String ?? ""
                    let fee = dict.value(forKey: "fee") as? String ?? ""
                    
                    if fee == "" {
                        self.fee = "FREE"
                    } else {
                        self.fee = fee + " " + currency
                    }
                    
                    self.howManyWeeks = dict.value(forKey: "how_many_weeks") as? String ?? ""
                    self.clubDesc = dict.value(forKey: "description") as? String ?? ""
                    self.roomNumber = dict.value(forKey: "place") as? String ?? ""
                    
                    let tempString = dict.value(forKey: "days_hours") as! String
                    let data = tempString.data(using: .utf8)!
                    let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? NSDictionary
                    self.clubDays = (json?.value(forKey: "days") as! NSArray) as! [String]
                    self.clubStartHours = (json?.value(forKey: "hours") as! NSArray) as! [String]
                    self.clubEndHours = (json?.value(forKey: "hoursF") as! NSArray) as! [String]
                    
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func registerToClub(busRegIsOn: Bool, clubIdx: String, isMyClub: Int) {
        var busRequest = ""
        var registerToClub = "1"
        
        if busRegIsOn == true {
            busRequest = "1"
        } else {
            busRequest = "0"
        }
        
        if isMyClub == 1 {
            registerToClub = "0"
        }
        
        let parameters: Parameters = [
            "bus_request": busRequest,
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "club_idx": clubIdx,
            "register": registerToClub,
            "parent_user_idx" : defaults.string(forKey: "user_idx")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_REGISTER_TO_CLUB, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                self.message = dict.value(forKey: "message") as? String ?? ""
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func feeTypeColor(feeType: String) -> Color {
        if feeType == "Free" {
            return .orange
        } else {
            return .blue
        }
    }
    
    @ViewBuilder
    func studentRegisteredToClub(studentRegistration: Int) -> some View {
        if studentRegistration == 0 {
            HStack(spacing: 8) {
                Image(systemName: "nosign")
                Text("You are not registered")
                Spacer()
            }
            .padding(5)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .background(Color.gray)
            .cornerRadius(15)
            .frame(maxWidth: .infinity)
        } else if studentRegistration == 1 {
            HStack(spacing: 8 ){
                Image(systemName: "checkmark.circle")
                Text("You are registered")
                Spacer()
            }
            .padding(5)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(15)
            .frame(maxWidth: .infinity)
        }
    }
    
    func clubFiltersCount(clubFilterName: String) -> Int {
        
        if clubFilterName == "My clubs" {
            return self.isMyClubArray.filter{$0 == 1}.count
        } else if clubFilterName == "Free" || clubFilterName == "Paid" {
            return self.clubFeeTypeArray.filter{$0 == clubFilterName}.count
        } else if clubFilterName == "Optional" || clubFilterName == "Compulsory" {
            return self.clubTypeArray.filter{$0 == clubFilterName}.count
        }
        return -1
    }
    
    func filterClubs(clubFilterIndex: Int) -> [Club] {
        if clubFilterIndex == 0 {
            return clubList.filter{$0.isMyClub == 1}
        } else if clubFilterIndex == 1 {
            return clubList.filter{$0.feeType == "Free"}
        } else if clubFilterIndex == 2 {
            return clubList.filter{$0.feeType == "Paid"}
        } else if clubFilterIndex == 3 {
            return clubList.filter{$0.clubType == "Optional"}
        } else {
            return clubList.filter{$0.clubType == "Compulsory"}
        }
    }
    
    func selectedFilterColor(clubFilterName: String) -> (foregroundColor: Color, backgroundColor: Color) {
        if clubFilterName == "My clubs" {
            return (.white, .green)
        } else if clubFilterName == "Free" {
            return (.white, .orange)
        } else if clubFilterName == "Paid" {
            return (.white, .blue)
        } else if clubFilterName == "Optional" {
            return (.white, .red)
        } else {
            return (.white, .purple)
        }
    }
}

