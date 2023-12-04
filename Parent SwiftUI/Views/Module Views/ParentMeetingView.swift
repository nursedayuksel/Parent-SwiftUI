//
//  ParentMeetingView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ParentMeetingView: View {
    
    // back
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var meetingViewModel = ParentMeetingViewModel()
    
    @State var isChooseDatePickerClicked = false
    @State var isSelectDateButtonClicked = false
    
    @State private var animate = 0.0
    
    @State var selectedMeetingIndex = 0
    
    @State var isSelectDateLoading = false
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedMeetingIndex,
            initialFunction: meetingViewModel.getMeetingDays,
            pickerArray: $meetingViewModel.meetingNamesArray,
            buttonFunction: selectMeeting,
            selectedPickerValueName: $meetingViewModel.selectedDateText,
            noDataDescription: "No available teachers",
            arrayCount: Binding<Int>(
                get: { meetingViewModel.teachers.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Parents' Meeting",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if meetingViewModel.teachers.count > 0 {
                            if meetingViewModel.meetingIsBooked.count > 0 {
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack(spacing: 10) {
                                        ForEach(meetingViewModel.teachers, id: \.id) { teacher in
                                            IndividualParentMeetingTeachersView(teacher: teacher, meetingViewModel: meetingViewModel)
                                        }
                                    }
                                    .padding([.top, .bottom], 10)
                                }
                            }
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                    
                    ZStack {
                        if isSelectDateLoading {
                            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                            VStack(spacing: 15) {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.5)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
                                    meetingViewModel.teacherParentMeetingTimes()
                                    isSelectDateLoading = false
                                })
                            }
                        }
                    }
                    
                    ZStack {
                        if meetingViewModel.isCancelLoading {
                            Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
                            VStack(spacing: 15) {
                                ProgressView()
                                    .tint(.white)
                                    .scaleEffect(1.5)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
                                    meetingViewModel.teacherParentMeetingTimes()
                                    meetingViewModel.isCancelLoading = false
                                })
                            }
                        }
                    }
                }
            })
    }
    
    func selectMeeting() {
        isSelectDateLoading = true
        
        meetingViewModel.selectedDateText = meetingViewModel.meetingDays[selectedMeetingIndex].dateFormatted
        meetingViewModel.selectedDate = meetingViewModel.meetingDays[selectedMeetingIndex].date
        meetingViewModel.selectedMeetingIdx = meetingViewModel.meetingDays[selectedMeetingIndex].meetingIdx
        meetingViewModel.getTeacherList()
    }
}

//struct ParentMeetingView: View {
//    // back
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var meetingViewModel = ParentMeetingViewModel()
//
//    @State var isChooseDatePickerClicked = false
//    @State var isSelectDateButtonClicked = false
//
//    @State private var animate = 0.0
//
//    @State var selectedMeetingIndex = 0
//
//    @State var isSelectDateLoading = false
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
//                VStack {
//                    VStack {
//                        HStack {
//                            Button(action: {
//                                presentationMode.wrappedValue.dismiss()
//                            }) {
//                                Image(systemName: "arrow.backward")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 20, height: 20)
//                                    .foregroundColor(Color.white)
//                            }
//                            .offset(y: -30)
//                            .padding(.leading, 8)
//
//                            Spacer()
//
//                            WebImage(url: URL(string: studentPhoto))
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 70, height: 70)
//                                .background(Color.white)
//                                .clipShape(Circle())
//                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                                .offset(x: 20)
//
//                            Spacer()
//
//                            Text("Meeting")
//                                .foregroundColor(Color.white)
//                                .bold()
//                                .font(.system(size: 16))
//                                .offset(y: -35)
//
//                        }
//                    }
//                    .padding(7)
//                    .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//                    HStack {
//                        VStack {
//                            Button(action: {
//                                self.isChooseDatePickerClicked.toggle()
//
//                                withAnimation {
//                                    animate = 1
//                                }
//                            }) {
//                                Text(meetingViewModel.selectedDateText)
//                                    .foregroundColor(Color.gray)
//                                    .padding(6)
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color.white)
//                                    .cornerRadius(4)
//                            }
//                        }
//
//                        Button(action: {
//                            self.isChooseDatePickerClicked.toggle()
//
//                            withAnimation {
//                                animate = 1
//                            }
//                        }) {
//                            Image(systemName: "arrowtriangle.down.fill")
//                                .foregroundColor(Color.white)
//                                .font(.system(size: 10))
//                                .cornerRadius(4)
//                        }
//                        .padding(8)
//                        .background(Color("MyEduCare"))
//                        .cornerRadius(4)
//                    }
//                    .padding(7)
//
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(spacing: 15) {
//                            ForEach(Array(meetingViewModel.teachers.enumerated()), id: \.1) { (index, teacher) in
//                                IndividualParentMeetingTeachersView(teacher: teacher, index: index, meetingViewModel: meetingViewModel)
//                            }
//                        }
//                        .padding(.top, 1)
//                        .padding(.bottom, 10)
//                    }
//                }
//            }
//
//            // meeting picker
//            ZStack {
//                if isChooseDatePickerClicked {
//                    Color.black.opacity(isChooseDatePickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                isChooseDatePickerClicked = false
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
//                            Picker(selection: $selectedMeetingIndex, label: Text("Select Term")) {
//                                ForEach(meetingViewModel.meetingDatesArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(meetingViewModel.meetingDatesArray[index]) (\(meetingViewModel.meetingNamesArray[index]))")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//
//                            Button(action: {
//                                isSelectDateLoading = true
//                                print(meetingViewModel.selectedDateText)
//                                meetingViewModel.selectedDateText = meetingViewModel.meetingDays[selectedMeetingIndex].dateFormatted
//                                meetingViewModel.selectedDate = meetingViewModel.meetingDays[selectedMeetingIndex].date
//                                meetingViewModel.selectedMeetingIdx = meetingViewModel.meetingDays[selectedMeetingIndex].meetingIdx
//
//                                isChooseDatePickerClicked = false
//                                isSelectDateButtonClicked = true
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
//
//            ZStack {
//                if isSelectDateLoading {
//                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
//                    VStack(spacing: 15) {
//                        ProgressView()
//                            .tint(.white)
//                            .scaleEffect(1.5)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
//                            meetingViewModel.teacherParentMeetingTimes()
//                            isSelectDateLoading = false
//                        })
//                    }
//                }
//            }
//
//            ZStack {
//                if meetingViewModel.isCancelLoading {
//                    Color.black.opacity(0.4).edgesIgnoringSafeArea(.all)
//                    VStack(spacing: 15) {
//                        ProgressView()
//                            .tint(.white)
//                            .scaleEffect(1.5)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6, execute: {
//                            meetingViewModel.teacherParentMeetingTimes()
//                            meetingViewModel.isCancelLoading = false
//                        })
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .background(Color("Background"))
//        .onAppear {
//            meetingViewModel.getMeetingDays()
//        }
//    }
//}
