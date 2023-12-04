//
//  IndividualMessageView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualMessageView: View {
    @State var message: Message
    
    @ObservedObject var messagingViewModel: MessagingViewModel
    
    @Binding var teacherIdx: String
    @Binding var isTeacher: String
    
    @ScaledMetric var scale: CGFloat = 1
    
    @State var selectedMessageIdx = ""
    @State var selectedFileName = ""
    @State var selectedAttachment = ""
    @State var selectedPathExtension = ""
    
    @State var fileOpenerClicked = false
    
    @State var reload: Bool = false
    
    var body: some View {
        ZStack {
            if message.senderIdx == teacherIdx {
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(message.dateDisplay)")
                            .foregroundColor(.gray)
                        VStack(alignment: .leading, spacing: 5) {
                            if message.message != "" {
                                MessageWebView(messageText: $message.message, reload: $reload)
                                    .frame(minWidth: 0, maxWidth: message.message.widthOfString(usingFont: UIFont.systemFont(ofSize: 17)), minHeight: message.message.heightOfString(usingFont: UIFont.systemFont(ofSize: 17)), maxHeight: .infinity)
                                    //.frame(minWidth: 10, minHeight: 20)
                                
                                //Text("\(message.message)")
                                
                            }
                            
                            if message.softDelete != "1" && message.attachment != "" {
                                if message.pathExtension == "png" || message.pathExtension == "jpg" {
                                    WebImage(url: URL(string: message.attachment))
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(15)
                                        .frame(width: 300, height: 150)
                                } else {
                                    Button(action: {
                                        fileOpenerClicked = true
                                        messagingViewModel.selectedAttachment = message.attachment
                                        messagingViewModel.selectedFileName = message.fileName
                                        messagingViewModel.selectedPathExtension = message.pathExtension
                                    }) {
                                        Text(LocalizedStringKey(message.fileName))
                                            .foregroundColor(.white)
                                            .underline()
                                    }
                                }
                            }
                        }
                        .padding(8)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(15)

                    }

                    Spacer()
                }

            } else {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("\(message.dateDisplay)")
                            .foregroundColor(.gray)
                        
                        HStack {
                            if message.softDelete != "1" && message.attachment != "" {
                                if message.pathExtension != "png" || message.pathExtension != "jpg" {
                                    Button(action: {
                                        messagingViewModel.selectedMessageIdx = message.messageIdx
                                        messagingViewModel.showingDeleteAlert = true
                                        
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 5) {
                                if message.message != "" {
                                    MessageWebView(messageText: $message.message, reload: $reload)
                                        .frame(minWidth: 0, maxWidth: message.message.widthOfString(usingFont: UIFont.systemFont(ofSize: 17)), minHeight: message.message.heightOfString(usingFont: UIFont.systemFont(ofSize: 17)), maxHeight: .infinity)
                                }
                    
                                if message.softDelete != "1" && message.attachment != "" {
                                    if message.pathExtension == "png" || message.pathExtension == "jpg" {
                                        WebImage(url: URL(string: message.attachment))
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(15)
                                            .frame(width: 300, height: 150)
                                    } else {
                                        Button(action: {
                                            //fileOpenerClicked = true
                                            messagingViewModel.selectedAttachment = message.attachment
                                            messagingViewModel.selectedFileName = message.fileName
                                            messagingViewModel.selectedPathExtension = message.pathExtension
                                            messagingViewModel.selectedMessageIdx = message.messageIdx

                                            print(selectedAttachment)
                                        }) {
                                            Text(LocalizedStringKey(message.fileName))
                                                .foregroundColor(.white)
                                                .underline()
                                        }
                                    }
                                }
                            }
                            .padding(8)
                            .background(Color("MyEduCare"))
                            .foregroundColor(.white)
                            .cornerRadius(15)
                            .onLongPressGesture(minimumDuration: 0.2, perform: {
                                messagingViewModel.selectedMessageIdx = message.messageIdx
                                
                                if message.softDelete == "0" {
                                    messagingViewModel.showingDeleteAlert = true
                                }
                                
                                withAnimation {
                                    messagingViewModel.animate = 1
                                }
                            })
                            .alert(isPresented: $messagingViewModel.showingDeleteAlert) {
                                Alert(title: Text("Warning!"), message: Text("Are you sure you want to delete this message?"), primaryButton: .destructive(Text("YES")) {
                                    messagingViewModel.deleteMessage(messageIdx: messagingViewModel.selectedMessageIdx, teacherIdx: teacherIdx, isTeacher: isTeacher)
                                }, secondaryButton: .default(Text("NO")))
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $fileOpenerClicked) {
            messagingViewModel.downloadPdfFile()
        }
    }
}

