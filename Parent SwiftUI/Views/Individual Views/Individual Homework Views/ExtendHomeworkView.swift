//
//  ExtendHomeworkView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import SwiftUI
import WebKit

enum HomeworkFile {
    case selected, notSelected
}

struct ExtendHomeworkView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var homework: Homework
    
    @State var selectedFilterIndex: Int
    
    @ObservedObject var homeworkViewModel: HomeworkViewModel
    
    @State var isAddFileButtonClicked: Bool = false
    
    @State var openFilePicker1 = false
    @State var openFilePicker2 = false
    @State var openFilePicker3 = false
    
    @State private var fileContent = ""
    
    @State var documentPickerClicked = false
    @State var photoPickerClicked = false
    @State var cameraPickerClicked = false
    
    @State var uploadButtonIsClicked = false
    
    @State var buttonNumber = 0
    
    @State private var inputImage: UIImage?
    @State private var inputFileUrl: URL?
    
    @State var homeworkFile: HomeworkFile = .notSelected
    
    @State var shouldReload: Bool = false

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Spacer()
                    Button(action: {
                        self.shouldReload = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Color("MyEduCare"))
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                            Text("Reload")
                                .foregroundColor(Color("MyEduCare"))
                                .font(.system(size: 17))
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
                .background(Color.white)
                
                HStack {
                    Text("\(homework.courseName)")
                        .bold()
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                Divider()
                
                HStack(spacing: 20) {
                    //start date
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("\(homework.startDate)")
                    }
                    .foregroundColor(.gray)
                    
                    //end date
                    HStack {
                        
                        Image(systemName: "calendar.badge.plus")
                        Text("\(homework.endDate)")
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                Divider()
                
                Text("\(homework.value)")
                    .foregroundColor(homeworkViewModel.getEveryHomeworkColor(index: selectedFilterIndex))
                
                Divider()
                
                VStack(alignment: .leading, spacing: 15) {
                    if homeworkViewModel.category.count > 0 {
                        VStack(alignment: .leading, spacing: 10) {
                            if homeworkViewModel.category.count == 1 {
                                Text("Teacher remark")
                                    .underline()
                                    .foregroundStyle(Color("MyEduCare"))
                            } else {
                                Text("Teacher remarks")
                                    .underline()
                                    .foregroundStyle(Color("MyEduCare"))
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(homeworkViewModel.category, id: \.self) { cat in
                                    Text("◦ \(cat)")
                                        .foregroundColor(.black)

                                }
                            }
                        }
                    }
                    
                    if homeworkViewModel.comment != "" {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Teacher comment")
                                .underline()
                                .foregroundStyle(Color("MyEduCare"))
                            Text("\(homeworkViewModel.comment)")
                                .foregroundColor(.black)
                        }
                    }
                    
                    if homeworkViewModel.comment != "" || homeworkViewModel.category.count > 0 {
                        Divider()
                    }
                }
                
                HomeworkWebView(messageText: $homeworkViewModel.messageUrl, reload: $shouldReload)
                    .frame(minWidth: 300, idealWidth: 600, maxWidth: .infinity, minHeight: 300, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
                
                Spacer()
            }
            .padding(.top, 15)
            .padding([.leading, .trailing], 10)
//            .onAppear {
//                homeworkViewModel.getSingleHomework(homework: homework)
//            }
            
            if Int(homework.diff)! >= 0 && !isAddFileButtonClicked {
                ZStack(alignment: .bottomTrailing) {
                    Button(action: {
                        isAddFileButtonClicked = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Add files")
                        }
                        .padding(8)
                        .background(Color("MyEduCare"))
                        .foregroundColor(.white)
                        .cornerRadius(25)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                }
            }
            
            if isAddFileButtonClicked {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 15) {
                        Button(action: {
                            isAddFileButtonClicked = false
                            
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                            }
                        }
                        
                        VStack(spacing: 30) {
                            Text("Upload your work")
                            
                            // 1st file button
                            Button(action: {
                                openFilePicker1 = true
                                buttonNumber = 1
                            }) {
                                HStack {
                                    Image(systemName: "paperclip")
                                    Text(homeworkViewModel.firstButtonTitle != "" ? "\(homeworkViewModel.firstButtonTitle)" : "Select file")
                                }
                                .foregroundColor(Color("MyEduCare"))
                            }
                            .alert(Text("Select file type"), isPresented: $openFilePicker1) {
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
                            
                            // 2nd file button
                            Button(action: {
                                openFilePicker2 = true
                                buttonNumber = 2
                            }) {
                                HStack {
                                    Image(systemName: "paperclip")
                                    Text(homeworkViewModel.secondButtonTitle != "" ? "\(homeworkViewModel.secondButtonTitle)" : "Select file")
                                }
                                .foregroundColor(Color("MyEduCare"))
                            }
                            .alert(Text("Select file type"), isPresented: $openFilePicker2) {
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
                            
                            // 3rd file button
                            Button(action: {
                                openFilePicker3 = true
                                buttonNumber = 3
                            }) {
                                HStack {
                                    Image(systemName: "paperclip")
                                    Text(homeworkViewModel.thirdButtonTitle != "" ? "\(homeworkViewModel.thirdButtonTitle)" : "Select file")
                                }
                                .foregroundColor(Color("MyEduCare"))
                            }
                            .alert(Text("Select file type"), isPresented: $openFilePicker3) {
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
                        
                        // upload file
                        Button(action: {
                            print(homework.homeworkIdx)
                            uploadButtonIsClicked = true
                            homeworkViewModel.uploadHomeworkFile(homework_idx: homework.homeworkIdx)
                            if inputImage == nil && inputFileUrl == nil {
                                homeworkFile = .notSelected
                            } else {
                                homeworkFile = .selected
                            }
                            
                            print(homeworkFile)
                        }) {
                            Text("Upload")
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("MyEduCare"))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .alert(isPresented: $uploadButtonIsClicked) {
                            switch homeworkFile {
                            case .notSelected:
                                return Alert(
                                    title: Text("Error!"),
                                    message: Text("Please select a file to upload!"),
                                    dismissButton: .default(Text("OK")))

                            case .selected:
                                return Alert(
                                    title: Text("Success"),
                                    message: Text("Your file/s have been uploaded!"),
                                    dismissButton: .default(Text("OK"), action: {
                                        isAddFileButtonClicked = false
                                        presentationMode.wrappedValue.dismiss()
                                    })
                                )
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .bottomTrailing)
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(20)
                }
            }
            
        }
        .sheet(isPresented: $cameraPickerClicked) {
            ImagePicker(image: self.$inputImage, homeworkViewModel: homeworkViewModel, buttonNumber: $buttonNumber, sourceType: .camera)
        }
        
        .sheet(isPresented: $photoPickerClicked) {
            ImagePicker(image: self.$inputImage, homeworkViewModel: homeworkViewModel, buttonNumber: $buttonNumber)
        }
        .sheet(isPresented: $documentPickerClicked) {
            DocumentPicker(homeworkViewModel: homeworkViewModel, buttonNumber: $buttonNumber, documentUrl: self.$inputFileUrl)
        }
    }
}

