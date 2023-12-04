//
//  IndividualSubCategoriesView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct IndividualSubCategoriesView: View {
    @State var emoji_images: [String: String] = ["1": "neutral", "2": "smile", "3": "big_smile"]
    
    @State var categoryName: String
    private var nurseryRecords: NurseryRecords

    init(categoryName: String, nurseryRecords: NurseryRecords) {
        self.categoryName = categoryName
        self.nurseryRecords = nurseryRecords
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(nurseryRecords.subCategoryName)")
                    .foregroundColor(.black)
                Spacer()
                if nurseryRecords.score != "" {
                    Image(emoji_images[nurseryRecords.score] ?? "")
                        .resizable()
                        .frame(width: 20, height: 20)
                } else {
                    Image("null")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            if nurseryRecords.comment != "" {
                Text("\(nurseryRecords.comment)")
                    .foregroundColor(.gray)
            }
        }
    }
}
