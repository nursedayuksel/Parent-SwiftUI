//
//  CustomBookExtraInformation.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 29.11.2023.
//

import SwiftUI

struct CustomBookExtraInformation: View {
    @State var title: String
    @Binding var description: String
    
    var body: some View {
        HStack(spacing: 7) {
            Text("\(title):")
                .foregroundStyle(Color(UIColor.systemGray))
            Text("\(description)")
                .foregroundStyle(Color("MyEduCare"))
            
            Spacer()
        }
    }
}
