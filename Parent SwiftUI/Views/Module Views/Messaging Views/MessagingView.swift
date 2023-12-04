//
//  MessagingView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessagingView: View {
    @StateObject var messagingViewModel = MessagingViewModel()
    
    // back
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var delegate: AppDelegate
    
    @State var textEditorHeight: CGFloat = 20
    
    @State var showDeleteAlert = false
    
    @State var selectedTeacherIdx = ""
    @State var selectedSupportIdx = ""
    
    @State var goToTeacherChatroom = false
    @State var goToSupportChatroom = false
    
    @State var selectedTeacher: Teacher?
    @State var selectedSupport: Teacher?
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(named: "Background")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                VStack {
                    HStack {
                        Button(action: {
                            if delegate.job == "" {
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                delegate.job = "main_page"
                            }
                        }) {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(Color.white)
                        }
                        .offset(y: -30)
                        .padding(.leading, 8)
                        
                        Spacer()
                        
                        WebImage(url: URL(string: studentPhoto))
                            .resizable()
                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                            .frame(width: 70, height: 70)
                            .background(Color.white)
                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                            .offset(x: 20)
                        
                        Spacer()
                        
                        Text("Messaging")
                            .foregroundColor(Color.white)
                            .bold()
                            .font(.system(size: 16))
                            .offset(y: -35)
                    }
                }
                .padding(7)
                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
                
                TabView {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(messagingViewModel.filterTeacherList(), id: \.self) { teacher in
                                VStack(spacing: 0) {
                                    Button(action: {
                                        messagingViewModel.getMessages(teacherIdx: teacher.teacherIdx, isTeacher: teacher.isTeacher)
                                        selectedTeacherIdx = teacher.teacherIdx
                                        messagingViewModel.resetMessageCounter(teacherIdx: teacher.teacherIdx)
                                        goToTeacherChatroom = true
                                        selectedTeacher = teacher
                                        print(selectedTeacherIdx)
                                    }) {
                                        VStack(spacing: 0) {
                                            IndividualTeacherView(teacher: teacher, messagingViewModel: messagingViewModel)
                                            
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray5))
                                                .frame(height: 1, alignment: .trailing)
                                                .edgesIgnoringSafeArea(.horizontal)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            NavigationLink(destination: ChatroomView(teacher: selectedTeacher ?? Teacher(teacherName: "", teacherPhoto: "", teacherIdx: "", subject: "", link: "", lastMessage: "", lastMessageDate: "", isTeacher: ""), messagingViewModel: messagingViewModel)
                                .navigationBarHidden(true)
                                .navigationBarTitle(""), isActive: $goToTeacherChatroom) { }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Background"))
                    .tabItem {
                        Label("Teachers", systemImage: "person.fill")
                    }
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            ForEach(messagingViewModel.filterSupportList(), id: \.self) { teacher in
                                VStack(spacing: 0) {
                                    Button(action: {
                                        messagingViewModel.getMessages(teacherIdx: teacher.teacherIdx, isTeacher: teacher.isTeacher)
                                        selectedSupportIdx = teacher.teacherIdx
                                        messagingViewModel.resetMessageCounter(teacherIdx: teacher.teacherIdx)
                                        goToSupportChatroom = true
                                        selectedSupport = teacher
                                        print(selectedSupportIdx)
                                    }) {
                                        VStack(spacing: 0) {
                                            IndividualTeacherView(teacher: teacher, messagingViewModel: messagingViewModel)
                                            
                                            Rectangle()
                                                .fill(Color(UIColor.systemGray5))
                                                .frame(height: 1, alignment: .trailing)
                                                .edgesIgnoringSafeArea(.horizontal)
                                        }
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                            NavigationLink(destination: ChatroomView(teacher: selectedSupport ?? Teacher(teacherName: "", teacherPhoto: "", teacherIdx: "", subject: "", link: "", lastMessage: "", lastMessageDate: "", isTeacher: ""), messagingViewModel: messagingViewModel)
                                .navigationBarHidden(true)
                                .navigationBarTitle(""), isActive: $goToSupportChatroom) { }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color("Background"))
                    .tabItem {
                        Label("Support staff", systemImage: "person.2.fill")
                    }
                }
                .onAppear {
                    let tabBarAppearance = UITabBarAppearance()
                    tabBarAppearance.configureWithDefaultBackground()
                    UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                }
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color("Background"))
        .onAppear {
            messagingViewModel.loadTeachersList()
        }
    }
}
