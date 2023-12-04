//
//  IndividualDailySummaryCategoriesView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import SwiftUI

struct IndividualDailySummaryCategoriesView: View {
    var dailySummary: DailySummary
    
    @ObservedObject var dailySummaryViewModel: DailySummaryViewModel
    
    var body: some View {
        HStack(spacing: 10) {
            Image(dailySummary.image)
                .resizable()
                .scaledToFit()
                .frame(width: 45, height: 45)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(dailySummary.category)
                    .bold()
                    .foregroundColor(.black)
                if dailySummary.category == "Morning snack" || dailySummary.category == "AM snack" || dailySummary.category == "Lunch" || dailySummary.category == "Afternoon snack" || dailySummary.category == "Sleep" {
                    HStack(spacing: 8) {
                        Image(dailySummaryViewModel.dailySummaryValueSmileyFace(value: dailySummary.value))
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        Text(dailySummaryViewModel.dailySummaryValueSmileyFaceDesc(value: dailySummary.value, category: dailySummary.category))
                            .foregroundColor(.black)
                    }
                } else {
                    Text(dailySummary.value)
                        .foregroundColor(.black)
                }
            }
            
            Spacer()
        }
    }
}
