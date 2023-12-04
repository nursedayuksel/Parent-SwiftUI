//
//  HomeworkWebView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import SwiftUI
import WebKit

struct HomeworkWebView: UIViewRepresentable {
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
