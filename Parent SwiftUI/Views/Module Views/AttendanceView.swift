//
//  AttendanceView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct AttendanceView: View {
    
    @Environment(\.presentationMode) var presentationMode

    @StateObject var attendanceViewModel = AttendanceViewModel()
    
    @State private var animate = 0.0
    
    @State var filterButtonClicked: Bool = false
    @State var isChooseSemesterPickerClicked: Bool = false
    @State var isSelectSemesterButtonClicked: Bool = false
    
    @State var selectedAttendanceValueIndex = 0
    @State var selectedSemesterIndex = 0
    
    @State var selectedAttendanceValueName = ""
    @State var selectedSemesterName = ""
    
    @State private var isLoading = true
        
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $attendanceViewModel.selectedSemesterIndex,
            initialFunction: attendanceViewModel.getAttendanceSemesters,
            pickerArray: $attendanceViewModel.attendanceSemestersArray,
            buttonFunction: selectSemester,
            selectedPickerValueName: $attendanceViewModel.currentSelectedSemesterName,
            noDataDescription: "You have no attendances",
            arrayCount: Binding<Int>(
                get: { attendanceViewModel.attendanceList.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Attendance",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if attendanceViewModel.attendanceList.count > 0 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(attendanceViewModel.uniqueAttendanceValueArray.indices, id: \.self) { (index: Int) in
                                        Button(action: {
                                            filterButtonClicked = true
                                            selectedAttendanceValueIndex = index
                                            selectedAttendanceValueName = attendanceViewModel.uniqueAttendanceValueArray[index]
                                        }) {
                                            HStack {
                                                Text("\(attendanceViewModel.filterAttendanceList(valueName: attendanceViewModel.uniqueAttendanceValueArray[index]).count)")
                                                Text("\(attendanceViewModel.uniqueAttendanceValueArray[index])")
                                            }
                                            .font(.system(size: 14))
                                            .padding(8)
                                        }
                                        
                                        .foregroundColor(filterButtonClicked ? attendanceViewModel.uniqueAttendanceValueArray[selectedAttendanceValueIndex] == attendanceViewModel.uniqueAttendanceValueArray[index] ? .white : attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index]) : attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index]))
                                        .background(filterButtonClicked ? attendanceViewModel.uniqueAttendanceValueArray[selectedAttendanceValueIndex] == attendanceViewModel.uniqueAttendanceValueArray[index] ? attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index]) : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index])))
                                    }
                                }
                                .padding(.top, 10)
                                .padding([.leading, .trailing, .bottom], 1)
                            }
                            .padding([.leading, .trailing], 10)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 10) {
                                    if filterButtonClicked {
                                        ForEach(attendanceViewModel.filterAttendanceList(valueName: selectedAttendanceValueName), id: \.self) { filteredAttendanceList in
                                            IndividualAttendanceView(attendanceList: filteredAttendanceList, attendanceViewModel: attendanceViewModel, attendanceValueIndex: selectedAttendanceValueIndex)
                                        }
                                    } else {
                                        ForEach(attendanceViewModel.attendanceList, id: \.self) { attendance in
                                            IndividualAttendanceView(attendanceList: attendance, attendanceViewModel: attendanceViewModel, attendanceValueIndex: selectedAttendanceValueIndex)
                                        }
                                    }
                                }
                                .padding(.top, 1)
                                .padding(.bottom, 10)
                            }
                        }
                    }
                    
                    if filterButtonClicked {
                        ZStack(alignment: .bottomTrailing) {
                            Button(action: {
                                filterButtonClicked = false
                            }) {
                                HStack {
                                    Text("Clear filter")
                                    Image(systemName: "xmark")
                                }
                                .padding(10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
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
        attendanceViewModel.getAttendanceList(semester_idx: attendanceViewModel.attendanceSemesters[attendanceViewModel.selectedSemesterIndex].semesterIdx)
        attendanceViewModel.currentSelectedSemesterName = attendanceViewModel.attendanceSemesters[attendanceViewModel.selectedSemesterIndex].termName
    }
}


//struct AttendanceView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var attendanceViewModel = AttendanceViewModel()
//
//    @State private var animate = 0.0
//
//    @State var filterButtonClicked: Bool = false
//    @State var isChooseSemesterPickerClicked: Bool = false
//    @State var isSelectSemesterButtonClicked: Bool = false
//
//    @State var selectedAttendanceValueIndex = 0
//    @State var selectedSemesterIndex = 0
//
//    @State var selectedAttendanceValueName = ""
//    @State var selectedSemesterName = ""
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
//                            .offset(x: 10)
//                        Spacer()
//                        Text("Attendance")
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
//                        isChooseSemesterPickerClicked.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Text(attendanceViewModel.currentSelectedSemesterName)
//                            .foregroundColor(Color.gray)
//                            .padding(6)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(4)
//                    }
//
//                    Button(action: {
//                        isChooseSemesterPickerClicked.toggle()
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
//                if attendanceViewModel.attendanceList.count > 0 {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 10) {
//                            ForEach(attendanceViewModel.uniqueAttendanceValueArray.indices, id: \.self) { (index: Int) in
//                                Button(action: {
//                                    filterButtonClicked = true
//                                    selectedAttendanceValueIndex = index
//                                    selectedAttendanceValueName = attendanceViewModel.uniqueAttendanceValueArray[index]
//                                }) {
//                                    HStack {
//                                        Text("\(attendanceViewModel.filterAttendanceList(valueName: attendanceViewModel.uniqueAttendanceValueArray[index]).count)")
//                                        Text("\(attendanceViewModel.uniqueAttendanceValueArray[index])")
//                                    }
//                                    .font(.system(size: 14))
//                                    .padding(8)
//                                }
//
//                                .foregroundColor(filterButtonClicked ? attendanceViewModel.uniqueAttendanceValueArray[selectedAttendanceValueIndex] == attendanceViewModel.uniqueAttendanceValueArray[index] ? .white : attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index]) : attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index]))
//                                .background(filterButtonClicked ? attendanceViewModel.uniqueAttendanceValueArray[selectedAttendanceValueIndex] == attendanceViewModel.uniqueAttendanceValueArray[index] ? attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index]) : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
//                                .cornerRadius(20)
//                                .overlay(RoundedRectangle(cornerRadius: 20)
//                                    .stroke(lineWidth: 1)
//                                    .foregroundColor(attendanceViewModel.attendanceValueColor(short: attendanceViewModel.uniqueAttendanceShortArray[index])))
//                            }
//                        }
//                        .padding(10)
//                    }
//
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(spacing: 10) {
//                            if filterButtonClicked {
//                                ForEach(attendanceViewModel.filterAttendanceList(valueName: selectedAttendanceValueName), id: \.self) { filteredAttendanceList in
//                                    IndividualAttendanceView(attendanceList: filteredAttendanceList, attendanceViewModel: attendanceViewModel, attendanceValueIndex: selectedAttendanceValueIndex)
//                                }
//                            } else {
//                                ForEach(attendanceViewModel.attendanceList, id: \.self) { attendance in
//                                    IndividualAttendanceView(attendanceList: attendance, attendanceViewModel: attendanceViewModel, attendanceValueIndex: selectedAttendanceValueIndex)
//                                }
//                            }
//                        }
//                        .padding(.top, 1)
//                        .padding(.bottom, 10)
//                    }
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no attendance records")
//                }
//            }
//
//            ZStack {
//                if isChooseSemesterPickerClicked {
//                    Color.black.opacity(isChooseSemesterPickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                isChooseSemesterPickerClicked = false
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
//                            Picker(selection: $selectedSemesterIndex, label: Text("Select Term")) {
//                                ForEach(attendanceViewModel.attendanceSemestersArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(attendanceViewModel.attendanceSemestersArray[index])")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//                            Button(action: {
//                                attendanceViewModel.getAttendanceList(semester_idx: attendanceViewModel.attendanceSemesters[selectedSemesterIndex].semesterIdx)
//
//                                selectedSemesterName = attendanceViewModel.attendanceSemesters[selectedSemesterIndex].termName
//
//                                isChooseSemesterPickerClicked = false
//                                isSelectSemesterButtonClicked = true
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
//            if filterButtonClicked {
//                ZStack(alignment: .bottomTrailing) {
//                    Button(action: {
//                        filterButtonClicked = false
//                    }) {
//                        HStack {
//                            Text("Clear filter")
//                            Image(systemName: "xmark")
//                        }
//                        .padding(10)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(25)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            attendanceViewModel.getAttendanceSemesters()
//        }
//    }
//
//}
