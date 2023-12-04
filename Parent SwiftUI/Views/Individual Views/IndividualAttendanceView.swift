//
//  IndividualAttendanceView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 12.04.2023.
//

import SwiftUI

struct IndividualAttendanceView: View {
    var attendanceList: AttendanceList
    
    @State var attendanceValueIndex: Int
    
    @ObservedObject var attendanceViewModel: AttendanceViewModel
    
    init(attendanceList: AttendanceList, attendanceViewModel: AttendanceViewModel, attendanceValueIndex: Int) {
        self.attendanceList = attendanceList
        self.attendanceViewModel = attendanceViewModel
        self.attendanceValueIndex = attendanceValueIndex
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("\(attendanceList.attendanceDate)")
                    .bold()
                    .foregroundStyle(.black)
                Spacer()
                Text("\(attendanceList.attendanceValue)")
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                    .foregroundColor(.white)
                    .background(attendanceViewModel.attendanceValueColor(short: attendanceList.attendanceShort))
                    .cornerRadius(15)
            }
            
            Text("\(attendanceList.attendanceCourse)")
                .foregroundColor(.gray)

            Text("\(attendanceList.activity) (\(attendanceList.attendanceHours))")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}
