//
//  IndividualGradeDetailsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import SwiftUI

struct IndividualGradeDetailsView: View {
    @ObservedObject var gradesViewModel: GradesViewModel
    private var grades: Grades
    
    @State var courseIdx: String
    @State var selectedSingleGradeIndex = -1
    
    @State var index: Int
    
    
    init(gradesViewModel: GradesViewModel, grades: Grades, courseIdx: String, index: Int) {
        self.gradesViewModel = gradesViewModel
        self.grades = grades
        self.courseIdx = courseIdx
        self.index = index
    }
    
    var body: some View {
        if grades.courseIdx == courseIdx {
            Button(action: {
                gradesViewModel.singleGradeClicked = true
                selectedSingleGradeIndex = index
                gradesViewModel.selectedGradeValue = grades.gradeValue
                gradesViewModel.selectedGradeDate = grades.gradeDate
                gradesViewModel.selectedGradingWeightValueName = grades.gradingWeightValueName
                gradesViewModel.selectedGradeSubject = grades.subject
                gradesViewModel.selectedTeacherName = grades.teacherName
                gradesViewModel.selectedPercentage = grades.percentage
                gradesViewModel.selectedGradeComment = grades.comments
                gradesViewModel.selectedCourseIdx = grades.courseIdx
            }) {
                VStack(spacing: 0) {
                    Text(grades.gradeValue)
                        .bold()
                        .frame(width: 50, height: 50)
                        .foregroundColor(gradesViewModel.gradeColorsDict[grades.gradingWeightValueName] ?? .gray)
                        .background(Color(UIColor.secondarySystemBackground))
                    Text(grades.gradeDate)
                        .frame(width: 50)
                        .padding(3)
                        .foregroundColor(.white)
                        .background(gradesViewModel.gradeColorsDict[grades.gradingWeightValueName] ?? .gray)
                        .cornerRadius(6, corners: [.bottomLeft, .bottomRight])
                        .font(.system(size: 11))
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(6)
            }
        }
    }
}
