//
//  MessagingViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

class MessagingViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var teacherList: [Teacher] = []
    @Published var messages: [Message] = []
    
    private var teacherListArray: NSArray = []
    private var messagesArray: NSArray = []
    
    @Published var fileType = ""
    @Published var selectedImage = UIImage()
    @Published var imageURL: URL? = nil
    @Published var linkOfFile: URL? = nil
    @Published var fileExtension = ""
    @Published var buttonTitle = ""
    
    @Published var messageToBeSent = ""
    
    @Published var showingDeleteAlert = false
    
    @Published var animate = 0.0
    
    var messageCountersArray: [String] = []
    var messageCounterTeachersArray: [String] = []
    var messageIsTeacherArray: [String] = []
    
    @Published var messageNotifsDict: [String: String] = [:]
    @Published var messageIsTeacherDict: [String: String] = [:]
    
    @Published var selectedAttachment = ""
    @Published var selectedFileName = ""
    @Published var selectedPathExtension = ""
    @Published var selectedMessageIdx = ""

    func loadTeachersList() {
        getMessageCounter()
        let parameters: Parameters = [
            "student_idx": studentIdx,
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "module": "in_app",
            "app_name": "ios/parent"
        ]
        
        print(parameters)
         
        AF.request(URL_GET_TEACHERS_LIST, method: .post, parameters: parameters).responseJSON { response in
             print(response)
            
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.teacherListArray = dict.value(forKey: "data") as! NSArray
                
                self.teacherList = []
                
                if error == 0 {
                    for obj in self.teacherListArray {
                        let singleTeacher = obj as! NSDictionary
                        
                        let teacherName = singleTeacher.value(forKey: "teacher") as? String ?? ""
                        let teacherPhoto = singleTeacher.value(forKey: "photo") as? String ?? ""
                        let teacherIdx = singleTeacher.value(forKey: "teacher_idx") as? String ?? ""
                        let subject = singleTeacher.value(forKey: "subject") as? String ?? ""
                        let link = singleTeacher.value(forKey: "link") as? String ?? ""
                        let lastMessage = singleTeacher.value(forKey: "last_message") as? String ?? ""
                        let lastMessageDate = singleTeacher.value(forKey: "last_date") as? String ?? ""
                        let isTeacher = singleTeacher.value(forKey: "is_teacher") as? String ?? ""
                        
                        let oneTeacher = Teacher(teacherName: teacherName, teacherPhoto: teacherPhoto, teacherIdx: teacherIdx, subject: subject, link: link, lastMessage: lastMessage, lastMessageDate: lastMessageDate, isTeacher: isTeacher)
                        self.teacherList.append(oneTeacher)
                        
                        //self.getMessages(teacherIdx: self.teacherList[0].teacherIdx, isTeacher: self.teacherList[0].isTeacher)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMessages(teacherIdx: String, isTeacher: String) {
        self.resetMessageCounter(teacherIdx: teacherIdx)
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "sender_idx": defaults.string(forKey: "user_idx")!,
            "receiver_idx": teacherIdx,
            "student_idx": studentIdx,
            "is_teacher": isTeacher,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_MESSAGES, method: .post, parameters: parameters).responseJSON { response in
           //print("INAPP: \(response)")
          
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                let error = dict.value(forKey: "error") as? Int ?? 1
                self.messagesArray = dict.value(forKey: "data") as! NSArray
                
                self.messages = []
                
                if error == 0 {
                    for obj in self.messagesArray {
                        let singleMessage = obj as! NSDictionary
                        
                        let date = singleMessage.value(forKey: "date") as? String ?? ""
                        let dateDisplay = singleMessage.value(forKey: "date_display") as? String ?? ""
                        let messageIdx = singleMessage.value(forKey: "idx") as? String ?? ""
                        let message = singleMessage.value(forKey: "message") as? String ?? ""
                        let receiverIdx = singleMessage.value(forKey: "receiver_idx") as? String ?? ""
                        let senderIdx = singleMessage.value(forKey: "sender_idx") as? String ?? ""
                        let time = singleMessage.value(forKey: "time") as? String ?? ""
                        let timeDisplay = singleMessage.value(forKey: "time_display") as? String ?? ""
                        let attachment = singleMessage.value(forKey: "attachment") as? NSString ?? ""
                        let pathExtension = attachment.pathExtension
                        let fileName = singleMessage.value(forKey: "file_name") as? String ?? ""
                        let softDelete = singleMessage.value(forKey: "soft_delete") as? String ?? ""
                        
                        // -- DATE FORMATTER START -- //
                        let fmt = DateFormatter()
                        fmt.locale = Locale(identifier: "en_US_POSIX")
                        fmt.dateFormat = "dd-MM-yyyy"

                        // first, convert string to Date
                        let dt = fmt.date(from: dateDisplay)!

                        // then convert Date back to String in a different format
                        fmt.dateFormat = "dd MMM"
                        let convertedMessageDate = fmt.string(from: dt)
                        // -- END -- //
                        
                        let oneMessage = Message(date: date, dateDisplay: convertedMessageDate, messageIdx: messageIdx, message: message, receiverIdx: receiverIdx, senderIdx: senderIdx, time: time, timeDisplay: timeDisplay, attachment: attachment as String, pathExtension: pathExtension, fileName: fileName, softDelete: softDelete)
                        
                        self.messages.append(oneMessage)
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func sendMessage(teacherIdx: String, isTeacher: String) {
        let parameters = [
            "db": defaults.string(forKey: "db")!,
            "school_group": defaults.string(forKey: "school_group")!,
            "receiver_idx": teacherIdx,
            "sender_idx": defaults.string(forKey: "user_idx")!,
            "message": messageToBeSent,
            "student_idx": studentIdx,
            "is_teacher": isTeacher,
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
                    multipartFormData.append(imgData!, withName: "attachment", fileName: "attachment.png", mimeType: "image/png")
                    multipartFormData.append(self.imageURL!.lastPathComponent.data(using: String.Encoding.utf8)!, withName: "file_name")
                }
            }
            
            if self.fileType == "document" {
                if self.linkOfFile != nil {
                    multipartFormData.append(self.linkOfFile!, withName: "attachment", fileName: "attachnment." + self.fileExtension, mimeType: "application/pdf")
                    multipartFormData.append(self.linkOfFile!.lastPathComponent.data(using: String.Encoding.utf8)!, withName: "file_name")
                }
            }
        }, to: URL_SEND_MESSAGE)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let JSON):
                self.getMessages(teacherIdx: teacherIdx, isTeacher: isTeacher)
                self.messageToBeSent = ""
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
    
    func deleteMessage(messageIdx: String, teacherIdx: String, isTeacher: String) {
        let parameters : Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "message_idx": messageIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_DELETE_MESSAGE, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let jsonData = JSON as! NSDictionary
                let error = jsonData.value(forKey: "error") as? Int ?? 1
                if error == 0
                {
                    self.getMessages(teacherIdx: teacherIdx, isTeacher: isTeacher)
                } else {
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getMessageCounter() {
        let parameters: Parameters = [
            "db": UserDefaults.standard.string(forKey: "db")!,
            "parent_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "school_group": UserDefaults.standard.string(forKey: "school_group")!,
            "student_idx" : studentIdx,
            "caller_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_MESSAGE_COUNTER, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.messageCountersArray = []
                    self.messageCounterTeachersArray = []
                    
                    self.messageCountersArray = dict.value(forKey: "counter") as! NSArray as! [String]
                    self.messageCounterTeachersArray  = dict.value(forKey: "teachers") as! NSArray as! [String]
                    self.messageIsTeacherArray = dict.value(forKey: "is_teacher") as! NSArray as! [String]
                    
                    for i in 0..<self.messageCountersArray.count {
                        self.messageNotifsDict[self.messageCounterTeachersArray[i]] = self.messageCountersArray[i]
                        self.messageIsTeacherDict[self.messageCounterTeachersArray[i]] = self.messageIsTeacherArray[i]
                    }
                    
                    print(self.messageNotifsDict)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func resetMessageCounter(teacherIdx: String)
    {
        let parameters: Parameters = [
            "db" : UserDefaults.standard.string(forKey: "db")!,
            "school_group" : UserDefaults.standard.string(forKey: "school_group")!,
            "receiver_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "sender_idx" : teacherIdx,
            "student_idx" : studentIdx,
            "caller_idx": UserDefaults.standard.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_RESET_MESSAGE_COUNTER, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                self.getMessageCounter()
                self.messageNotifsDict = [:]
                print(JSON)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func filterTeacherList() -> [Teacher] {
        return teacherList.filter{$0.isTeacher == "1"}
    }
    
    func filterSupportList() -> [Teacher] {
        return teacherList.filter{$0.isTeacher == "0"}
    }
    
    func saveDocument(urlString: String, fileName: String) {
        DispatchQueue.main.async {
            guard let url = URL(string: urlString) else {
                return
            }
            let fileData = try? Data.init(contentsOf: url)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let fileNameFromUrl = "MyEduCareApp-\(fileName)"
            let actualPath = resourceDocPath.appendingPathComponent(fileNameFromUrl)
            do {
                try fileData?.write(to: actualPath, options: .atomic)
                print("file saved!")
                
            } catch {
                print("file couldn't be saved!")
            }
        }
    }
    
    func fileAlreadySaved(url: String, fileName: String) -> Bool {
        var status = false
        do {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName)")
                    {
                        status = true
                    }
                }
            } catch {
                print("couldn't locate file!!!!")
            }
        }
        return status
    }

    func downloadPdfFile() -> DocumentWebView {
        if let targetURL = URL(string: selectedAttachment) {
            if let request = try? Data(contentsOf: targetURL) {
                return DocumentWebView(request: request, mimeType: "application/pdf", characterEncodingName: "", baseURL: targetURL)
            }
        }
        
        if !fileAlreadySaved(url: selectedAttachment, fileName: selectedFileName) {
            saveDocument(urlString: selectedAttachment, fileName: selectedFileName)
        }
        
        return DocumentWebView(request: Data(), mimeType: "", characterEncodingName: "", baseURL: URL(string: "")!)
    }
}
