//
//  GradesView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct GradesView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var gradesViewModel = GradesViewModel()
    
    var myColors = [UIColor.systemBlue, UIColor.systemGreen, UIColor.systemOrange, UIColor.systemPink, UIColor.systemPurple, UIColor.systemGray, UIColor.systemRed]
    var gradeColors: [String: UIColor] = [:]
    
    @State private var animate = 0.0
    
    @State var selectedTermName = ""
    
    @State private var isSelectTermButtonClicked: Bool = false
    @State private var isChooseTermPickerClicked: Bool = false
    
    @State var selectedGradeSemesterIndex = 0
    
    @State var selectedGradeValueName = ""
    
    @State private var isLoading = true
        
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $gradesViewModel.selectedSemesterIndex,
            initialFunction: gradesViewModel.getGradeSemesters,
            pickerArray: $gradesViewModel.gradeSemesterNamesArray,
            buttonFunction: selectSemester,
            selectedPickerValueName: $gradesViewModel.currentSelectedSemesterName,
            noDataDescription: "You have no grades",
            arrayCount: Binding<Int>(
                get: { gradesViewModel.grades.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Grades",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        // grade filters
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.gray)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(gradesViewModel.uniqueGradingWeightValuesArray.indices, id: \.self) { (index: Int) in
                                        Button(action: {
                                            selectedGradeValueName = gradesViewModel.uniqueGradingWeightValuesArray[index]
                                        }) {
                                            HStack(spacing: 5) {
                                                Rectangle()
                                                    .fill(gradesViewModel.gradeColorsDict[gradesViewModel.uniqueGradingWeightValuesArray[index]] ?? .gray)
                                                    .frame(width: 15, height: 30)
                                                    .cornerRadius(6, corners: [.topLeft, .bottomLeft])
                                                Text("\(gradesViewModel.uniqueGradingWeightValuesArray[index])")
                                                    .foregroundColor(.black)
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                        }
                                        .overlay(RoundedRectangle(cornerRadius: 6)
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(gradesViewModel.gradeColorsDict[gradesViewModel.uniqueGradingWeightValuesArray[index]] ?? .gray))
                                    }
                                }
                                .padding(.top, 10)
                                .padding(.bottom, 1)
                            }
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding([.leading, .trailing], 10)
                        
                        // grades
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(gradesViewModel.gradeCourses.indices, id: \.self) { (index: Int) in
                                    VStack(spacing: 10) {
                                        HStack(spacing: 5) {
                                            if gradesViewModel.selectedCourseIdx != gradesViewModel.gradeCourses[index].courseIdx {
                                                Image(systemName: "book")
                                                    .foregroundColor(.gray)
                                                Text(gradesViewModel.gradeCourses[index].subject)
                                                    .bold()
                                                Spacer()
                                            }
                                        }
                                        .font(.system(size: 14))
                                        .offset(x: -5, y: -10)
                                        
                                        IndividualGradeView(gradesViewModel: gradesViewModel, gradeCourses: gradesViewModel.gradeCourses[index], selectedGradeValueName: $selectedGradeValueName)
                                    }
                                    .padding()
                                    .frame(height: 145)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 1)
                                    .padding([.leading, .trailing], 10)
                                }
                            }
                            .padding([.top, .bottom], 10)
                        }
                    }
                }
                .background(Color(UIColor.secondarySystemBackground))
                .onAppear {
                    isLoading = false
                }
            })
    }
    
    func selectSemester() {
        gradesViewModel.getGrades(semester_idx: gradesViewModel.gradeSemesters[gradesViewModel.selectedSemesterIndex].semesterIdx)
        gradesViewModel.currentSelectedSemesterName = gradesViewModel.gradeSemesters[gradesViewModel.selectedSemesterIndex].termName
        gradesViewModel.selectedCourseIdx = ""
    }
}

