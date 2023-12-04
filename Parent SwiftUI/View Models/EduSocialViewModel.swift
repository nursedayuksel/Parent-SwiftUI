//
//  EduSocialViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 04.09.2023.
//

import Foundation
import Alamofire
import PhotosUI
import _PhotosUI_SwiftUI
import AVFoundation

class EduSocialViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var edusocialPosts: [EduSocialPosts] = []
    
    private var edusocialCoursesArray: NSArray = []
    private var edusocialPostsArray: NSArray = []
    private var edusocialLikesArray: NSArray = []
    
    @Published var selectedCourseName = ""
    @Published var selectedCourseIdx = ""
    
    @Published var imageIdentifierArray: [String] = []
    
    @Published var uploadedImagesArray: [String] = []
    
    @Published var edusocialAttachmentsDict: [String: [String]] = [:]
    
    @Published var edusocialDeleteMessage = ""
    @Published var deletePostSuccess = false
    
    @Published var likedPostsArray: [String] = []
    
    var uploadData: [Data] = []
    
    var lastIndex = 0
    
    func getEduSocialPosts() {
        let parameters: Parameters = [
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "teacher_idx": "",
            "course_idx": "",
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "student_idx": studentIdx,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_EDUSOCIAL_POSTS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.edusocialPosts = []
                    //self.uploadedImagesArray = []
                    self.edusocialAttachmentsDict = [:]
                    
                    self.edusocialPostsArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.edusocialPostsArray {
                        let singlePost = obj as! NSDictionary
                        
                        let postIdx = singlePost.value(forKey: "idx") as? String ?? ""
                        let teacherIdx = singlePost.value(forKey: "sent_teacher") as? String ?? ""
                        let teacherPhoto = singlePost.value(forKey: "teacher_photo") as? String ?? ""
                        let teacherName = singlePost.value(forKey: "teacher_name") as? String ?? ""
                        let message = singlePost.value(forKey: "message") as? String ?? ""
                        let attachments = singlePost.value(forKey: "attachments") as? String ?? ""
                        let postDate = singlePost.value(forKey: "post_date") as? String ?? ""
                        let postTime = singlePost.value(forKey: "post_time") as? String ?? ""
                        let messageGroup = singlePost.value(forKey: "message_group") as? String ?? ""
                        let title = singlePost.value(forKey: "title") as? String ?? ""
                        let subject = singlePost.value(forKey: "subject") as? String ?? ""
                        
                        self.uploadedImagesArray = attachments.components(separatedBy: ";")
                        self.edusocialAttachmentsDict[postIdx] = self.uploadedImagesArray

                        // Create Date Formatter
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateFormat = "yyyyMMdd"
                        
                        // Convert string to date
                        let convertedDate = dateFormatter.date(from: postDate)
                        
                        dateFormatter.dateFormat = "dd MMM yyyy"

                        // Convert Date to String
                        let convertedStringDate = dateFormatter.string(from: convertedDate!)
                        
                        let onePost = EduSocialPosts(postIdx: postIdx, teacherIdx: teacherIdx, teacherPhoto: teacherPhoto, teacherName: teacherName, message: message, attachments: attachments, postDate: convertedStringDate, postTime: postTime, imagesArray: self.uploadedImagesArray, messageGroup: messageGroup, title: title, subject: subject)
                        self.edusocialPosts.append(onePost)
                        self.uploadedImagesArray = []
                    }
                    print(self.edusocialAttachmentsDict)
                    
                    self.getEduSocialLikes()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func likePost(postIdx: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "post_idx": postIdx,
            "user_idx": defaults.string(forKey: "user_idx")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_EDUSOCIAL_LIKE_POST, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                print(JSON)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getEduSocialLikes() {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_EDUSOCIAL_LIKES, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.likedPostsArray = []
                    
                    self.edusocialLikesArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.edusocialLikesArray {
                        let singleLike = obj as! NSDictionary
                        
                        let postIdx = singleLike.value(forKey: "post_idx") as? String ?? ""
                        self.likedPostsArray.append(postIdx)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
