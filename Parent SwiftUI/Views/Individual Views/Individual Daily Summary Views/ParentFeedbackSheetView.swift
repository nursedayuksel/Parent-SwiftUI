//
//  ParentFeedbackSheetView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import SwiftUI

struct ParentFeedbackSheetView: View {
    
    @ObservedObject var dailySummaryViewModel: DailySummaryViewModel
    
    @Binding var openFeedbackSheet: Bool
    
    @State var showAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Send feedback")
                .bold()
            
            TextEditor(text: $dailySummaryViewModel.feedback)
                .font(.system(.body))
                .frame(maxHeight: .infinity)
                .frame(maxWidth: .infinity)
                .foregroundColor(.black)
            
            Button(action: {
                dailySummaryViewModel.sendFeedback()
                showAlert = true
            }) {
                HStack(spacing: 5) {
                    Image(systemName: "paperplane.fill")
                    Text("Send")
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color("MyEduCare"))
                .cornerRadius(20)
                .foregroundColor(.white)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(dailySummaryViewModel.alertTitle), message: Text(dailySummaryViewModel.message), dismissButton: .default(Text("OK")) {
                    openFeedbackSheet = false
                })
            }
        }
        .padding(10)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            dailySummaryViewModel.getFeedback()
        }
    }
}
