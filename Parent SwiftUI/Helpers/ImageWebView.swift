//
//  ImageWebView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import SwiftUI
import WebKit

struct ImageWebView: UIViewRepresentable {
    
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
}
