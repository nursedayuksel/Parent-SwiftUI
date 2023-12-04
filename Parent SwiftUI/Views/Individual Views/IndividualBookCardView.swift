//
//  IndividualBookCardView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct IndividualBookCardView: View {
    @State var books: Books
    
    init(books: Books) {
        self.books = books
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("\(books.pages) Pages")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
                
                if books.stars != "0" {
                    HStack(spacing: 2) {
                        ForEach(0..<Int(books.stars)!, id: \.self) { _ in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 15))
                        }
                    }
                }
                
                Spacer()
                
                Text("\(books.date)")
                    .foregroundColor(.gray)
                    .font(.system(size: 16))
            }
            
            HStack {
                Text("\(books.bookName)")
                    .bold()
                    .foregroundColor(.black)
                Spacer()
            }
            
            if books.description != "" {
                Text("\(books.description)")
                    .foregroundStyle(.black)
            }
            
            if books.test != "" || books.sheet != "" || books.project != "" || books.drawing != "" {
                DisclosureGroup(
                    content: {
                        VStack(alignment: .leading, spacing: 10) {
                            if books.test != "" {
                                CustomBookExtraInformation(title: "Test (Quizzes/Kahoot etc", description: $books.test)
                                Divider()
                            }
                            
                            if books.sheet != "" {
                                CustomBookExtraInformation(title: "Reading sheet", description: $books.sheet)
                                Divider()
                            }
                            
                            if books.project != "" {
                                CustomBookExtraInformation(title: "Project", description: $books.project)
                                Divider()
                            }
                            
                            if books.drawing != "" {
                                CustomBookExtraInformation(title: "Drawing", description: $books.drawing)
                            }
                        }
                        .padding([.top, .bottom], 5)
                    },
                    label: {
                        Text("Extra info")
                            .foregroundStyle(Color("MyEduCare"))
                    }
                )
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}
