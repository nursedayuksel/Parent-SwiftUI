//
//  CustomEmptyDataView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import SwiftUI

struct CustomEmptyDataView: View {
    @State var noDataText: String
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.icloud")
                .foregroundColor(Color("MyEduCare"))
                .font(.system(size: 150))
                .offset(y: -15)

            Text(noDataText)
                .bold()
                .foregroundColor(.gray)
                .font(.system(size: 20))

            Spacer()
        }
    }
}
