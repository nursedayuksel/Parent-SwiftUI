//
//  ContentView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 06.04.2023.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var childrenViewModel = ChildrenViewModel()
    
    @EnvironmentObject private var delegate: AppDelegate
    
    let isLogged = UserDefaults.standard.string(forKey: "is___logged1") ?? "false"
    let isLoggedOldApp = UserDefaults.standard.string(forKey: "logged") ?? "false"
    
    var body: some View {
        NavigationView {
            if isLogged == "false" || isLoggedOldApp == "false" {
                LoginView(loginViewModel: loginViewModel)
            } else {
                if delegate.job == "messaging" {
                    MessagingView().environmentObject(delegate)
                } else if delegate.job == "email" {
                    EmailView().environmentObject(delegate)
                } else if delegate.job == "home" {
                    ChildrenView(loginViewModel: loginViewModel).environmentObject(delegate)
                } else if delegate.job == "main_page" {
                    MainPageView(childrenViewModel: childrenViewModel, selectedStudentIdx: studentIdx).environmentObject(delegate)
                } else if delegate.job == "daily_report" {
                    DailyReportsView().environmentObject(delegate)
                } else {
                    ChildrenView(loginViewModel: loginViewModel).environmentObject(delegate)
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
