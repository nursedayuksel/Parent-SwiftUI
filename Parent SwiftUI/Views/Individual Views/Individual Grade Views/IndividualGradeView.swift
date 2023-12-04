//
//  IndividualGradeView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import SwiftUI

struct IndividualGradeView: View {
    @ObservedObject var gradesViewModel: GradesViewModel
    private var gradeCourses: GradeCourses
    
    @State var selectedCourseIdx = ""
    
    @State var isOpenAndCloseButtonClicked = false
    
    @Binding var selectedGradeValueName: String
    
    @State var selectedLesson = ""
    
    
    init(gradesViewModel: GradesViewModel, gradeCourses: GradeCourses, selectedGradeValueName: Binding<String>) {
        self.gradesViewModel = gradesViewModel
        self.gradeCourses = gradeCourses
        _selectedGradeValueName = selectedGradeValueName
    }
    
    var body: some View {
        VStack(spacing: 15) {
            HStack(spacing: 20) {
                if gradesViewModel.existingCourseIdxsForGradesArray.contains(gradeCourses.courseIdx) {
                    if gradesViewModel.selectedCourseIdx != gradeCourses.courseIdx {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(Array(gradesViewModel.grades.enumerated()), id: \.1) { (index, grade) in
                                    IndividualGradeDetailsView(gradesViewModel: gradesViewModel, grades: grade, courseIdx: gradeCourses.courseIdx, index: index)
                                }
                            }
                        }
                    } else {
                        if gradesViewModel.selectedCourseIdx == gradeCourses.courseIdx {
                            Button(action: {
                                gradesViewModel.selectedCourseIdx = ""
                            }) {
                                HStack(spacing: 10) {
                                    VStack(spacing: 15) {
                                        Text("\(gradesViewModel.selectedGradeValue)")
                                            .bold()
                                        Text("\(gradesViewModel.selectedGradingWeightValueName)")
                                            .font(.system(size: 14))
                                    }
                                    .padding()
                                    .frame(width: 115, height: 115)
                                    .background(RoundedRectangle(cornerRadius: 20)
                                        .fill(Color(UIColor.secondarySystemBackground))
                                        .shadow(radius: 1))
                                    .foregroundColor(.black)
                                    
                                    VStack(alignment: .leading, spacing: 5) {
                                        // subject name
                                        HStack {
                                            Image(systemName: "book")
                                                .foregroundColor(.gray)
                                            Text("\(gradesViewModel.selectedGradeSubject)")
                                        }
                                        
                                        // teacher name
                                        HStack {
                                            Image(systemName: "person")
                                                .foregroundColor(.gray)
                                            Text("\(gradesViewModel.selectedTeacherName)")
                                                .offset(x: 2)
                                        }
                                        .offset(x: 1.5)
                                        
                                        // date
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundColor(.gray)
                                            Text("\(gradesViewModel.selectedGradeDate)")
                                        }
                                        
                                        // percentage
                                        HStack {
                                            Image(systemName: "percent")
                                                .foregroundColor(.gray)
                                            Text("\(gradesViewModel.selectedPercentage)")
                                        }
                                        
                                        // comment
                                        HStack {
                                            Image(systemName: "bubble.left")
                                                .foregroundColor(.gray)
                                            ScrollView(.horizontal) {
                                                Text("\(gradesViewModel.selectedGradeComment)")
                                            }
                                        }
                                    }
                                    .foregroundColor(.black)
                                    .font(.system(size: 14))
                                    
                                    Spacer()
                                }
                            }
                            .offset(y: -4)
                        }
                    }
                } else {
                    HStack {
                        Text("You have no grades for this lesson.")
                        Spacer()
                    }
                    .padding(10)
                }
            }
        }
    }
}
