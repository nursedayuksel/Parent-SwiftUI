//
//  ExtendEmailView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import SwiftUI
import WebKit
import SDWebImageSwiftUI

struct ExtendEmailView: View {
    
    var email: Email
    
    @State var shouldReload: Bool = false
    
    @ObservedObject var emailViewModel: EmailViewModel
    
    @State var indivEmail: Email?
    
    @State var openSheet = false
    
    var body: some View {
        ZStack {
            VStack {
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
                .padding(.top, 12)
                .background(Color.white)
                
                HStack {
                    Text("Subject: \(email.subject)")
                        .bold()
                        .font(.system(size: 17))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding([.leading, .trailing], 10)
                .padding(.top, 7)
                
                
                HStack {
                    WebImage(url: URL(string: email.senderPhoto))
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text("\(email.name)")
                        Text("\(email.date_for_display)")
                    }
                    .foregroundColor(.black)
                    Spacer()
                }
                .padding([.leading, .trailing], 10)
                
                Divider()
                    .padding([.leading, .trailing], 10)
                
                    VStack {
                        EmailWebView(messageText: $emailViewModel.messageUrl, reload: $shouldReload)
                            .frame(minWidth: 300, idealWidth: 600, maxWidth: .infinity, minHeight: 300, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
                        Spacer()
                    }
                    .padding([.leading, .trailing], 10)
                
                Spacer()
            }
            
            Button(action: {
                indivEmail = email
                openSheet = true
            }) {
                HStack {
                    Image(systemName: "arrowshape.turn.up.backward.fill")
                    Text("Reply")
                }
                .padding(8)
                .foregroundColor(.white)
                .background(Color("MyEduCare"))
                .cornerRadius(20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .sheet(isPresented: $openSheet) {
                ReplyEmailView(email: email, emailViewModel: emailViewModel, openSheet: $openSheet)
            }
        }
        .onAppear {
            emailViewModel.readSingleEmail(email: email)
        }
    }
}

struct EmailWebView: UIViewRepresentable {
    @Binding var messageText: String
    @Binding var reload: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(messageText, baseURL: nil)
        if reload == true {
            uiView.loadHTMLString(messageText, baseURL: nil)
            DispatchQueue.main.async {
                self.reload = false
            }
        }
    }
}

