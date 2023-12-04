//
//  EmailImagePicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation
import UIKit
import SwiftUI

struct EmailImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var emailViewModel: EmailViewModel
    var sourceType: UIImagePickerController.SourceType?
    
      class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
          var parent: EmailImagePicker
          
          init(_ parent: EmailImagePicker) {
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
                  
                  parent.emailViewModel.fileType = "image"
                  parent.emailViewModel.linkOfFile = URL(string: "1")
                  parent.emailViewModel.selectedImage = uiImage
                  parent.emailViewModel.buttonTitle = imageName
                  parent.emailViewModel.imageURL = imageUrl
                  
                  print("printing...")
                  print(parent.emailViewModel.buttonTitle)

                  parent.presentationMode.wrappedValue.dismiss()
              }
          }
      }
      
      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }
      

      func makeUIViewController(context: UIViewControllerRepresentableContext<EmailImagePicker>) -> UIImagePickerController {
          let picker = UIImagePickerController()
          picker.delegate = context.coordinator
          picker.sourceType = sourceType ?? .photoLibrary
          return picker
      }

      func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<EmailImagePicker>) {
     
      }
}

