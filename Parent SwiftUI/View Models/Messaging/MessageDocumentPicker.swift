//
//  MessageDocumentPicker.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import Foundation
import SwiftUI

struct MessageDocumentPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var messagingViewModel: MessagingViewModel
    @Binding var documentUrl: URL?
    
    class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
        let parent: MessageDocumentPicker
        
        init(_ parent: MessageDocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let fileURL = urls.first else {
                return
            }
            let fileExtension: String = String(fileURL.pathExtension)

            parent.messagingViewModel.fileType = "document"
            parent.messagingViewModel.linkOfFile = fileURL
            parent.messagingViewModel.fileExtension = fileExtension
            parent.messagingViewModel.buttonTitle = fileURL.lastPathComponent
            
            print("printing...")
            print(fileURL.lastPathComponent)

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MessageDocumentPicker>) -> UIDocumentPickerViewController {
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
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<MessageDocumentPicker>) {
    }
}
