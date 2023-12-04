//
//  ExtendDailyReportsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import SwiftUI
import WebKit

struct ExtendDailyReportsView: View {
    @State var shouldReload: Bool = false
    
    @State var dailyReports: DailyReports
    
    @ObservedObject var dailyReportsViewModel: DailyReportsViewModel
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    shouldReload.toggle()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(Color("MyEduCare"))
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 17, height: 17)
                        Text("Reload report")
                            .foregroundColor(Color("MyEduCare"))
                            .font(.system(size: 17))
                    }
                }
            }
            
            VStack(alignment: .leading) {
                Text("\(dailyReports.subject)")
                    .bold()
                    .font(.system(size: 18))
                Divider()
                Text("\(dailyReports.dateForDisplay)")
                    .foregroundColor(.gray)
                Divider()
            }
            
            if (dailyReports.attachment != "") {
                DailyReportWebView(messageText: $dailyReports.html, reload: $shouldReload)
                    .frame(minWidth: 300, idealWidth: 600, maxWidth: .infinity, minHeight: 300, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
            } else {
                DailyReportWebView(messageText: $dailyReports.message, reload: $shouldReload)
                    .frame(minWidth: 300, idealWidth: 600, maxWidth: .infinity, minHeight: 300, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
            }
        }
        .padding(.top, 15)
        .padding([.leading, .trailing, .bottom], 10)
    }
}

struct DailyReportWebView: UIViewRepresentable {
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

