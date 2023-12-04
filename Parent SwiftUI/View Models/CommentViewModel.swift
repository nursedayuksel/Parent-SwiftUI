//
//  CommentViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class CommentViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var commentSemesters: [CommentSemesters] = []
    @Published var comments: [Comments] = []
    @Published var singleComment = ""
    
    private var commentSemestersArray: NSArray = []
    private var commentsArray: NSArray = []
    
    @Published var commentSemesterNamesArray: [String] = []
    
    var currentSelectedSemesterIdx = ""
    var currentSelectedSemesterName = ""
    
    @Published var selectedSemesterIndex = 0
    
    var commentCategoriesArray: [String] = []
    var uniqueCommentCategoriesArray: [String] = []
    
    var commentColorDictionary: [String:Color] = [:]
    
    func getCommentsSemesters() {
        self.resetBadge(table: "student_comments", studentIdx: studentIdx)
        let parameters = [
            "student_idx": studentIdx,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_SEMESTERS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.commentSemestersArray = dict.value(forKey: "data") as! NSArray
                
                self.commentSemesters = []
                
                if error == 0 {
                    
                    for obj in self.commentSemestersArray {
                        let singleSemester = obj as! NSDictionary
                        
                        let semesterIdx = singleSemester.value(forKey: "idx") as? String ?? ""
                        let termName = singleSemester.value(forKey: "term_name") as? String ?? ""
                        let isSelected = singleSemester.value(forKey: "selected") as? Int ?? 0
                        
                        let oneSemester = CommentSemesters(semesterIdx: semesterIdx, termName: termName, isSelected: isSelected)
                        
                        self.commentSemesters.append(oneSemester)
                        self.commentSemesterNamesArray.append(termName)
                        
                        if isSelected == 1 {
                            self.currentSelectedSemesterIdx = semesterIdx
                            self.currentSelectedSemesterName = termName
                        }
                    }
                    
                    for i in 0..<self.commentSemesters.count {
                        if self.commentSemesters[i].isSelected == 1 {
                            self.selectedSemesterIndex = i
                        }
                    }
                    
                    self.getComments(semester_idx: self.currentSelectedSemesterIdx)
                    
                }
            case . failure(let error):
                print(error)
            }
        }
    }
    
    func getComments(semester_idx: String) {
        let parameters = [
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "semester_idx": semester_idx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_COMMENTS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                
                self.comments = []
                self.commentCategoriesArray = []
                
                if error == 0 {
                    self.commentsArray = dict.value(forKey: "data") as! NSArray
                    for obj in self.commentsArray {
                        let singleComment = obj as! NSDictionary
                        
                        let commentDate = singleComment.value(forKey: "date") as? String ?? ""
                        let commentIdx = singleComment.value(forKey: "idx") as? String ?? ""
                        let commentMark = singleComment.value(forKey: "mark") as? String ?? ""
                        let categoryName = singleComment.value(forKey: "category_name") as? String ?? ""
                        let courseName = singleComment.value(forKey: "course") as? String ?? "Administrator"
                        let teacherName = singleComment.value(forKey: "name") as? String ?? "Administrator"
                        let teacherSurname = singleComment.value(forKey: "surname") as? String ?? ""
                        
                        let oneComment = Comments(commentDate: commentDate, commentIdx: commentIdx, commentMark: commentMark, categoryName: categoryName, courseName: courseName, teacherFullName: teacherName + " " + teacherSurname)
                        
                        self.comments.append(oneComment)
                        
                        self.commentCategoriesArray.append(categoryName)
                        self.uniqueCommentCategoriesArray = self.commentCategoriesArray.removeDuplicates()
                        
                        for i in 0..<self.uniqueCommentCategoriesArray.count {
                            if self.uniqueCommentCategoriesArray[i].contains("Negative") || self.uniqueCommentCategoriesArray[i].contains("Red") {
                                self.commentColorDictionary[self.uniqueCommentCategoriesArray[i]] = .red
                            } else if self.uniqueCommentCategoriesArray[i].contains("Positive") || self.uniqueCommentCategoriesArray[i].contains("Green") {
                                self.commentColorDictionary[self.uniqueCommentCategoriesArray[i]] = .green
                            } else {
                                self.commentColorDictionary[self.uniqueCommentCategoriesArray[i]] = .gray
                            }
                        }
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getSingleComment(comment_idx: String) {
        let parameters = [
            "db": defaults.string(forKey: "db")!,
            "comment_idx": comment_idx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_SINGLE_COMMENT, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    let comment = dict.value(forKey: "comment") as? String ?? ""
                    
                    self.singleComment = comment
                }
            case . failure(let error):
                print(error)
            }
        }
    }
    
    func commentCategoriesCount(categoryName: String) -> Int {
        return self.commentCategoriesArray.filter{$0 == categoryName}.count
    }
    
    func filterComments(categoryName: String) -> [Comments] {
        return self.comments.filter{$0.categoryName == categoryName}
    }
}

