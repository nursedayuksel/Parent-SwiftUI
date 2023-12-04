//
//  IndividualAppointmentHourView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 26.04.2023.
//

import SwiftUI

struct IndividualAppointmentHourView: View {
    
    var availableHour: AvailableHours
    
    var body: some View {
        HStack {
            Spacer()
            Text(availableHour.meetingDisplay)
            Spacer()
        }
        .foregroundColor(.black)
        .padding()
    }
}
