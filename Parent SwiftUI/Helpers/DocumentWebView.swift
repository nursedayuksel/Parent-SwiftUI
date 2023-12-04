//
//  DocumentWebView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.04.2023.
//

import SwiftUI
import WebKit

struct DocumentWebView: UIViewRepresentable {
    
    let request: Data
    let mimeType: String
    let characterEncodingName: String
    let baseURL: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request, mimeType: mimeType, characterEncodingName: characterEncodingName, baseURL: baseURL)
    }
}
