//
//  IndividualHomeworksCardView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 13.04.2023.
//

import SwiftUI

struct IndividualHomeworksCardView: View {
    @ObservedObject var homeworkViewModel: HomeworkViewModel
    
    private var homework: Homework
    
    @State var index: Int
    
    init(homework: Homework, homeworkViewModel: HomeworkViewModel, index: Int) {
        self.homework = homework
        self.homeworkViewModel = homeworkViewModel
        _index = State(initialValue: index)
    }
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Circle()
                        .fill(homeworkViewModel.homeworkValueColorsDict[homework.value] ?? .black)
                        .frame(width: 10, height: 10)
                        .offset(x: -5, y: -2)
                    
                    Spacer()
                    
                    Text("\(homeworkViewModel.getExpirationValues(howManyDays: Int(homework.diff)!))")
                        .bold()
                        .padding(3)
                        .padding([.leading, .trailing], 10)
                        .foregroundColor(.white)
                        .background(homeworkViewModel.getExpirationColors(howManyDays: Int(homework.diff)!))
                        .cornerRadius(15)
                }
                
                Text("\(homework.courseName)")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.leading)
                
                HStack {
                    //start date
                    HStack {
                        Image(systemName: "calendar.badge.plus")
                        Text("\(homework.startDate)")
                    }
                    .foregroundColor(.gray)
                    
                    //end date
                    HStack {
                        Image(systemName: "calendar.badge.minus")
                        Text("\(homework.endDate)")
                    }
                    .foregroundColor(.gray)
                    
                    Spacer()
                    
                    if homework.attachment != "" {
                        Image(systemName: "paperclip")
                            .foregroundColor(.gray)
                            .font(.system(size: 20))
                            .offset(y: -15)
                    }
                }
            }
            .padding([.leading, .trailing], 8)
            .foregroundColor(.black)
            
            Spacer()
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}

