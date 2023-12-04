//
//  IndividualCommentsCardView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import SwiftUI

struct IndividualCommentsCardView: View {
    @ObservedObject var commentViewModel: CommentViewModel
    
    var comments: Comments
    
    init(comments: Comments, commentViewModel: CommentViewModel) {
        self.comments = comments
        self.commentViewModel = commentViewModel
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Circle()
                        .fill(commentViewModel.commentColorDictionary[comments.categoryName] ?? .black)
                        .frame(width: 10, height: 10)
                        .offset(x: -5, y: -2)
                    
                    HStack(spacing: 4) {
                        Text("\(comments.categoryName): ")
                            .bold()
                        Text("\(comments.commentMark)")
                            .bold()
                    }
                    .foregroundColor(.black)
                    
                    Spacer()
                    
                    Text("\(comments.commentDate)")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                        .font(.system(size: 15))
                }
                
                Text("\(comments.courseName)")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                Text("\(comments.teacherFullName)")
                    .foregroundColor(.gray)
            }
            .padding([.leading, .trailing], 8)
            .foregroundColor(.black)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}
