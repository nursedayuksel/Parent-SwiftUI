//
//  IndividualExamDateCardView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import UIKit
import WebKit

struct IndividualExamDateCardView: View {
    
    @State var showExamDescription = false
    
    var examDate: ExamDate
    
    @State var examNumber: Int
    
    init(examDate: ExamDate, examNumber: Int) {
        self.examDate = examDate
        self.examNumber = examNumber
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Spacer()
                Text("\(examDate.examDate)")
                    .bold()
                    .foregroundColor(.gray)
            }
            HStack {
                Text("\(examNumber).")
                    .bold()
                    .foregroundColor(.black)
                Text("\(examDate.courseName)")
                    .bold()
                    .foregroundColor(.black)
            }
            
            Text("\(examDate.teacherName)")
                .foregroundColor(.black)
            
            if examDate.examDescription != "" {
                DescriptionWebView(descriptionText: examDate.examDescription)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, idealHeight: 50, maxHeight: .infinity, alignment: .leading)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}

struct DescriptionWebView: UIViewRepresentable {
    let header = """
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no" />
                <style>
                    body {
                        font-size: 17px;
                    }
                </style>
            </head>
            <body>
            """
 
    @State var descriptionText: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(header + descriptionText + "</body>", baseURL: nil)
    }
}
