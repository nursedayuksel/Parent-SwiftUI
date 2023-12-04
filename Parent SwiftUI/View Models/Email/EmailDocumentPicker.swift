//
//  EmailDocumentPicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import Foundation
import SwiftUI

struct EmailDocumentPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var emailViewModel: EmailViewModel
    @Binding var documentUrl: URL?
    
    class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        let parent: EmailDocumentPicker
        
        init(_ parent: EmailDocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileURL = urls.first else {
                return
            }
            let fileExtension: String = String(fileURL.pathExtension)

            parent.emailViewModel.fileType = "document"
            parent.emailViewModel.linkOfFile = fileURL
            parent.emailViewModel.fileExtension = fileExtension
            parent.emailViewModel.buttonTitle = fileURL.lastPathComponent
            
            print("printing...")
            print(fileURL.lastPathComponent)

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<EmailDocumentPicker>) -> UIDocumentPickerViewController {
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
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<EmailDocumentPicker>) {
    }
}

