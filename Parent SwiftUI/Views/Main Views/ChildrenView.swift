//
//  ChildrenView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import LocalAuthentication

struct ChildrenView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var delegate: AppDelegate
    
    @StateObject var childrenViewModel = ChildrenViewModel()
    @ObservedObject var loginViewModel: LoginViewModel
    
    let fullName = UserDefaults.standard.string(forKey: "full_name") ?? ""
    
    @State var goToMainPage = false
    
    @State var openSettingsView = false
    
    @State var isLoading = true
    
    @State var showFaceId = false
    
    let isLogged = UserDefaults.standard.string(forKey: "is___logged1") ?? "false"
    let isLoggedOldApp = UserDefaults.standard.string(forKey: "logged") ?? "false"
    
    var body: some View {
        ZStack {
            if loginViewModel.appUnlocked {
                VStack {
                    HStack {
                        HStack(spacing: 5) {
                            Text(fullName)
                                .bold()
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            
                            Spacer()
                            
                            Button(action: {
                                openSettingsView = true
                            }) {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30))
                            }
                            .fullScreenCover(isPresented: $openSettingsView) {
                                SettingsView(loginViewModel: loginViewModel, settingsSheetOpened: $openSettingsView)
                            }
                        }
                        .padding([.leading, .trailing], 10)
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        .foregroundColor(Color(.white))
                    }
                    
                    ZStack {
                        if childrenViewModel.children.count > 0 {
                            VStack {
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack(spacing: 10) {
                                        ForEach(Array(childrenViewModel.children.enumerated()), id: \.1) { (index, child) in
                                            NavigationLink(destination: MainPageView(childrenViewModel: childrenViewModel, selectedStudentIdx: child.childUserIdx)
                                                .navigationBarBackButtonHidden(true)) {
                                                    if childrenViewModel.totalNotificationsArray[index] != 0 {
                                                        IndividualChildrenView(children: child)
                                                            .overlay(
                                                                Text("\(childrenViewModel.totalNotificationsArray[index])")
                                                                    .padding(6)
                                                                    .font(.system(size: 14))
                                                                    .background(Color.red)
                                                                    .foregroundColor(.white)
                                                                    .clipShape(Circle())
                                                                    .offset(x: 7, y: -10), alignment: .topTrailing)
                                                    } else {
                                                        IndividualChildrenView(children: child)
                                                    }
                                                }.simultaneousGesture(TapGesture().onEnded {
                                                    studentIdx = child.childUserIdx
                                                    studentName = child.fullName
                                                    studentClass = child.className
                                                    studentPhoto = child.childPhoto
                                                })
                                            
                                        }
                                    }
                                    .padding(10)
                                    .padding(.top, 10)
                                }
                                .onAppear {
                                    isLoading = false
                                    
                                }
      
                                Spacer()
                            }
                        } else {
                            if isLoading {
                                Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                                VStack(spacing: 10) {
                                    ProgressView()
                                        .tint(.white)
                                        .scaleEffect(1.5)
                                    Text("LOADING")
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4, execute: {
                                        childrenViewModel.getChildren()
                                    })
                                }
                            } else {
                                CustomEmptyDataView(noDataText: "You have no children")
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(30)
                }
          } else {
                VStack {
                    Spacer()
                    Image("logo_new_black")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 100)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.secondarySystemBackground))
            }
        }
        .background(Color("MyEduCare").ignoresSafeArea())
//        .onChange(of: scenePhase) { newPhase in
//            if newPhase == .inactive {
//                childrenViewModel.appUnlocked = false
//            } else if newPhase == .active {
//                if isLogged == "true" || isLoggedOldApp == "true" {
//                    if !childrenViewModel.appUnlocked {
//                        childrenViewModel.requestBiometricUnlock()
//                    }
//                }
//            } else if newPhase == .background {
//                childrenViewModel.appUnlocked = false
//            }
//        }
        .onAppear {
            let context = LAContext()

            var error: NSError? = nil

            let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error)
            
            if canEvaluate {
                if !loginViewModel.appUnlocked {
                    loginViewModel.requestBiometricUnlock()
                }
            } else {
                loginViewModel.appUnlocked = true
            }
        }
    }
}
