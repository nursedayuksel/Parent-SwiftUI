//
//  FeedbackImagePicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 27.04.2023.
//

import Foundation
import UIKit
import SwiftUI

struct FeedbackImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var feedbackViewModel: FeedbackViewModel
    var sourceType: UIImagePickerController.SourceType?
    
      class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
          var parent: FeedbackImagePicker
          
          init(_ parent: FeedbackImagePicker) {
              self.parent = parent
          }
          var imageName: String = "Image"
          
          func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
              var imageName: String = "Image"
              let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL ?? nil
              if imageUrl == nil {
                  imageName = "Camera shot"
              }
              else {
                  imageName = imageUrl!.lastPathComponent
              }
              
              if let uiImage = info[.originalImage] as? UIImage {
                  parent.image = uiImage
                  
                  parent.feedbackViewModel.fileType = "image"
                  parent.feedbackViewModel.linkOfFile = URL(string: "1")
                  parent.feedbackViewModel.selectedImage = uiImage
                  parent.feedbackViewModel.buttonTitle = imageName
                  parent.feedbackViewModel.imageURL = imageUrl
                  
                  print("printing...")
                  print(parent.feedbackViewModel.buttonTitle)

                  parent.presentationMode.wrappedValue.dismiss()
              }
          }
      }
      
      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }
      

      func makeUIViewController(context: UIViewControllerRepresentableContext<FeedbackImagePicker>) -> UIImagePickerController {
          let picker = UIImagePickerController()
          picker.delegate = context.coordinator
          picker.sourceType = sourceType ?? .photoLibrary
          return picker
      }

      func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<FeedbackImagePicker>) {
     
      }
}
