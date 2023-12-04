//
//  TrackingView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct TrackingView: View {
    
    // back
    @Environment(\.presentationMode) var presentationMode

    @State var showSubjectPicker = false
    @State var selectButtonClicked = false
    
    @State var selectedSubjectIndex: Int = 0
    @State var selectedSubjectName = "Select Subject"
    
    @StateObject var trackingViewModel = TrackingViewModel()
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedSubjectIndex,
            initialFunction: trackingViewModel.getCoursesForChild,
            pickerArray: $trackingViewModel.subjectsArray,
            buttonFunction: selectSubject,
            selectedPickerValueName: $selectedSubjectName,
            noDataDescription: "You have no trackings",
            arrayCount: Binding<Int>(
                get: { trackingViewModel.trackingObjectives.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Tracking",
            HeaderContent: {},
            BodyContent: {
                    VStack {
                        ScrollView(.vertical) {
                            VStack(spacing: 10) {
                                ForEach(trackingViewModel.trackingObjectives, id: \.self) { tracking in
                                    IndividualGoalsView(trackingObjectives: tracking, trackingViewModel: trackingViewModel)
                                }
                            }
                            .padding(.top, 10)
                            .padding(.bottom, 1)
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
            })
    }
    
    func selectSubject() {
        trackingViewModel.courseIdx = trackingViewModel.courseIdsArray[selectedSubjectIndex]
        selectedSubjectName = trackingViewModel.childCourses[selectedSubjectIndex].subject
        trackingViewModel.getTrackingObjectives()
    }
}

//struct TrackingView: View {
//    // back
//    @Environment(\.presentationMode) var presentationMode
//
//    @State var showSubjectPicker = false
//    @State var selectButtonClicked = false
//
//    @State var selectedSubjectIndex: Int = 0
//    @State var selectedSubjectName = ""
//
//    @StateObject var trackingViewModel = TrackingViewModel()
//
//    @State private var animate = 0.0
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
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
//                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
//                            .frame(width: 70, height: 70)
//                            .background(Color.white)
//                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .offset(x: 10)
//                        Spacer()
//                        Text("Tracking")
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
//                    Button(action: {
//                        showSubjectPicker.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Text(selectButtonClicked ? "\(selectedSubjectName)" : "Select Subject")
//                            .foregroundColor(Color.gray)
//                    }
//                    .padding(6)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
//                    .cornerRadius(4)
//
//                    Button(action: {
//                        showSubjectPicker.toggle()
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
//                Spacer()
//
//                if(trackingViewModel.trackingObjectives.count == 0) {
//                    Spacer()
//                    Image(systemName: "exclamationmark.icloud")
//                        .foregroundColor(Color("MyEduCare"))
//                        .font(.system(size: 150))
//                        .offset(y: -15)
//
//                    if(selectButtonClicked == false) {
//                        Text("No subject selected")
//                            .bold()
//                            .foregroundColor(.gray)
//                            .font(.system(size: 20))
//                    }
//                    Text("\(trackingViewModel.warning_message)")
//                        .bold()
//                        .foregroundColor(.gray)
//                        .font(.system(size: 20))
//                    Spacer()
//                    Spacer()
//                } else {
//                    ScrollView(.vertical) {
//                        ForEach(trackingViewModel.trackingObjectives, id: \.self) { tracking in
//                            VStack(spacing: 15) {
//                                IndividualGoalsView(trackingObjectives: tracking, trackingViewModel: trackingViewModel)
//                            }
//                            .padding(.top, 20)
//                        }
//                    }
//                }
//            }
//
//            ZStack {
//                if showSubjectPicker {
//                    Color.black.opacity(showSubjectPicker ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack() {
//                            Spacer().frame(width: 300, alignment: .topTrailing)
//                            Button(action: {
//                                showSubjectPicker = false
//
//                                withAnimation {
//                                    animate = 0
//                                }
//
//                            }) {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 15, height: 15)
//                                    .foregroundColor(Color.black)
//                            }
//                        }
//                        VStack {
//                            Text("Select Subject")
//                                .bold()
//                                .foregroundColor(Color.black)
//                                .font(.system(size: 20))
//                            Picker(selection: $selectedSubjectIndex, label: Text("Select Subject")) {
//                                ForEach(trackingViewModel.subjectsArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(trackingViewModel.subjectsArray[index])")
//                                }
//                            }
//                            .pickerStyle(WheelPickerStyle())
//
//                            Button(action: {
//                                trackingViewModel.courseIdx = trackingViewModel.courseIdsArray[selectedSubjectIndex]
//                                //print(trackingViewModel.courseIdx)
//
//                                selectedSubjectName = trackingViewModel.childCourses[selectedSubjectIndex].subject
//                                trackingViewModel.getTrackingObjectives()
//
//                                showSubjectPicker = false
//                                selectButtonClicked = true
//
//                                withAnimation {
//                                    animate = 0
//                                }
//                            }) {
//                                Text("Select")
//                                    .bold()
//                                    .foregroundColor(Color.white)
//                                    .font(.system(size: 20))
//                            }
//                            .padding(13)
//                            .frame(maxWidth: .infinity)
//                            .background(Color("MyEduCare"))
//                            .cornerRadius(9)
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(25)
//                    .frame(width: 200)
//                    .scaleEffect(animate)
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden(true)
//        .onAppear {
//            trackingViewModel.getCoursesForChild()
//            trackingViewModel.getTrackingObjectives()
//        }
//    }
//}
