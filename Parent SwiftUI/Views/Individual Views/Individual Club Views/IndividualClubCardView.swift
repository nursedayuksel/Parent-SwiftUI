//
//  IndividiualClubCardView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import SwiftUI

struct IndividualClubCardView: View {
    
    var clubs: Club
    
    @ObservedObject var clubViewModel: ClubViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(clubs.clubName)
                    .bold()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                Spacer()
                Text(clubs.feeType)
                    .padding(3)
                    .font(.system(size: 15))
                    .frame(width: 60)
                    .foregroundColor(.white)
                    .background(clubViewModel.feeTypeColor(feeType: clubs.feeType))
                    .cornerRadius(15)
            }
            
            Text(clubs.clubTeacherName)
                .foregroundColor(.gray)
            Text("\(clubs.clubType) (\(clubs.dayOfClub))")
                .foregroundColor(.gray)
            clubViewModel.studentRegisteredToClub(studentRegistration: clubs.isMyClub)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}
