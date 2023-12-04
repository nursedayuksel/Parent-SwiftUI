//
//  AppointmentSheetView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 25.04.2023.
//

import SwiftUI

struct AppointmentSheetView: View {
    @ObservedObject var appointmentViewModel: AppointmentViewModel

    @State var isOnlineChecked = false
    
    @State var selectedDateBooking = ""
    
    @State var openBookAppointmentAlert = false
    @State var selectedWeekday = ""
    
    @Binding var showGetApptSheet: Bool
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(appointmentViewModel.weeksToDisplayArray.enumerated()), id: \.1) { (index, day) in
                        Button(action: {
                            appointmentViewModel.getTeacherAvailableHours(teacherIdx: appointmentViewModel.teacherAppointment[appointmentViewModel.selectedTeacherIndex].teacherIdx, weekday: day.weekday)
                            appointmentViewModel.getTeacherTimesForDate(date: day.realDate, teacherIdx: appointmentViewModel.teacherAppointment[appointmentViewModel.selectedTeacherIndex].teacherIdx)
                            
                            appointmentViewModel.dateClicked = true
                            appointmentViewModel.selectedDate = day.dayDate
                            selectedDateBooking = day.realDate
                            selectedWeekday = day.weekday
                            
                            print(day.dayDate)
                            print(day.realDate)
                            
                        }) {
                            IndividualAppointmentDateView(appointmentDays: day, appointmentViewModel: appointmentViewModel)
                        }
                    }
                }
                .padding([.top, .bottom], 10)
                .padding()
            }
            .onAppear {
                appointmentViewModel.selectedDate = appointmentViewModel.weeksToDisplayArray[0].dayDate
                selectedWeekday = appointmentViewModel.weeksToDisplayArray[0].weekday
            }
            
            VStack {
                // add is online checkbox
                HStack(spacing: 5) {
                    ZStack {
                        Image(systemName: "square")
                            .foregroundColor(.gray)
                            .font(.system(size: 22))
                        if isOnlineChecked {
                            Image(systemName: "checkmark")
                                .frame(width: 3, height: 3)
                                .foregroundColor(Color("MyEduCare"))
                        }
                    }
                    .onTapGesture {
                        isOnlineChecked.toggle()
                    }
                    
                    Text("Online ")
                        .foregroundColor(.black)
                        .font(.system(size: 17))
                    Spacer()
                }
                .padding(10)
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(appointmentViewModel.availableHours, id: \.self) { hour in
                            if appointmentViewModel.teacherUnavailableHours.contains(hour.startTime) {
                                
                                Text("NOT AVAILABLE")
                                    .foregroundColor(.red)
                                    .padding()
                            } else {
                                Button(action: {
                                    print(selectedWeekday)
                                    print(appointmentViewModel.teacherAppointment[appointmentViewModel.selectedTeacherIndex])
                                    if appointmentViewModel.selectedDate == appointmentViewModel.weeksToDisplayArray[0].dayDate {
                                        print("WOOOOOOOO")
                                        print("date: \(appointmentViewModel.realDateArray[0])")
                                        appointmentViewModel.bookAppointment(date: appointmentViewModel.realDateArray[0], hour: hour.startTime, teacherIdx: appointmentViewModel.teacherAppointment[appointmentViewModel.selectedTeacherIndex].teacherIdx, isOnline: String(isOnlineChecked), location: appointmentViewModel.appointmentWeekdayLocationDict[selectedWeekday] ?? "No location")
                                    } else {
                                        appointmentViewModel.bookAppointment(date: selectedDateBooking, hour: hour.startTime, teacherIdx: appointmentViewModel.teacherAppointment[appointmentViewModel.selectedTeacherIndex].teacherIdx, isOnline: String(isOnlineChecked), location: appointmentViewModel.appointmentWeekdayLocationDict[selectedWeekday] ?? "No location")
                                    }
                                    openBookAppointmentAlert = true
                                }) {
                                    IndividualAppointmentHourView(availableHour: hour)
                                }
                                .alert(isPresented: $openBookAppointmentAlert) {
                                    switch appointmentViewModel.activeAlert {
                                    case .success:
                                        return Alert(title: Text("Success!"), message: Text("Your appointment has been booked"), dismissButton: .default(Text("OK")) {
                                            showGetApptSheet = false
                                        })
                                        
                                    case .failure:
                                        return Alert(title: Text("Error!"), message: Text(appointmentViewModel.errorMessage), dismissButton: .default(Text("OK")) {
                                            showGetApptSheet = false
                                        })
                                    }
                                }
                            }
                            
                            Divider()
                        }
                    }
                }
            }
            .background(Color(UIColor.secondarySystemBackground).edgesIgnoringSafeArea(.bottom))
        }
    }
}
