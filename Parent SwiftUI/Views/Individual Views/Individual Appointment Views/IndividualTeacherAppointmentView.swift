//
//  IndividualTeacherAppointmentView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 25.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualTeacherAppointmentView: View {
    var teacher: TeacherAppointment
    
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    
    @State var index: Int
    
    @State var showCancelAlert = false
    @State var showGetApptSheet = false
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: teacher.photo))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .background(Color.white)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color("MyEduCare"), lineWidth: 1))
            
            VStack(alignment: .leading, spacing: 10) {
                Text(teacher.teacherName)
                    .bold()
                    .foregroundColor(.black)
                
                HStack {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack(spacing: 3) {
                            Image(systemName: appointmentViewModel.appointmentIcon(index: index))
                            Text(appointmentViewModel.appointmentTitle(index: index))
                        }
                        .foregroundColor(.gray)
                        
                        if appointmentViewModel.appointmentLocation(index: index) != "" && appointmentViewModel.teacherAppointment[index].appTimeDate != " | "{
                            HStack(spacing: 3) {
                                Image(systemName: "mappin.circle")
                                Text(appointmentViewModel.appointmentLocation(index: index))
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    if teacher.isOnline == "true" {
                        Button(action: {}) {
                            Image(systemName: "video.circle.fill")
                                .foregroundColor(Color("MyEduCare"))
                                .font(.system(size: 35))
                        }
                    }
                }
                
                Button(action: {
                    if teacher.appTimeDate == " | " {
                        showCancelAlert = false
                        showGetApptSheet = true
                        print(index)
                        appointmentViewModel.getTeacherDates(index: index)
                        appointmentViewModel.getTeacherAvailableHours(teacherIdx: teacher.teacherIdx, weekday: teacher.weekdays[0])
                        appointmentViewModel.getTeacherTimesForDate(date: appointmentViewModel.weeksToDisplayArray[0].realDate, teacherIdx: teacher.teacherIdx)
                    } else {
                        showGetApptSheet = false
                        showCancelAlert = true
                    }
                }) {
                    Text(appointmentViewModel.appointButtonTitle(index: index))
                        .padding(3)
                        .frame(maxWidth: .infinity)
                        .background(appointmentViewModel.appointButtonColor(index: index))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .alert(isPresented: $showCancelAlert) {
                    Alert(title: Text("Warning!"), message: Text("Are you sure you want to cancel your appointment"), primaryButton: .destructive(Text("YES")) {
                        appointmentViewModel.cancelAppointment(date: teacher.appDate, hour: teacher.appTime, teacherIdx: teacher.teacherIdx)
                       // appointmentViewModel.isCancelLoading = true
                    }, secondaryButton: .default(Text("NO")))
                }
                .sheet(isPresented: $showGetApptSheet) {
                    AppointmentSheetView(appointmentViewModel: appointmentViewModel, showGetApptSheet: $showGetApptSheet)
                }
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}
