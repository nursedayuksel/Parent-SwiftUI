//
//  CustomButton.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    var background: Color
    var foreground: Color
    func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .frame(maxWidth: .infinity)
                .background(background)
                .foregroundColor(foreground)
                .cornerRadius(15)
        }
}
