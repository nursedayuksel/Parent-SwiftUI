//
//  IndividualDailyReportsCardView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 18.04.2023.
//

import SwiftUI

struct IndividualDailyReportsCardView: View {
    @ObservedObject var dailyReportsViewModel: DailyReportsViewModel
    
    var dailyReports: DailyReports
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Circle()
                            .fill(dailyReportsViewModel.indivReportColors(reportIdx: dailyReports.dailyReportIdx))
                            .frame(width: 10, height: 10)
                        Spacer()
                    }
                    Text("\(dailyReports.subject)")
                        .bold()
                        .foregroundColor(.black)
                        .font(.system(size: 15))
                    Text("\(dailyReports.dateForDisplay)")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                }
                Spacer()
                HStack {
                    if(dailyReports.attachment != "") {
                        Image(systemName: "paperclip")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                    } else {}
                }
             }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}

