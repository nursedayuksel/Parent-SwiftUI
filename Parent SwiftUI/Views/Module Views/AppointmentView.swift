//
//  AppointmentView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct AppointmentView: View {
    // back
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var appointmentViewModel = AppointmentViewModel()
    
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: appointmentViewModel.getTeacherList,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "No available teachers",
            arrayCount: Binding<Int>(
                get: { appointmentViewModel.teacherAppointment.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Appointment",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if appointmentViewModel.teacherAppointment.count > 0 {
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 10) {
                                    ForEach(Array(appointmentViewModel.teacherAppointment.enumerated()), id: \.1) { (index, teacher) in
                                        IndividualTeacherAppointmentView(teacher: teacher, appointmentViewModel: appointmentViewModel, index: index)
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
                    
//                    ZStack {
//                        if appointmentViewModel.isCancelLoading {
//                            Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
//                            VStack {
//                                ProgressView()
//                                    .tint(Color("MyEduCare"))
//                                    .scaleEffect(1.5)
//                            }
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .onAppear {
//                                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                                    appointmentViewModel.isCancelLoading = false
//                                })
//                            }
//                        }
//                    }
                }
            })
    }
}

//struct AppointmentView: View {
//    // back
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var appointmentViewModel = AppointmentViewModel()
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
//                            Text("Appointment")
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
//                    if appointmentViewModel.teacherAppointment.count > 0 {
//                        ScrollView(.vertical, showsIndicators: false) {
//                            VStack(spacing: 15) {
//                                ForEach(Array(appointmentViewModel.teacherAppointment.enumerated()), id: \.1) { (index, teacher) in
//                                    IndividualTeacherAppointmentView(teacher: teacher, appointmentViewModel: appointmentViewModel, index: index)
//                                }
//                            }
//                            .padding(.top, 1)
//                            .padding(.bottom, 10)
//                        }
//                    } else {
//                        CustomEmptyDataView(noDataText: "No available teachers")
//                    }
//                }
//            }
//
//            ZStack {
//                if appointmentViewModel.isCancelLoading {
//                    Color.black.opacity(0.2).edgesIgnoringSafeArea(.all)
//                    VStack {
//                        ProgressView()
//                            .tint(Color("MyEduCare"))
//                            .scaleEffect(1.5)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .onAppear {
//                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
//                            appointmentViewModel.isCancelLoading = false
//                        })
//                    }
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .background(Color("Background"))
//        .onAppear {
//            appointmentViewModel.getTeacherList()
//        }
//    }
//}
