//
//  TimeTableView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI
struct TimeTableView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var timetableViewModel = TimetableViewModel()
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: timetableViewModel.loadTimeTable,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "You have no lessons",
            arrayCount: Binding<Int>(
                get: { timetableViewModel.timeTableLessons.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Timetable",
            HeaderContent: {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 9) {
                        ForEach(timetableViewModel.arrayDaysShort.indices, id: \.self) { (index: Int) in
                            Button(action: {
                                timetableViewModel.currentDayIndex = index
                            }) {
                                VStack(spacing: 10) {
                                    Text(timetableViewModel.arrayDaysShort[index])
                                        .font(.system(size: 15))
                                    if timetableViewModel.dayNumbers.count == 7 {
                                        Text(timetableViewModel.dayNumbers[index])
                                            .bold()
                                            .font(.system(size: 24))
                                    } else {
                                        if timetableViewModel.weekdayNumbersArray.count > 0 {
                                            Text(timetableViewModel.weekdayNumbersArray[index])
                                                .bold()
                                                .font(.system(size: 24))
                                        }
                                    }
                                }
                                .padding(6)
                                .frame(width: 50, height: 76)
                                .background(index == timetableViewModel.currentDayIndex ? Color("MyEduCare") : Color(UIColor.secondarySystemBackground))
                                .cornerRadius(24)
                                .foregroundColor(index == timetableViewModel.currentDayIndex ? .white : Color("MyEduCare"))
                            }
                        }
                    }
                    .padding(.bottom, 10)
                }
                .padding([.leading, .trailing], 10)
            },
            BodyContent: {
                VStack {
                    if timetableViewModel.timeTableLessons.count > 0 {
                        if timetableViewModel.timeTableLessons[timetableViewModel.weekdayNumbers["\(timetableViewModel.currentDayIndex)"] as! String]!.count > 0 {
                            if timetableViewModel.weekdayNumbers["\(timetableViewModel.currentDayIndex)"] as! String == "Saturday" && timetableViewModel.saturdayNoLessons {
                                VStack {
                                    Spacer()
                                    
                                    Image("calendar").resizable()
                                        .renderingMode(.template)
                                        .foregroundColor(Color("MyEduCare"))
                                        .scaledToFit()
                                        .frame(width: 200, height: 200)

                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                ScrollView(.vertical, showsIndicators: false) {
                                    IndividualTimeTableLessonView(timetable: timetableViewModel.timeTableLessons[timetableViewModel.weekdayNumbers["\(timetableViewModel.currentDayIndex)"] as! String]!, timetableViewModel: timetableViewModel)
                                        .padding(.top, 1)
                                }
                            }
                        } else {
                            VStack {
                                Spacer()
                                
                                Image("calendar").resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color("MyEduCare"))
                                    .scaledToFit()
                                    .frame(width: 200, height: 200)

                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                }
                .padding(.top, 10)
                .background(Color(UIColor.secondarySystemBackground))
                .onAppear {
                    isLoading = false
                }
            })
    }
}

//struct TimeTableView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var timetableViewModel = TimetableViewModel()
//
//    var body: some View {
//        VStack {
//            VStack {
//                HStack {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image(systemName: "arrow.backward")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(Color.white)
//                    }
//                    .offset(y: -30)
//                    .padding(.trailing, 10)
//                    Spacer()
//                    WebImage(url: URL(string: studentPhoto))
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 70, height: 70)
//                        .background(Color.white)
//                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                        .offset(x: 10)
//                    Spacer()
//                    Text("Timetable")
//                        .foregroundColor(Color.white)
//                        .bold()
//                        .font(.system(size: 16))
//                        .offset(y: -35)
//                }
//                .padding(7)
//                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//                if timetableViewModel.timeTable.count > 0 {
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 7) {
//                            ForEach(timetableViewModel.arrayDaysShort.indices, id: \.self) { (index: Int) in
//                                Button(action: {
//                                    timetableViewModel.currentDayIndex = index
//                                }) {
//                                    VStack(spacing: 10) {
//                                        Text(timetableViewModel.arrayDaysShort[index])
//                                            .font(.system(size: 15))
//                                        if timetableViewModel.dayNumbers.count == 7 {
//                                            Text(timetableViewModel.dayNumbers[index])
//                                                .bold()
//                                                .font(.system(size: 24))
//                                        } else {
//                                            Text("")
//                                                .bold()
//                                                .font(.system(size: 24))
//                                        }
//                                    }
//                                    .padding(6)
//                                    .frame(width: 50, height: 76)
//                                    .background(index == timetableViewModel.currentDayIndex ? Color("MyEduCare") : .white)
//                                    .cornerRadius(24)
//                                    .foregroundColor(index == timetableViewModel.currentDayIndex ? .white : Color("MyEduCare"))
//                                }
//                            }
//                        }
//                    }
//                    .padding([.leading, .trailing], 10)
//
//                    if timetableViewModel.timeTableLessons[timetableViewModel.weekdayNumbers["\(timetableViewModel.currentDayIndex)"] as! String]!.count > 0 {
//                        ScrollView(.vertical, showsIndicators: false) {
//                            IndividualTimeTableLessonView(timetable: timetableViewModel.timeTableLessons[timetableViewModel.weekdayNumbers["\(timetableViewModel.currentDayIndex)"] as! String]!, timetableViewModel: timetableViewModel)
//                                .padding([.top, .bottom], 10)
//                        }
//                    } else {
//                        VStack {
//                            Spacer()
//
//                            Image("calendar").resizable()
//                                .renderingMode(.template)
//                                .foregroundColor(Color("MyEduCare"))
//                                .scaledToFit()
//                                .frame(width: 200, height: 200)
//
//                            Spacer()
//                        }
//                    }
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no lessons")
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            timetableViewModel.loadTimeTable()
//        }
//    }
//}
