//
//  ImagePicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import Foundation
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var homeworkViewModel: HomeworkViewModel
    @Binding var buttonNumber: Int
    var sourceType: UIImagePickerController.SourceType?
    
      class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
          var parent: ImagePicker
          
          init(_ parent: ImagePicker) {
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

                  if parent.buttonNumber == 1 {
                      parent.homeworkViewModel.firstButtonFileType = "image"
                      parent.homeworkViewModel.linkOfFirstFile = URL(string: "1")
                      parent.homeworkViewModel.firstButtonImage = uiImage
                      parent.homeworkViewModel.firstButtonTitle = imageName
                  }
                  else if parent.buttonNumber == 2 {
                      parent.homeworkViewModel.secondButtonFileType = "image"
                      parent.homeworkViewModel.linkOfSecondFile = URL(string: "1")
                      parent.homeworkViewModel.secondButtonImage = uiImage
                      parent.homeworkViewModel.secondButtonTitle = imageName
                  }
                  else if parent.buttonNumber == 3 {
                      parent.homeworkViewModel.thirdButtonFileType = "image"
                      parent.homeworkViewModel.linkOfThirdFile = URL(string: "1")
                      parent.homeworkViewModel.thirdButtonImage = uiImage
                      parent.homeworkViewModel.thirdButtonTitle = imageName
                  }
                  
                  print("printing...")
                  print(parent.homeworkViewModel.firstButtonTitle)

                  parent.presentationMode.wrappedValue.dismiss()
              }
          }
      }
      
      func makeCoordinator() -> Coordinator {
          Coordinator(self)
      }
      

      func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
          let picker = UIImagePickerController()
          picker.delegate = context.coordinator
          picker.sourceType = sourceType ?? .photoLibrary
          return picker
      }

      func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
     
      }
}

