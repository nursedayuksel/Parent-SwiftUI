//
//  MessageImagePicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import Foundation
import UIKit
import SwiftUI

struct MessageImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var messagingViewModel: MessagingViewModel
    var sourceType: UIImagePickerController.SourceType?
    
      class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
          var parent: MessageImagePicker
          
          init(_ parent: MessageImagePicker) {
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
                  
                  parent.messagingViewModel.fileType = "image"
                  parent.messagingViewModel.linkOfFile = URL(string: "1")
                  parent.messagingViewModel.selectedImage = uiImage
                  parent.messagingViewModel.buttonTitle = imageName
                  parent.messagingViewModel.imageURL = imageUrl
                  
                  print("printing...")
                  print(parent.messagingViewModel.buttonTitle)

                  parent.presentationMode.wrappedValue.dismiss()
              }
          }
      }
      
      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }
      

      func makeUIViewController(context: UIViewControllerRepresentableContext<MessageImagePicker>) -> UIImagePickerController {
          let picker = UIImagePickerController()
          picker.delegate = context.coordinator
          picker.sourceType = sourceType ?? .photoLibrary
          return picker
      }

      func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<MessageImagePicker>) {
     
      }
}
