//
//  EmailViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class EmailViewModel: ObservableObject {
    
    let defaults = UserDefaults.standard
    
    var emailArray: NSArray = []
    var idx = ""
   
    var originalIdsArray: [String] = []
    @Published var copyIdsArray: [String] = []

    @Published var studentEmails: [Email] = []
    
    @Published var readEmailsCount = 0
    @Published var unreadEmailsCount = 0
    
    @Published var showEmailsFirstViewLoad: Bool = false
    
    @Published var fileType = ""
    @Published var selectedImage = UIImage()
    @Published var imageURL: URL? = nil
    @Published var linkOfFile: URL? = nil
    @Published var fileExtension = ""
    @Published var buttonTitle = ""
    
    var html = ""
    
    func getEmails() {
        self.resetBadge(table: "compose_messages_and_emails", studentIdx: studentIdx)
        let parameters = [
            "db": defaults.value(forKey: "db") as! String,
            "student_idx": studentIdx,
            "school_group":  defaults.value(forKey: "school_group") as! String,
            "user_idx": defaults.value(forKey: "user_idx") as! String,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_EMAIL, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.studentEmails = []
                    self.emailArray = dict.value(forKey: "data") as! NSArray
                    
                    //print(self.emailArray)
                    
                    self.showEmailsFirstViewLoad = true
                    UserDefaults.standard.setValue(self.showEmailsFirstViewLoad, forKey: "show")
                    
                    
                    let idsString = UserDefaults.standard.string(forKey: "savedEmailsIdd") ?? ""
                    self.originalIdsArray = idsString.components(separatedBy: ";")
                    
                    var totalCount = 0
                    
                    self.readEmailsCount = 0
                    for obj in self.emailArray {
                        let singleObject = obj as! NSDictionary
                        
                        let attachment = singleObject.value(forKey: "attachments") as? String ?? ""
                        let create_date = singleObject.value(forKey: "create_date") as? String ?? ""
                        let date_for_display = singleObject.value(forKey: "date_for_display") as? String ?? ""
                        self.idx = singleObject.value(forKey: "idx") as? String ?? ""
                        let message = singleObject.value(forKey: "message") as? String ?? ""
                        let subject = singleObject.value(forKey: "subject") as? String ?? ""
                        let name = singleObject.value(forKey: "name") as? String ?? ""
                        let surname = singleObject.value(forKey: "surname") as? String ?? ""
                        let photo = singleObject.value(forKey: "photo") as? String ?? ""
                        let emailUserIdx = singleObject.value(forKey: "email_user_idx") as? String ?? ""

                        for item in self.originalIdsArray {
                            if item == self.idx && item != "" {
                                self.readEmailsCount += 1
                            }
                        }
                        
                        totalCount += 1

                        let singleStudentEmail = Email(idx: self.idx, subject: subject, message: message, create_date: create_date, date_for_display: date_for_display, attachments: attachment, name: name, surname: surname, senderPhoto: photo, emailUserIdx: emailUserIdx)
                        
                        self.studentEmails.append(singleStudentEmail)
                    }
                    self.unreadEmailsCount = totalCount - self.readEmailsCount
                    print(self.unreadEmailsCount)
                    
                    if self.studentEmails.count > 0 {
                        self.readSingleEmail(email: self.studentEmails[0])
                    }
                }

            case .failure(let error):
                print(error)
            }
        }
    }
    
    var path = ""
    @Published var messageUrl = ""
    func readSingleEmail(email: Email) {
        let parameters = [
            "db": defaults.value(forKey: "db") as! String,
            "school_group": defaults.string(forKey: "school_group")!,
            "email_idx": email.idx
        ]
        
        AF.request(URL_GET_SINGLE_EMAIL, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.html = dict.value(forKey: "message") as! String
   
                    if email.attachments != "" {
                        let jsonData = email.attachments.data(using: .utf8)!
                        do {
                            if let attachments = try JSONSerialization.jsonObject(with: jsonData, options: .fragmentsAllowed) as? [Dictionary<String, Any>] {
                                for i in 0...attachments.count - 1 {
                                    
                                    self.html = self.html + "<br/><span style='color:red; font-size:2.7em'>" + "Tap to view, long-press for other options:" + "</span><br/>"
                                    
                                    let singleAttachment = attachments[i] as NSDictionary
                                    let mainDb = self.defaults.string(forKey: "school_group") ?? ""
                                    
                                    let pathTail = singleAttachment.value(forKey: "path") as? String ?? ""
                                    let path = "https://attach.my-educare.com/attachments/" + mainDb + "/" + pathTail
                                    
                                    let myString = "<br/><a style='font-size:2.7em' href='" + path + "'>" + "DOWNLOAD ATTACHMENT" + " " + String(i+1) + "</a><br/>";
                                    
                                    self.html = self.html + myString
                                }
                            } else {
                                print("bad json")
                            }
                        } catch let e {
                            print("Failed to convert data \(e)")
                        }
                    }
                    self.messageUrl = self.html
                    print(self.messageUrl)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendReply(emailIdx: String, replyText: String, recipientUserIdx: String) {
        let parameters = [
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "reply_text": replyText,
            "user_idx": defaults.string(forKey: "user_idx")!,
            "school_idx": defaults.string(forKey: "school_idx")!,
            "email_idx": emailIdx,
            "recipient_user_idx": recipientUserIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
            
            if self.fileType == "image" {
                let imgData = self.selectedImage.jpegData(compressionQuality: 0.5)
                if imgData != nil && self.imageURL != nil {
                    multipartFormData.append(imgData!, withName: "attachment", fileName: "reply.png", mimeType: "image/png")
                }
            }
            
            if self.fileType == "document" {
                if self.linkOfFile != nil {
                    multipartFormData.append(self.linkOfFile!, withName: "attachment", fileName: "reply." + self.fileExtension, mimeType: "application/pdf")
                }
            }
        }, to: URL_REPLY_EMAIL)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let JSON):
                if self.fileType == "image" {
                    self.selectedImage = UIImage()
                }
                
                if self.fileType == "document" {
                    self.linkOfFile = nil
                }
                print("response is: \(JSON)")
                
            case .failure(let error):
                print(error)
            }
        })
    }

    func emailStatus(emailIdx: String) {
        let savedIds = UserDefaults.standard.string(forKey: "savedEmailsIdd") ?? ""
        var emailIdsArray = savedIds.components(separatedBy: ";")
        print(emailIdsArray)

        if emailIdsArray[0] == ""
        {
            emailIdsArray = []
        }
        var idFound = false
        for item in emailIdsArray
        {
            if item == emailIdx
            {
                idFound = true
            }
        }

        print(emailIdsArray)

        if !idFound
        {
            emailIdsArray.append(emailIdx)
        }
        print(emailIdsArray)

        let newStr = emailIdsArray.joined(separator: ";")
        UserDefaults.standard.setValue(newStr, forKey: "savedEmailsIdd")
        
        print("before read emails count \(readEmailsCount)")
        print("before unread emails count \(unreadEmailsCount)")
        print(emailIdsArray)
        
        readEmailsCount = emailIdsArray.count
        unreadEmailsCount = studentEmails.count - readEmailsCount
        
        print("after read emails count \(readEmailsCount)")
        print("after unread emails count \(unreadEmailsCount)")

    }
    
    func filterColors(status: String) -> Color {
        if status == "All" {
            return .blue
        } else if status == "Read" {
            return .green
        } else {
            return .red
        }
    }
    
    func filterEmails(emailStatus: String) {

        let savedIds = UserDefaults.standard.string(forKey: "savedEmailsIdd") ?? ""
        let emailIdsArray = savedIds.components(separatedBy: ";")
        
        copyIdsArray = []
        
        if emailStatus == "All" {
            for studentEmail in studentEmails {
                copyIdsArray.append(studentEmail.idx)
            }
            
        } else if emailStatus == "Read" {
            for studentEmail in studentEmails {
                if emailIdsArray.contains(studentEmail.idx){
                    copyIdsArray.append(studentEmail.idx)
                }
            }
            
        } else if emailStatus == "Unread" {
            for studentEmail in studentEmails {
                if !emailIdsArray.contains(studentEmail.idx){
                    copyIdsArray.append(studentEmail.idx)
                }
            }
        }
    }
    
    func emailStatusColor(idx: String) -> Color {
        
        let savedIds = UserDefaults.standard.string(forKey: "savedEmailsIdd") ?? ""
        let emailIdsArray = savedIds.components(separatedBy: ";")
        
        if emailIdsArray.contains(idx) {
            return Color.clear
        } else {
            return Color.red
        }
    }
}

