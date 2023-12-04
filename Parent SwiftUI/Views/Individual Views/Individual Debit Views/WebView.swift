//
//  WebView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import WebKit
import SwiftUI

struct WebView : UIViewRepresentable {
    @State var url: String // 1
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView(frame: .zero) // 2
        webView.load(URLRequest(url: URL(string: url)!)) // 3
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {} // 4
}
