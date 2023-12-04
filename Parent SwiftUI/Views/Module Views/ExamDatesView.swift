//
//  ExamDatesView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExamDatesView: View {
    
    @StateObject var examDatesViewModel = ExamDatesViewModel()
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
        
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: examDatesViewModel.getExamDates,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "You have no exams",
            arrayCount: Binding<Int>(
            get: { examDatesViewModel.examDates.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Exam Dates",
            HeaderContent: {},
            BodyContent: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(Array(examDatesViewModel.examDates.enumerated()), id: \.1) { (index, exam) in
                                IndividualExamDateCardView(examDate: exam, examNumber: index + 1)
                        }
                    }
                    .padding([.top, .bottom], 10)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .onAppear {
                    isLoading = false
                }
            })
    }
}
