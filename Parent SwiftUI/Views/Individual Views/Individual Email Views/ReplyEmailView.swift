//
//  ReplyEmailView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import SwiftUI

struct ReplyEmailView: View {
    
    var email: Email
    
    @ObservedObject var emailViewModel: EmailViewModel
    
    @State var replyText = ""
    
    @State var openFilePicker = false

    @State var cameraPickerClicked = false
    @State var photoPickerClicked = false
    @State var documentPickerClicked = false
    
    @State private var inputImage: UIImage?
    @State private var inputFileUrl: URL?
    
    @State var showAlert = false
    
    @Binding var openSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Reply")
                    .bold()
                    .font(.system(size: 18))
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 5) {
                Text("To: \(email.name)")
                    .foregroundColor(.gray)
                
                Divider()
                
                Text("\(email.subject)")
                
                Divider()
                
                TextEditor(text: $replyText)
                    .font(.system(.body))
                    .frame(maxHeight: .infinity)
                    .frame(maxWidth: .infinity)

                VStack(spacing: 15) {
                    // file upload button
                    Button(action: {
                        openFilePicker = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Spacer()
                            Text(emailViewModel.buttonTitle != "" ? emailViewModel.buttonTitle : "No file selected")
                                .foregroundColor(.gray)
                        }
                    }
                    .alert(Text("Select file type"), isPresented: $openFilePicker) {
                        Button(action: {
                            cameraPickerClicked = true

                        }) {
                            Text("Camera")
                        }
                        Button(action: {
                            photoPickerClicked = true
                        }) {
                            Text("Photo / Gallery")
                        }
                        Button(action: {
                            documentPickerClicked = true
                        }) {
                            Text("Document")
                        }

                        Button("Cancel", role: .cancel) {}
                    }
                    
                    // send reply button
                    Button(action: {
                        showAlert = true
                        emailViewModel.sendReply(emailIdx: email.idx, replyText: replyText, recipientUserIdx: email.emailUserIdx)
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send")
                        }
                        .padding(8)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .background(Color("MyEduCare"))
                        .cornerRadius(15)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Success!"), message: Text("You reply has been sent!"), dismissButton: .default(Text("Done")) {
                            openSheet = false
                        })
                    }
                }
            }
        }
        .sheet(isPresented: $cameraPickerClicked) {
            EmailImagePicker(image: self.$inputImage, emailViewModel: emailViewModel, sourceType: .camera)
        }
        .sheet(isPresented: $photoPickerClicked) {
            EmailImagePicker(image: self.$inputImage, emailViewModel: emailViewModel)
        }
        .sheet(isPresented: $documentPickerClicked) {
            EmailDocumentPicker(emailViewModel: emailViewModel, documentUrl: self.$inputFileUrl)
        }
        .padding(8)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
