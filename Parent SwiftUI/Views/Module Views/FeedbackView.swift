//
//  FeedbackView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 27.04.2023.
//


import SwiftUI

struct FeedbackView: View {
    
    @StateObject var feedbackViewModel = FeedbackViewModel()
    
    @State var textEditorHeight: CGFloat = 20
    
    var fullName = UserDefaults.standard.string(forKey: "full_name")
    var email = UserDefaults.standard.string(forKey: "email")
    var schoolName = UserDefaults.standard.string(forKey: "school_name")
    
    @State var fullNameText = ""
    @State var emailText = ""
    @State var schoolNameText = ""
    
    @State var openFilePicker = false
    @State var cameraPickerClicked = false
    @State var photoPickerClicked = false
    @State var documentPickerClicked = false
    
    @State private var inputImage: UIImage?
    @State private var inputFileUrl: URL?
    
    @State var openSaveAlert = false
    
    @Binding var openFeedbackFormClicked: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        Text("Feedback Form")
                            .underline()
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Your feedback will be sent to the school administration.")
                        Text("If you would like to share your feedback with MyEducare team, please use the support button.")
                        Text("Thank you for your feedback and understanding.")
                    }
                    .padding(5)
                    .background(Color("feedbackColor"))
                    .foregroundColor(.black)
                    .cornerRadius(5)
                    
                    HStack {
                        HStack(spacing: 3) {
                            Text("Feedback:")
                                .bold()
                                .foregroundColor(.black)
                            Text("*")
                                .bold()
                                .foregroundColor(.red)
                        }
                        
                        if #available(iOS 16.0, *) {
                            TextField("", text: $feedbackViewModel.feedbackTextField, axis: .vertical)
                                .lineLimit(6...)
                                .textFieldStyle(.roundedBorder)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.gray)
                        } else {
                            VStack {
                                // Fallback on earlier versions
                                TextEditor(text: $feedbackViewModel.feedbackTextField)
                                    .font(.system(.body))
                                    .frame(minHeight: 100.0)
                                    .frame(maxWidth: .infinity)
                                    .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(Color(UIColor.systemGray4)))
                                    .foregroundColor(.gray)
                            }
                            .onPreferenceChange(FeedbackViewHeightKey.self) { textEditorHeight = $0 }
                        }
                    }
                    
                    HStack {
                        Text("Attachment:")
                            .bold()
                            .foregroundColor(.black)
                        if feedbackViewModel.imageURL != nil || feedbackViewModel.linkOfFile != nil {
                            Text("\(feedbackViewModel.buttonTitle)")
                            Button(action: {
                                if feedbackViewModel.fileType == "image" {
                                    feedbackViewModel.imageURL = nil
                                    feedbackViewModel.linkOfFile = nil
                                }
                                if feedbackViewModel.fileType == "document" {
                                    feedbackViewModel.linkOfFile = nil
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.gray)
                            }
                        } else {
                            Button(action: {
                                openFilePicker = true
                            }) {
                                Text("Select file")
                                    .padding(8)
                                    .foregroundColor(Color(UIColor.darkGray))
                                    .overlay(RoundedRectangle(cornerRadius: 5)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(Color(UIColor.systemGray4)))
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
                        }
                        Spacer()
                    }
                    
                    Text("If you would like to receive a follow up to your feedback, please tick the following in order to share your details.")
                        .bold()
                        .padding()
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [10]))
                            .foregroundColor(Color(UIColor.systemGray4)))
                    
                    HStack {
                        Text("Share personal info:")
                            .bold()
                            .foregroundColor(.black)
                        ZStack {
                            Image(systemName: "square")
                                .foregroundColor(.gray)
                                .font(.system(size: 22))
                            if feedbackViewModel.showDetailClicked {
                                Image(systemName: "checkmark")
                                    .frame(width: 3, height: 3)
                                    .foregroundColor(Color("MyEduCare"))
                            }
                        }
                        .onTapGesture {
                            feedbackViewModel.showDetailClicked.toggle()
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            feedbackViewModel.sendFeedback()
                            
                            openSaveAlert = true
                        }) {
                            Text("Send feedback")
                                .padding(8)
                                .background(.green)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                        }
                        .alert(isPresented: $openSaveAlert) {
                            switch feedbackViewModel.activeAlert {
                            case .success:
                                return Alert(title: Text("Success!"), message: Text("\(feedbackViewModel.feedbackSaveMessage)"), dismissButton: .default(Text("OK")) {
                                    openFeedbackFormClicked = false
                                })
                            case .failure:
                                return Alert(title: Text("Error!"), message: Text("\(feedbackViewModel.feedbackSaveMessage)"), dismissButton: .default(Text("OK")))
                            }
                        }
                    }
                    
                    if feedbackViewModel.showDetailClicked {
                        VStack(spacing: 15) {
                            HStack {
                                Text("User Details")
                                    .underline()
                                    .font(.system(size: 20))
                                Spacer()
                            }
                            
                            Divider()
                            
                            VStack(spacing: 25) {
                                HStack(spacing: 15) {
                                    Text("Name:")
                                        .bold()
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                    TextField(fullName ?? "", text: $fullNameText)
                                        .disabled(true)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 200)
                                    Spacer()
                                }
                                
                                HStack(spacing: 20) {
                                    Text("Email:")
                                        .bold()
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                    TextField(email ?? "", text: $emailText)
                                        .disabled(true)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 200)
                                    Spacer()
                                }
                                
                                HStack(spacing: 13) {
                                    Text("School:")
                                        .bold()
                                        .foregroundColor(.black)
                                        .font(.system(size: 15))
                                    TextField(schoolName ?? "", text: $schoolNameText)
                                        .disabled(true)
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 200)
                                    Spacer()
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .font(.system(size: 16))
        .sheet(isPresented: $cameraPickerClicked) {
            FeedbackImagePicker(image: self.$inputImage, feedbackViewModel: feedbackViewModel, sourceType: .camera)
        }
        .sheet(isPresented: $photoPickerClicked) {
            FeedbackImagePicker(image: self.$inputImage, feedbackViewModel: feedbackViewModel)
        }
        .sheet(isPresented: $documentPickerClicked) {
            FeedbackDocumentPicker(feedbackViewModel: feedbackViewModel, documentUrl: self.$inputFileUrl)
        }
    }
}

struct FeedbackViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
