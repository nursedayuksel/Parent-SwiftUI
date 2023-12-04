//
//  ChatroomView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatroomView: View {
    @State var teacher: Teacher
    
    @ObservedObject var messagingViewModel: MessagingViewModel
    
    // back
    @Environment(\.presentationMode) var presentationMode
    
    @State var textEditorHeight: CGFloat = 20
    
    let timer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    @State var openFilePicker = false
    @State var cameraPickerClicked = false
    @State var photoPickerClicked = false
    @State var documentPickerClicked = false
    
    @State private var inputImage: UIImage?
    @State private var inputFileUrl: URL?
    
    @State var selectedMessageIdx = ""
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack(alignment: .top) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                            messagingViewModel.linkOfFile = nil
                            messagingViewModel.imageURL = nil
                            messagingViewModel.messageToBeSent = ""
                            
                        }) {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                        }
                        .padding(.leading, 8)
                        
                        HStack {
                            WebImage(url: URL(string: teacher.teacherPhoto))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .background(Color.white)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(teacher.teacherName)
                                    .bold()
                                Text(teacher.subject)
                                    .lineLimit(2)
                            }
                            .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                }
                .padding(7)
                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
                
                VStack(spacing: 15) {
                    ScrollView(.vertical) {
                        ForEach(messagingViewModel.messages, id: \.self) { message in
                            IndividualMessageView(message: message, messagingViewModel: messagingViewModel, teacherIdx: $teacher.teacherIdx, isTeacher: $teacher.isTeacher)
                                .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                                .onReceive(timer) { _ in
                                    messagingViewModel.getMessages(teacherIdx: teacher.teacherIdx, isTeacher: teacher.isTeacher)
                                }
                        }
                    }
                }
                .padding(8)
                .rotationEffect(Angle(degrees: 180)).scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                
                HStack(spacing: 1) {
                    Button(action: {
                        openFilePicker = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
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
                        
                    if #available(iOS 16.0, *) {
                        TextField("Type your message...", text: $messagingViewModel.messageToBeSent, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .foregroundStyle(.black)
                    } else {
                        VStack {
                            // Fallback on earlier versions
                            TextEditor(text: $messagingViewModel.messageToBeSent)
                                .font(.system(.body))
                                .frame(height: max(40,textEditorHeight))
                                .cornerRadius(10.0)
                                .shadow(radius: 1.0)
                                .foregroundStyle(.black)
                        }
                        .onPreferenceChange(ViewHeightKey.self) { textEditorHeight = $0 }
                    }
                    
                    if messagingViewModel.messageToBeSent != "" || messagingViewModel.imageURL != nil || messagingViewModel.fileExtension != "" {
                        Button(action: {
                            messagingViewModel.sendMessage(teacherIdx: teacher.teacherIdx, isTeacher: teacher.isTeacher)
                        }) {
                            Image(systemName: "paperplane.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 30))
                        }
                    }
                }
                .padding(7)
                .background(Color("MyEduCare").edgesIgnoringSafeArea(.bottom))
            }
            
            if messagingViewModel.imageURL != nil || messagingViewModel.linkOfFile != nil {
                ZStack(alignment: .bottomTrailing) {
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            HStack {
                                Text("\(messagingViewModel.buttonTitle)")
                                    .lineLimit(1)
                                    .font(.system(size: 15))
                                Button(action: {
                                    if messagingViewModel.fileType == "image" {
                                        messagingViewModel.imageURL = nil
                                        messagingViewModel.linkOfFile = nil
                                    }
                                    if messagingViewModel.fileType == "document" {
                                        messagingViewModel.linkOfFile = nil
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(8)
                            .background(Color(UIColor.systemGray5))
                            .cornerRadius(20)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .offset(y: -80)
                }
            }
        }
        .background(Color("Background"))
        .sheet(isPresented: $cameraPickerClicked) {
            MessageImagePicker(image: self.$inputImage, messagingViewModel: messagingViewModel, sourceType: .camera)
        }
        .sheet(isPresented: $photoPickerClicked) {
            MessageImagePicker(image: self.$inputImage, messagingViewModel: messagingViewModel)
        }
        .sheet(isPresented: $documentPickerClicked) {
            MessageDocumentPicker(messagingViewModel: messagingViewModel, documentUrl: self.$inputFileUrl)
        }
    }
}
    
struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}
