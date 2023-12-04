//
//  UserImage.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 04.05.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserImage: View {
    var body: some View {
        WebImage(url: URL(string: studentPhoto))
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .background(Color.white)
            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
            .overlay(Circle().stroke(Color("MyEduCare"), lineWidth: 1))
    }
}
