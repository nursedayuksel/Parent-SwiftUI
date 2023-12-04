//
//  IndividualChildrenView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualChildrenView: View {
    var children: Children
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: children.childPhoto))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 90, height: 90)
                .overlay(Circle().stroke(Color("MyEduCare"), lineWidth: 2))
            
            VStack(alignment: .leading, spacing: 15) {
                Text(children.fullName)
                    .bold()
                    .foregroundColor(.black)
                Text(children.className)
                    .bold()
                    .foregroundColor(.gray)
                Text(children.school)
                    .bold()
                    .foregroundColor(.gray)
                    .font(.system(size: 14))
            }
            
            Spacer() 
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
    }
}
