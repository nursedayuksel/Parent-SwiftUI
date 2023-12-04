//
//  IndividualEmailView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import SwiftUI

import SwiftUI
import SDWebImageSwiftUI

struct IndividualEmailView: View {
    @ObservedObject var emailViewModel: EmailViewModel
    @State var emailId: String
    @State private var draggedOffset = CGSize.zero
    @State private var viewAppeared = false
    
    var studentEmail: Email
    
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .fill(emailViewModel.emailStatusColor(idx: studentEmail.idx))
                    .frame(width: 10, height: 10)
                Spacer()
                Text("\(studentEmail.date_for_display)")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            HStack {
                WebImage(url: URL(string: studentEmail.senderPhoto))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .offset(y: -15)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(studentEmail.name + " " + studentEmail.surname)")
                        .bold()
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Text("\(studentEmail.subject)")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                    Text("\(studentEmail.message)")
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .font(.system(size: 15))
                }
                
                Spacer()
                
                if(studentEmail.attachments != "") {
                    Image(systemName: "paperclip")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                } else {}
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}