//struct GradesView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var gradesViewModel = GradesViewModel()
//
//    var myColors = [UIColor.systemBlue, UIColor.systemGreen, UIColor.systemOrange, UIColor.systemPink, UIColor.systemPurple, UIColor.systemGray, UIColor.systemRed]
//    var gradeColors: [String: UIColor] = [:]
//
//    @State private var animate = 0.0
//
//    @State var selectedTermName = ""
//
//    @State private var isSelectTermButtonClicked: Bool = false
//    @State private var isChooseTermPickerClicked: Bool = false
//
//    @State var selectedGradeSemesterIndex = 0
//
//    @State var selectedGradeValueName = ""
//
//    var body: some View {
//        ZStack {
//            VStack {
//                VStack {
//                    HStack {
//                        Button(action: {
//                            presentationMode.wrappedValue.dismiss()
//                        }) {
//                            Image(systemName: "arrow.backward")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 20, height: 20)
//                                .foregroundColor(Color.white)
//                        }
//                        .offset(y: -30)
//                        .padding(.trailing, 10)
//                        Spacer()
//                        WebImage(url: URL(string: studentPhoto))
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 70, height: 70)
//                            .background(Color.white)
//                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .offset(x: 5)
//                        Spacer()
//                        Text("Grades")
//                            .foregroundColor(Color.white)
//                            .bold()
//                            .font(.system(size: 16))
//                            .offset(y: -35)
//                    }
//                    .padding([.leading, .trailing], 8)
//                }
//                .padding(7)
//                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//                //semester
//                HStack {
//                    Button(action: {
//                        self.isChooseTermPickerClicked.toggle()
//
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Text(isSelectTermButtonClicked == true ? "\(selectedTermName)" : "\(gradesViewModel.currentSelectedSemesterName)")
//                            .foregroundColor(Color.gray)
//                            .padding(6)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(4)
//                    }
//
//                    Button(action: {
//                        self.isChooseTermPickerClicked.toggle()
//
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Image(systemName: "arrowtriangle.down.fill")
//                            .foregroundColor(Color.white)
//                            .font(.system(size: 10))
//                            .cornerRadius(4)
//                    }
//                    .padding(8)
//                    .background(Color("MyEduCare"))
//                    .cornerRadius(4)
//                }
//                .padding(7)
//
//                // grade filters
//                HStack {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.gray)
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 10) {
//                            ForEach(gradesViewModel.uniqueGradingWeightValuesArray.indices, id: \.self) { (index: Int) in
//                                Button(action: {
//                                    selectedGradeValueName = gradesViewModel.uniqueGradingWeightValuesArray[index]
//                                }) {
//                                    HStack(spacing: 5) {
//                                        Rectangle()
//                                            .fill(gradesViewModel.gradingWeightColors(index: index))
//                                            .frame(width: 15, height: 30)
//                                            .cornerRadius(6, corners: [.topLeft, .bottomLeft])
//                                        Text("\(gradesViewModel.uniqueGradingWeightValuesArray[index])")
//                                            .foregroundColor(.black)
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    //.padding(2)
//                                }
//                                .overlay(RoundedRectangle(cornerRadius: 6)
//                                    .stroke(lineWidth: 1)
//                                    .foregroundColor(gradesViewModel.gradingWeightColors(index: index)))
//                            }
//                        }
//                        .padding(5)
//                    }
//
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.gray)
//                }
//                .padding([.leading, .trailing], 10)
//
//                // grades
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(spacing: 10) {
//                        ForEach(gradesViewModel.gradeCourses.indices, id: \.self) { (index: Int) in
//                            VStack(spacing: 10) {
//                                HStack(spacing: 5) {
//                                    if gradesViewModel.selectedCourseIdx != gradesViewModel.gradeCourses[index].courseIdx {
//                                        Image(systemName: "book")
//                                            .foregroundColor(.gray)
//                                        Text(gradesViewModel.gradeCourses[index].subject)
//                                            .bold()
//                                        Spacer()
//                                    }
//                                }
//                                .font(.system(size: 14))
//                                .offset(x: -5, y: -10)
//
//                                IndividualGradeView(gradesViewModel: gradesViewModel, gradeCourses: gradesViewModel.gradeCourses[index], selectedGradeValueName: $selectedGradeValueName)
//                            }
//                            .padding()
//                            .frame(height: 145)
//                            .background(Color.white)
//                            .cornerRadius(10)
//                            .shadow(radius: 1)
//                            .padding([.leading, .trailing], 10)
//                        }
//                    }
//                    .padding([.top, .bottom], 10)
//                }
//            }
//
//            // semester picker
//            ZStack {
//                if isChooseTermPickerClicked {
//                    Color.black.opacity(isChooseTermPickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                isChooseTermPickerClicked = false
//
//                                withAnimation {
//                                    animate = 0
//                                }
//                            }) {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 15, height: 15)
//                                    .foregroundColor(Color.black)
//                            }
//                        }
//                        VStack {
//                            Picker(selection: $selectedGradeSemesterIndex, label: Text("Select Term")) {
//                                ForEach(gradesViewModel.gradeSemesterNamesArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(gradesViewModel.gradeSemesterNamesArray[index])")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//
//                            Button(action: {
//                                gradesViewModel.getGrades(semester_idx: gradesViewModel.gradeSemesters[selectedGradeSemesterIndex].semesterIdx)
//                                selectedTermName = gradesViewModel.gradeSemesters[selectedGradeSemesterIndex].termName
//
//                                isChooseTermPickerClicked = false
//                                isSelectTermButtonClicked = true
//
//                                withAnimation {
//                                    animate = 0
//                                }
//                            }) {
//                                Text("Select")
//                                    .bold()
//                                    .padding(13)
//                                    .foregroundColor(Color.white)
//                                    .font(.system(size: 20))
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color("MyEduCare"))
//                                    .cornerRadius(9)
//                            }
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(25)
//                    .frame(width: 300)
//                    .scaleEffect(animate)
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            gradesViewModel.getGradeSemesters()
//        }
//    }
//}
