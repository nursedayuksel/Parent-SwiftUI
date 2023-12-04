//
//  SettingsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 27.04.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @State var feedbackFormOpened = false
    @State var logoutButtonClicked = false
    @State var navLinkActive = false
    
    @ObservedObject var loginViewModel: LoginViewModel
    
    @Binding var settingsSheetOpened: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack {
                    Button(action: {
                        settingsSheetOpened = false
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    }
                    Text("Settings")
                        .bold()
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                    Spacer()
                }
                .padding(10)
                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
                
                VStack(spacing: 15) {
                    //user profile button
                    Button(action: {
                    }) {
                        HStack {
                            Image(systemName: "person.crop.circle")
                            Text("User profile")
                                .bold()
                        }
                        .padding()
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("MyEduCare"))
                        .cornerRadius(12)
                    }
                    
                    //support button
                    Button(action: {
                        if let url = URL(string: "https://api.my-educare.com/support") {
                              UIApplication.shared.open(url)
                           }
                    }) {
                        HStack {
                            Image(systemName: "person.fill.questionmark")
                            Text("Support")
                                .bold()
                        }
                        .padding()
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("MyEduCare"))
                        .cornerRadius(12)
                    }
                    
                    //feedback button
                    Button(action: {
                        feedbackFormOpened = true
                    }) {
                        HStack {
                            Image(systemName: "bubble.left")
                            Text("Feedback about our school")
                                .bold()
                        }
                        .padding()
                        .font(.system(size: 18))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color("MyEduCare"))
                        .cornerRadius(12)
                    }
                    .sheet(isPresented: $feedbackFormOpened) {
                        FeedbackView(openFeedbackFormClicked: $feedbackFormOpened)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Button(action: {
                            logoutButtonClicked = true
                        }) {
                            HStack {
                                Image(systemName: "rectangle.lefthalf.inset.filled.arrow.left")
                                Text("Log out")
                                    .bold()
                            }
                            .foregroundColor(.red)
                            .font(.system(size: 20))
                        }
                        .alert(isPresented: $logoutButtonClicked) {
                            Alert(
                                title: Text("Warning!"),
                                message: Text("Are you sure you want to log out?"),
                                primaryButton: .destructive(Text("Yes")) {
                                    navLinkActive = true
                                    loginViewModel.userLogout()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        NavigationLink(destination: LoginView()
                            .navigationBarHidden(true)
                            .navigationBarTitle(""), isActive: $navLinkActive) { }
                        NavigationLink(destination: EmptyView()) {
                            EmptyView()
                        }
                    }
                }
                .padding([.leading, .trailing], 10)
            }
            .background(Color("Background").edgesIgnoringSafeArea(.bottom))
        }
    }
}
