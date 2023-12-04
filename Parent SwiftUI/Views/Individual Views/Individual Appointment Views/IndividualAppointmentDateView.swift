//
//  IndividualAppointmentDateView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 26.04.2023.
//

import SwiftUI

struct IndividualAppointmentDateView: View {
    var appointmentDays: WeekDay
    
    @ObservedObject var appointmentViewModel: AppointmentViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            Text(appointmentDays.dayName)
            Text(appointmentDays.dayDate)
        }
        .padding([.top, .bottom], 12)
        .padding([.leading, .trailing], 2)
        .foregroundColor(appointmentViewModel.dateClicked ? appointmentViewModel.selectedDate == appointmentDays.dayDate ? .white : .gray : .gray)
        .background(appointmentViewModel.dateClicked ? appointmentViewModel.selectedDate == appointmentDays.dayDate ? Color("MyEduCare") : .white : .white)
        .cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25)
            .stroke(lineWidth: 1)
            .foregroundColor(appointmentViewModel.dateClicked ? appointmentViewModel.selectedDate == appointmentDays.dayDate ? Color("MyEduCare") : .gray : .gray))
    }
}
