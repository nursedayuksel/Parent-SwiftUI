//
//  ExtendClubView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 19.04.2023.
//

import SwiftUI

struct ExtendClubView: View {
    @ObservedObject var clubViewModel: ClubViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    var club: Club
    
    @State var requestBus = false
    
    @State var showAlert = false
    
    var body: some View {
        VStack() {
            // club name
            HStack {
                Text(club.clubName)
                    .bold()
                    .foregroundColor(.black)
                Spacer()
            }
            .padding([.top, .leading], 8)
            
            VStack(spacing: 15) {
                // teacher name
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.gray)
                    Text(club.clubTeacherName)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                // club type
                HStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.gray)
                    Text(club.clubType)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                // fee type
                HStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.gray)
                    Text(clubViewModel.fee)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                // room name
                HStack {
                    Image(systemName: "house")
                        .foregroundColor(.gray)
                    Text(clubViewModel.roomNumber)
                        .foregroundColor(.black)
                    Spacer()
                }
                
                // description
                HStack(alignment: .top) {
                    VStack {
                        Image(systemName: "line.3.horizontal")
                        Image(systemName: "arrow.down")
                    }
                    .foregroundColor(.gray)
                    
                    ScrollView(.vertical, showsIndicators: true) {
                        Text(clubViewModel.clubDesc)
                            .foregroundColor(.black)
                    }
                    .frame(height: 90)
                    
                    Spacer()
                }
                
                // days
                HStack(alignment: .top) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center, spacing: 20) {
                            ForEach(clubViewModel.clubDays.indices, id: \.self) { (index: Int) in
                                HStack(spacing: 30) {
                                    Text(clubViewModel.clubDays[index])
                                        .frame(width: 80)
                                        .foregroundColor(.black)
                                        .font(.system(size: 14))
                                    Spacer()
                                    Text("\(clubViewModel.clubStartHours[index]) - \(clubViewModel.clubEndHours[index])")
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(15)
                    }
                    Spacer()
                }
                
                Spacer()
                
                if club.isMyClub == 0 {
                    Button(action: {
                        
                        showAlert = true
                        
                        clubViewModel.registerToClub(busRegIsOn: requestBus, clubIdx: club.clubIdx, isMyClub: club.isMyClub)
                    }) {
                        Text("Register")
                            .padding(10)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(15)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text(""), message: Text(clubViewModel.message), dismissButton: .default(Text("OK")) {
                            dismiss()
                            clubViewModel.loadSemesters()
                        })
                    }
                }
            }
            .padding(8)
            .background(Color(UIColor.secondarySystemBackground))
        }
    }
}
