//
//  FeedbackViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 27.04.2023.
//

import Foundation
import Alamofire
import SwiftUI

enum ActiveSaveFeedbackAlert {
    case success, failure
}

class FeedbackViewModel: ObservableObject {
    let defaults = UserDefaults.standard
    
    @Published var feedbackTextField = ""
    
    @Published var showDetailClicked = true
    
    @Published var fileType = ""
    @Published var selectedImage = UIImage()
    @Published var imageURL: URL? = nil
    @Published var linkOfFile: URL? = nil
    @Published var fileExtension = ""
    @Published var buttonTitle = ""
    
    @Published var activeAlert: ActiveSaveFeedbackAlert = .success
    
    @Published var feedbackSaveMessage = ""
    
    func sendFeedback() {
        let parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "school_idx": defaults.string(forKey: "school_idx")!,
            "user_idx": defaults.string(forKey: "user_idx")!,
            "role_idx": defaults.string(forKey: "role_idx")!,
            "show_detail": String(showDetailClicked),
            "feedback": feedbackTextField,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(Data(value.utf8), withName: key)
            }
            
            if self.fileType == "image" {
                let imgData = self.selectedImage.jpegData(compressionQuality: 0.5)
                if imgData != nil && self.imageURL != nil {
                    multipartFormData.append(imgData!, withName: "attachment", fileName: "attachment.png", mimeType: "image/png")
                }
            }
            
            if self.fileType == "document" {
                if self.linkOfFile != nil {
                    multipartFormData.append(self.linkOfFile!, withName: "attachment", fileName: "attachnment." + self.fileExtension, mimeType: "application/pdf")
                }
            }
            
        }, to: URL_SEND_FEEDBACK)
        .responseJSON(completionHandler: { response in
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                self.feedbackSaveMessage = dict.value(forKey: "message") as? String ?? ""
                
                if error == 0 {
                    self.activeAlert = .success
                } else {
                    self.activeAlert = .failure
                }
                print("response is: \(JSON)")
            case .failure(let error):
                print(error)
            }
        })
    }
}
