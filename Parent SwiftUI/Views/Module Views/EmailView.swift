//
//  EmailView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmailView: View {
    
    @StateObject var emailViewModel = EmailViewModel()
    
    @State var searchText = ""
    
    @State var allButtonIsClicked = true
    @State var readButtonIsClicked = false
    @State var unreadButtonIsClicked = false
    
    @State private var showView = true
    @State var showIndividualContent = false
    @State var alwaysFalseBool = false
    
    @State var selectedEmail = ""
    
    @State var isFirstEmail = true
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var delegate: AppDelegate
    
    @State var emailIdx = ""
    
    @State var indivEmail: Email?
    
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: emailViewModel.getEmails,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "You have no e-mails",
            arrayCount: Binding<Int>(
                get: { emailViewModel.studentEmails.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "E-mails",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if emailViewModel.studentEmails.count > 0 {
                            HStack {
                                VStack {
                                    HStack {
                                        Button(action: {
                                            emailViewModel.filterEmails(emailStatus: "All")
                                            
                                            showView = false
                                            UserDefaults.standard.setValue(false, forKey: "show")
                                            allButtonIsClicked = true
                                            readButtonIsClicked = false
                                            unreadButtonIsClicked = false
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text("\(emailViewModel.studentEmails.count)")
                                                    .foregroundColor(allButtonIsClicked ? .white : emailViewModel.filterColors(status: "All"))
                                                    .font(.system(size: 14))
                                                Text("All")
                                                    .foregroundColor(allButtonIsClicked ? .white : emailViewModel.filterColors(status: "All"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(5)
                                            .background(allButtonIsClicked ? emailViewModel.filterColors(status: "All") : Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(20)
                                            .overlay(RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(emailViewModel.filterColors(status: "All")))
                                        }
                                        Button(action: {
                                            emailViewModel.filterEmails(emailStatus: "Read")
                                            
                                            showView = false
                                            UserDefaults.standard.setValue(false, forKey: "show")
                                            allButtonIsClicked = false
                                            readButtonIsClicked = true
                                            unreadButtonIsClicked = false
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text("\(emailViewModel.readEmailsCount)")
                                                    .foregroundColor(readButtonIsClicked ? .white : emailViewModel.filterColors(status: "Read"))
                                                    .font(.system(size: 14))
                                                Text("Read")
                                                    .foregroundColor(readButtonIsClicked ? .white : emailViewModel.filterColors(status: "Read"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(5)
                                            .background(readButtonIsClicked ? emailViewModel.filterColors(status: "Read") : Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(20)
                                            .overlay(RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(emailViewModel.filterColors(status: "Read")))
                                        }
                                        Button(action: {
                                            emailViewModel.filterEmails(emailStatus: "Unread")
                                            
                                            showView = false
                                            UserDefaults.standard.setValue(false, forKey: "show")
                                            allButtonIsClicked = false
                                            readButtonIsClicked = false
                                            unreadButtonIsClicked = true
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text("\(emailViewModel.unreadEmailsCount)")
                                                    .foregroundColor(unreadButtonIsClicked ? .white : emailViewModel.filterColors(status: "Unread"))
                                                    .font(.system(size: 14))
                                                Text("Unread")
                                                    .foregroundColor(unreadButtonIsClicked ? .white : emailViewModel.filterColors(status: "Unread"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(5)
                                            .background(unreadButtonIsClicked ? emailViewModel.filterColors(status: "Unread") : Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(20)
                                            .overlay(RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(emailViewModel.filterColors(status: "Unread")))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding([.leading, .trailing], 10)
                                    
                                    SearchBar(searchText: $searchText)
                                        .padding([.leading, .trailing], 10)
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(spacing: 10) {
                                            ForEach(emailViewModel.studentEmails.filter({searchText.isEmpty ? true : $0.subject.contains(searchText)}), id: \.self) { studentEmail in
                                                VStack(spacing: 0) {
                                                    if showView {
                                                        Button(action: {
                                                            emailViewModel.emailStatus(emailIdx: studentEmail.idx)
                                                            emailIdx = studentEmail.idx
                                                            
                                                            selectedEmail = studentEmail.idx
                                                            
                                                            showIndividualContent = true
                                                            
                                                            isFirstEmail = false
                                                            
                                                            indivEmail = studentEmail
                                
                                                        }) {
                                                            VStack(spacing: 0) {
                                                                IndividualEmailView(emailViewModel: emailViewModel, emailId: studentEmail.idx, studentEmail: studentEmail)
                                                            }
                                                        }
                                                        .sheet(item: $indivEmail) { indivEmail in
                                                            ExtendEmailView(email: indivEmail, emailViewModel: emailViewModel)
                                                        }
                                                    } else if (emailViewModel.copyIdsArray.contains(studentEmail.idx)) {
                                                        Button(action: {
                                                            emailViewModel.emailStatus(emailIdx: studentEmail.idx)
                                                            showIndividualContent = true
                                                            
                                                            emailIdx = studentEmail.idx
                                                            
                                                            selectedEmail = studentEmail.idx
                                                            
                                                            isFirstEmail = false
                                                            
                                                            indivEmail = studentEmail
                                                            
                                                        }) {
                                                            VStack(spacing: 0) {
                                                                IndividualEmailView(emailViewModel: emailViewModel, emailId: studentEmail.idx, studentEmail: studentEmail)
                                                            }
                                                        }
                                                        .sheet(item: $indivEmail) { indivEmail in
                                                            ExtendEmailView(email: indivEmail, emailViewModel: emailViewModel)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.top, 1)
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                            .padding(.top, 10)
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                }
            })
    }
}

//struct EmailView: View {
//    
//    @StateObject var emailViewModel = EmailViewModel()
//    
//    @State var searchText = ""
//    
//    @State var allButtonIsClicked = true
//    @State var readButtonIsClicked = false
//    @State var unreadButtonIsClicked = false
//    
//    @State private var showView = true
//    @State var showIndividualContent = false
//    @State var alwaysFalseBool = false
//    
//    @State var selectedEmail = ""
//    
//    @State var isFirstEmail = true
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    @State var emailIdx = ""
//    
//    @State var indivEmail: Email?
//    
//    var body: some View {
//        VStack {
//            VStack {
//                HStack {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image(systemName: "arrow.backward")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(Color.white)
//                    }
//                    .offset(y: -30)
//                    .padding(.trailing, 10)
//                    Spacer()
//                    WebImage(url: URL(string: studentPhoto))
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 70, height: 70)
//                        .background(Color.white)
//                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                        .offset(x: 10)
//                    Spacer()
//                    Text("E-mails")
//                        .foregroundColor(Color.white)
//                        .bold()
//                        .font(.system(size: 16))
//                        .offset(y: -35)
//                }
//                .padding(7)
//                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//                
//                if emailViewModel.studentEmails.count > 0 {
//                    HStack {
//                        VStack {
//                            SearchBar(searchText: $searchText)
//                                .padding([.leading, .trailing], 10)
//                            
//                            HStack {
//                                Button(action: {
//                                    emailViewModel.filterEmails(emailStatus: "All")
//                                    
//                                    showView = false
//                                    UserDefaults.standard.setValue(false, forKey: "show")
//                                    allButtonIsClicked.toggle()
//                                }) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(emailViewModel.studentEmails.count)")
//                                            .foregroundColor(allButtonIsClicked ? .white : emailViewModel.filterColors(status: "All"))
//                                            .font(.system(size: 14))
//                                        Text("All")
//                                            .foregroundColor(allButtonIsClicked ? .white : emailViewModel.filterColors(status: "All"))
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    .padding(5)
//                                    .background(allButtonIsClicked ? emailViewModel.filterColors(status: "All") : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(emailViewModel.filterColors(status: "All")))
//                                }
//                                Button(action: {
//                                    emailViewModel.filterEmails(emailStatus: "Read")
//                                    
//                                    showView = false
//                                    UserDefaults.standard.setValue(false, forKey: "show")
//                                    readButtonIsClicked.toggle()
//                                }) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(emailViewModel.readEmailsCount)")
//                                            .foregroundColor(readButtonIsClicked ? .white : emailViewModel.filterColors(status: "Read"))
//                                            .font(.system(size: 14))
//                                        Text("Read")
//                                            .foregroundColor(readButtonIsClicked ? .white : emailViewModel.filterColors(status: "Read"))
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    .padding(5)
//                                    .background(readButtonIsClicked ? emailViewModel.filterColors(status: "Read") : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(emailViewModel.filterColors(status: "Read")))
//                                }
//                                Button(action: {
//                                    emailViewModel.filterEmails(emailStatus: "Unread")
//                                    
//                                    showView = false
//                                    UserDefaults.standard.setValue(false, forKey: "show")
//                                    unreadButtonIsClicked.toggle()
//                                }) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(emailViewModel.unreadEmailsCount)")
//                                            .foregroundColor(unreadButtonIsClicked ? .white : emailViewModel.filterColors(status: "Unread"))
//                                            .font(.system(size: 14))
//                                        Text("Unread")
//                                            .foregroundColor(unreadButtonIsClicked ? .white : emailViewModel.filterColors(status: "Unread"))
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    .padding(5)
//                                    .background(unreadButtonIsClicked ? emailViewModel.filterColors(status: "Unread") : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(emailViewModel.filterColors(status: "Unread")))
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding([.leading, .trailing], 10)
//                            
//                            ScrollView(.vertical, showsIndicators: false) {
//                                VStack(spacing: 10) {
//                                    ForEach(emailViewModel.studentEmails.filter({searchText.isEmpty ? true : $0.subject.contains(searchText)}), id: \.self) { studentEmail in
//                                        VStack(spacing: 0) {
//                                            if showView {
//                                                Button(action: {
//                                                    emailViewModel.emailStatus(emailIdx: studentEmail.idx)
//                                                    emailIdx = studentEmail.idx
//                                                    
//                                                    selectedEmail = studentEmail.idx
//                                                    
//                                                    showIndividualContent = true
//                                                    
//                                                    isFirstEmail = false
//                                                    
//                                                    indivEmail = studentEmail
//                        
//                                                }) {
//                                                    VStack(spacing: 0) {
//                                                        IndividualEmailView(emailViewModel: emailViewModel, emailId: studentEmail.idx, studentEmail: studentEmail)
//                                                    }
//                                                }
//                                                .sheet(item: $indivEmail) { indivEmail in
//                                                    ExtendEmailView(email: indivEmail, emailViewModel: emailViewModel)
//                                                }
//                                            } else if (emailViewModel.copyIdsArray.contains(studentEmail.idx)) {
//                                                Button(action: {
//                                                    emailViewModel.emailStatus(emailIdx: studentEmail.idx)
//                                                    showIndividualContent = true
//                                                    
//                                                    emailIdx = studentEmail.idx
//                                                    
//                                                    selectedEmail = studentEmail.idx
//                                                    
//                                                    isFirstEmail = false
//                                                    
//                                                    indivEmail = studentEmail
//                                                    
//                                                }) {
//                                                    VStack(spacing: 0) {
//                                                        IndividualEmailView(emailViewModel: emailViewModel, emailId: studentEmail.idx, studentEmail: studentEmail)
//                                                    }
//                                                }
//                                                .sheet(item: $indivEmail) { indivEmail in
//                                                    ExtendEmailView(email: indivEmail, emailViewModel: emailViewModel)
//                                                }
//                                            }
//                                        }
//                                    }
//                                }
//                                .padding(.top, 1)
//                                .padding(.bottom, 10)
//                            }
//                        }
//                    }
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no e-mails")
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            emailViewModel.getEmails()
//        }
//    }
//}
