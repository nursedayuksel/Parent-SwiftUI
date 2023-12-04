//
//  IndividualCategoriesView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct IndividualCategoriesView: View {
    
    private var nurseryCategories: NurseryCategories
    @ObservedObject var nurseryReportViewModel: NurseryReportViewModel
    
    init(nurseryCategories: NurseryCategories, nurseryReportViewModel: NurseryReportViewModel) {
        self.nurseryCategories = nurseryCategories
        self.nurseryReportViewModel = nurseryReportViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(nurseryCategories.categoryName)")
                .foregroundColor(Color(hex: nurseryCategories.color))
            
            VStack(spacing: 20) {
                ForEach(nurseryReportViewModel.nurseryRecords, id: \.self) { records in
                    if records.categoryName == nurseryCategories.categoryName {
                        IndividualSubCategoriesView(categoryName: nurseryCategories.categoryName, nurseryRecords: records)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: nurseryCategories.color), lineWidth: 1)
            )
        }
        .padding([.leading, .trailing], 8)
    }
}
