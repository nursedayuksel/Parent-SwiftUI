//
//  BehaviourView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct BehaviourView: View {
    
    @StateObject var behaviorViewModel = BehaviorViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var animate = 0.0
    
    @State var isChooseSubjectPickerClicked: Bool = false
    @State var isSelectCourseButtonClicked: Bool = false
    
    @State var selectedCourseIndex = 0
    
    @State var selectedCourseName = "All courses"
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedCourseIndex,
            initialFunction: behaviorViewModel.getBehaviors,
            pickerArray: $behaviorViewModel.uniqueBehaviorCoursesArray,
            buttonFunction: selectCourse,
            selectedPickerValueName: $selectedCourseName,
            noDataDescription: "You have no behaviours",
            arrayCount: Binding<Int>(
                get: { behaviorViewModel.behaviorList.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Behaviour",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if behaviorViewModel.behaviorList.count > 0 {
                            VStack(spacing: 20) {
                                VStack(spacing: 10) {
                                    HStack {
                                        Circle()
                                            .foregroundColor(.green)
                                            .frame(width: 20, height: 20)
                                        Text("Positive %")
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                    HStack {
                                        Circle()
                                            .foregroundColor(.red)
                                            .frame(width: 20, height: 20)
                                        Text("Negative %")
                                            .foregroundColor(.black)
                                        Spacer()
                                    }
                                }
                                
                                HStack {
                                    Spacer()
                                    PieChartView(values: [behaviorViewModel.negativePoints, behaviorViewModel.positivePoints], colors: [.red, .green], innerRadiusFraction: 0.6)
                                    Spacer()
                                }
                                
                                Spacer()
                            }
                            .padding(.top, 8)
                            .padding([.leading, .trailing], 10)
                            
                            VStack(spacing: 0) {
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack {
                                        if isSelectCourseButtonClicked {
                                            if selectedCourseName == "All courses" {
                                                ForEach(behaviorViewModel.behaviorList, id: \.self) { behavior in
                                                    IndividualBehaviorTypeView(behavior: behavior, behaviorViewModel: behaviorViewModel)
                                                    Divider()
                                                }
                                            } else {
                                                ForEach(behaviorViewModel.filterBehaviorsForCourse(courseName: selectedCourseName), id: \.self) { filteredBehavior in
                                                    IndividualBehaviorTypeView(behavior: filteredBehavior, behaviorViewModel: behaviorViewModel)
                                                    Divider()
                                                }
                                            }
                                        } else {
                                            ForEach(behaviorViewModel.behaviorList, id: \.self) { behavior in
                                                IndividualBehaviorTypeView(behavior: behavior, behaviorViewModel: behaviorViewModel)
                                                Divider()
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                }
            })
    }
    
    func selectCourse() {
        selectedCourseName = behaviorViewModel.uniqueBehaviorCoursesArray[selectedCourseIndex]
        behaviorViewModel.selectedCourseIdx = behaviorViewModel.uniqueBehaviorCourseIdxsArray[selectedCourseIndex]
        behaviorViewModel.getBehaviors()
    }
}

//struct BehaviourView: View {
//    @StateObject var behaviorViewModel = BehaviorViewModel()
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @State private var animate = 0.0
//
//    @State var isChooseSubjectPickerClicked: Bool = false
//    @State var isSelectCourseButtonClicked: Bool = false
//
//    @State var selectedCourseIndex = 0
//
//    @State var selectedCourseName = ""
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
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .offset(x: 10)
//                        Spacer()
//                        Text("Behavior")
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
//                HStack {
//                    VStack {
//                        Button(action: {
//                            self.isChooseSubjectPickerClicked.toggle()
//
//                            withAnimation {
//                                animate = 1
//                            }
//                        }) {
//                            Text(isSelectCourseButtonClicked ? "\(selectedCourseName)" : "All courses")
//                                .foregroundColor(Color.gray)
//                                .padding(6)
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white)
//                                .cornerRadius(4)
//                        }
//                    }
//
//                    Button(action: {
//                        self.isChooseSubjectPickerClicked.toggle()
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
//                if behaviorViewModel.behaviorList.count > 0 {
//                    VStack(spacing: 20) {
//                        VStack(spacing: 10) {
//                            HStack {
//                                Circle()
//                                    .foregroundColor(.green)
//                                    .frame(width: 20, height: 20)
//                                Text("Positive %")
//                                Spacer()
//                            }
//                            HStack {
//                                Circle()
//                                    .foregroundColor(.red)
//                                    .frame(width: 20, height: 20)
//                                Text("Negative %")
//                                Spacer()
//                            }
//                        }
//
//                        HStack {
//                            Spacer()
//                            PieChartView(values: [behaviorViewModel.negativePoints, behaviorViewModel.positivePoints], colors: [.red, .green], innerRadiusFraction: 0.6)
//                            Spacer()
//                        }
//
//                        Spacer()
//                    }
//                    .padding(.top, 8)
//                    .padding([.leading, .trailing], 10)
//
//                    VStack(spacing: 0) {
//                        ScrollView(.vertical, showsIndicators: false) {
//                            VStack {
//                                if isSelectCourseButtonClicked {
//                                    if selectedCourseName == "All courses" {
//                                        ForEach(behaviorViewModel.behaviorList, id: \.self) { behavior in
//                                            IndividualBehaviorTypeView(behavior: behavior, behaviorViewModel: behaviorViewModel)
//                                            Divider()
//                                        }
//                                    } else {
//                                        ForEach(behaviorViewModel.filterBehaviorsForCourse(courseName: selectedCourseName), id: \.self) { filteredBehavior in
//                                            IndividualBehaviorTypeView(behavior: filteredBehavior, behaviorViewModel: behaviorViewModel)
//                                            Divider()
//                                        }
//                                    }
//                                } else {
//                                    ForEach(behaviorViewModel.behaviorList, id: \.self) { behavior in
//                                        IndividualBehaviorTypeView(behavior: behavior, behaviorViewModel: behaviorViewModel)
//                                        Divider()
//                                    }
//                                }
//                            }
//                        }
//                    }
//                    .padding(.top, 10)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no behaviors")
//                }
//            }
//
//            ZStack {
//                if isChooseSubjectPickerClicked {
//                    Color.black.opacity(isChooseSubjectPickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                isChooseSubjectPickerClicked = false
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
//                            Picker(selection: $selectedCourseIndex, label: Text("Select Term")) {
//                                ForEach(behaviorViewModel.uniqueBehaviorCoursesArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(behaviorViewModel.uniqueBehaviorCoursesArray[index])")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//                            Button(action: {
//                                isChooseSubjectPickerClicked = false
//                                isSelectCourseButtonClicked = true
//
//                                selectedCourseName = behaviorViewModel.uniqueBehaviorCoursesArray[selectedCourseIndex]
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
//            behaviorViewModel.getBehaviors()
//        }
//    }
//}
