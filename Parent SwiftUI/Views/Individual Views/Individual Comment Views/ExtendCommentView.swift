//
//  ExtendCommentView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import SwiftUI

struct ExtendCommentView: View {
    var comments: Comments
    
    @ObservedObject var commentViewModel: CommentViewModel
    
    @State var shouldReload: Bool = false
    
    init(comments: Comments, commentViewModel: CommentViewModel) {
        self.comments = comments
        self.commentViewModel = commentViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("\(comments.categoryName)")
                    .bold()
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                Spacer()
            }
            .padding(10)
            .background(Color("MyEduCare"))
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("\(comments.commentDate)")
                        .foregroundColor(.black)
                }
                
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundColor(.gray)
                    Text("\(comments.courseName)")
                        .foregroundColor(.black)
                }
                
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text("\(comments.teacherFullName)")
                        .foregroundColor(.black)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.gray)
                    Text("\(comments.commentMark)")
                        .foregroundColor(.black)
                }
            }
            .padding([.leading, .trailing], 10)
            
            Divider()
            
            CommentWebView(messageText: $commentViewModel.singleComment, reload: $shouldReload)
                .frame(minWidth: 300, idealWidth: 600, maxWidth: .infinity, minHeight: 300, idealHeight: 1000, maxHeight: .infinity, alignment: .center)
            
//            Text("\(commentViewModel.singleComment)")
//                .font(.system(size: 18))
//                .foregroundColor(.black)
//        
            Spacer()
        }
    }
}
