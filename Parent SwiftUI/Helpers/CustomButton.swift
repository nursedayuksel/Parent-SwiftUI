//
//  CustomButton.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct CustomButton: View {
    var buttonName: String
    var imageName: String?
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: imageName ?? "")
            Text(buttonName)
                .bold()
        }
    }
}
