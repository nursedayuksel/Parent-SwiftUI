//
//  DocumentPicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var homeworkViewModel: HomeworkViewModel
    @Binding var buttonNumber: Int
    @Binding var documentUrl: URL?
    
    class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileURL = urls.first else {
                return
            }
            let fileExtension: String = String(fileURL.pathExtension)
           
            if parent.buttonNumber == 1 {
                parent.homeworkViewModel.firstButtonFileType = "document"
                parent.homeworkViewModel.linkOfFirstFile = fileURL
                parent.homeworkViewModel.firstFileExtension = fileExtension
                parent.homeworkViewModel.firstButtonTitle = fileURL.lastPathComponent
            }
            else if parent.buttonNumber == 2 {
                parent.homeworkViewModel.secondButtonFileType = "document"
                parent.homeworkViewModel.linkOfSecondFile = fileURL
                parent.homeworkViewModel.secondFileExtension = fileExtension
                parent.homeworkViewModel.secondButtonTitle = fileURL.lastPathComponent
            }
            else if parent.buttonNumber == 3 {
                parent.homeworkViewModel.thirdButtonFileType = "document"
                parent.homeworkViewModel.linkOfThirdFile = fileURL
                parent.homeworkViewModel.thirdFileExtension = fileExtension
                parent.homeworkViewModel.thirdButtonTitle = fileURL.lastPathComponent
            }
            
            print("printing...")
            print(parent.homeworkViewModel.firstButtonTitle)

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker: UIDocumentPickerViewController
        
        if #available(iOS 14, *) {
            picker = UIDocumentPickerViewController(forOpeningContentTypes: [.data, .text], asCopy: true)
        } else {
            picker = UIDocumentPickerViewController(documentTypes: ["public.text", "com.apple.iwork.pages.pages", "public.data"], in: .import)
        }
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
}

