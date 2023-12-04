//
//  LoginView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject var loginViewModel = LoginViewModel()

    @State private var selectedInstitutionIndex = 0

    @State var user = ""
    @State var pass = ""
    
    @State var isActive: Bool = false
    @State var isMainPageActive: Bool = false
    
    @State var loginDetailsAreIncorrect = false
    
    let isLogged = UserDefaults.standard.string(forKey: "is___logged1") ?? "false"
    let isLoggedOldApp = UserDefaults.standard.string(forKey: "logged") ?? "false"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Parent App")
                    .bold()
                    .foregroundColor(Color("MyEduCare"))
                    .font(.system(size: 20))
                    .offset(y: 20)
                Spacer()
            }
            
            Spacer()

            VStack(spacing: 30) {
                Image("logo_new_black")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 100)
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(Color("MyEduCare"))
                        .font(.system(size: 20))
                    TextField("USERNAME", text: $user)
                        .foregroundColor(.black)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(UIColor.systemGray6)))
                HStack {
                    Image(systemName: "lock.circle.fill")
                        .foregroundColor(Color("MyEduCare"))
                        .font(.system(size: 20))
                    SecureField("PASSWORD", text: $pass)
                        .foregroundColor(.black)

                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(UIColor.systemGray6)))
                Picker("SELECT INSTITUTION", selection: $selectedInstitutionIndex, content: {
                    ForEach(loginViewModel.institutions.indices, id: \.self) { (index: Int) in
                        Text("\(loginViewModel.dbNamesArray[index])")
                            .foregroundStyle(.black)
                    }
                })
                .pickerStyle(.wheel)
                .frame(height: 100)

                VStack {
                    NavigationLink(destination: ChildrenView(loginViewModel: loginViewModel)
                        .navigationBarHidden(true)
                        .navigationBarTitle(""), isActive: $loginViewModel.shouldGoToNextPage) { }
                    NavigationLink(destination: EmptyView()) {
                        EmptyView()
                    }
                    Button(action: {
                        UserDefaults.standard.set("true", forKey: "is___logged1")
                        UserDefaults.standard.set("true", forKey: "logged")
                        loginViewModel.userLogin(username: user, password: pass, school_group: loginViewModel.institutions[selectedInstitutionIndex].db)
                        //childrenViewModel.getChildren()
                        print("db is: \(loginViewModel.institutions[selectedInstitutionIndex].db)")
                    }) {
                        Text("LOGIN")
                            .bold()
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .background(Color("MyEduCare"))
                            .cornerRadius(20)
                    }
                }
                .alert(isPresented: $loginViewModel.loginDetailsAreIncorrect) {
                    Alert(title: Text("Incorrect credentials!"), message: Text("\(loginViewModel.errorMessage)"), dismissButton: .default(Text("OK")))
                }
            }
            .padding([.leading, .trailing], 8)
            
            Spacer()
        }
        .padding([.leading, .trailing], 15)
        .onAppear {
            loginViewModel.getInstitutionNames()
        }
    }
}

