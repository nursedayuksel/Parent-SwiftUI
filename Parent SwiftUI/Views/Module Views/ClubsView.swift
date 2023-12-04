//
//  ClubsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ClubsView: View {
    
    @StateObject var clubViewModel = ClubViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isChooseTermPickerClicked: Bool = false
    @State var isSelectTermButtonClicked: Bool = false
    @State var filterButtonClicked: Bool = false
    
    @State var selectedClubSemesterIndex = 0
    @State var selectedClubFilterIndex = 0
    
    @State var selectedTermName = ""
    
    @State private var animate = 0.0
    
    @State var indivClub: Club?
    
    @State var openIndivSheet = false
    
    var clubTypeColors: [Color] = [.green, .orange, .blue, .red, .purple]
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $clubViewModel.selectedTermIndex,
            initialFunction: clubViewModel.loadSemesters,
            pickerArray: $clubViewModel.clubSemesterNamesArray,
            buttonFunction: selectSemester,
            selectedPickerValueName: $clubViewModel.currentSelectedSemesterName,
            noDataDescription: "You have no clubs",
            arrayCount: Binding<Int>(
                get: { clubViewModel.clubList.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Clubs",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if clubViewModel.clubList.count > 0 {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(clubTypes.indices, id: \.self) { (index: Int) in
                                        VStack(alignment: .leading, spacing: 0) {
                                            Button(action: {
                                                filterButtonClicked = true
                                                selectedClubFilterIndex = index
                                            }) {
                                                HStack {
                                                    Text("\(clubViewModel.clubFiltersCount(clubFilterName: clubTypes[index])) \(clubTypes[index])")
                                                        
                                                    Spacer()
                                                }
                                                .font(.system(size: 14))
                                                .padding(8)
                                            }
                                        }
                                        .foregroundColor(filterButtonClicked ? clubTypes[selectedClubFilterIndex] == clubTypes[index] ? .white : clubTypeColors[index] : clubTypeColors[index])
                                        .background(filterButtonClicked ? clubTypes[selectedClubFilterIndex] == clubTypes[index] ? clubTypeColors[index] : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(20)
                                        .overlay(RoundedRectangle(cornerRadius: 20)
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(clubTypeColors[index]))
                                    }
                                }
                                .padding(.top, 10)
                                .padding([.leading, .trailing, .bottom], 1)
                            }
                            .padding([.leading, .trailing], 10)
                            
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 10) {
                                    if filterButtonClicked {
                                        ForEach(clubViewModel.filterClubs(clubFilterIndex: selectedClubFilterIndex), id: \.self) { filteredClub in
                                            Button(action: {
                                                clubViewModel.loadSingleClub(clubIdx: filteredClub.clubIdx)
                                                
                                                indivClub = filteredClub
                                            }) {
                                                IndividualClubCardView(clubs: filteredClub, clubViewModel: clubViewModel)
                                            }
                                        }
                                    } else {
                                        ForEach(clubViewModel.clubList, id: \.self) { club in
                                            Button(action: {
                                                clubViewModel.loadSingleClub(clubIdx: club.clubIdx)
                                                
                                                indivClub = club
                                                
                                                openIndivSheet = true
                                            }) {
                                                IndividualClubCardView(clubs: club, clubViewModel: clubViewModel)
                                            }
                                        }
                                        
                                    }
                                }
                                .padding(.top, 1)
                                .padding(.bottom, 10)
                                .sheet(item: $indivClub) { indivClub in
                                    ExtendClubView(clubViewModel: clubViewModel, club: indivClub)
                                }
                            }
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
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
            })
    }
    
    func selectSemester() {
        clubViewModel.getClubsList(semester_idx: clubViewModel.clubSemesters[clubViewModel.selectedTermIndex].semesterIdx)

        clubViewModel.currentSelectedSemesterName = clubViewModel.clubSemesters[clubViewModel.selectedTermIndex].termName
    }
}

//struct ClubsView: View {
//    @StateObject var clubViewModel = ClubViewModel()
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @State var isChooseTermPickerClicked: Bool = false
//    @State var isSelectTermButtonClicked: Bool = false
//    @State var filterButtonClicked: Bool = false
//
//    @State var selectedClubSemesterIndex = 0
//    @State var selectedClubFilterIndex = 0
//
//    @State var selectedTermName = ""
//
//    @State private var animate = 0.0
//
//    @State var indivClub: Club?
//
//    @State var openIndivSheet = false
//
//    var clubTypeColors: [Color] = [.green, .orange, .blue, .red, .purple]
//
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
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .offset(x: 10)
//                        Spacer()
//                        Text("Clubs")
//                            .foregroundColor(Color.white)
//                            .bold()
//                            .font(.system(size: 16))
//                            .offset(y: -35)
//                    }
//                    .padding(7)
//                    .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//                    HStack {
//                        Button(action: {
//                            isChooseTermPickerClicked.toggle()
//                            withAnimation {
//                                animate = 1
//                            }
//                        }) {
//                            Text("\(isSelectTermButtonClicked ? selectedTermName : clubViewModel.currentSelectedSemesterName)")
//                                .foregroundColor(Color.gray)
//                                .padding(6)
//                                .frame(maxWidth: .infinity)
//                                .background(Color.white)
//                                .cornerRadius(4)
//                        }
//
//                        Button(action: {
//                            isChooseTermPickerClicked.toggle()
//                            withAnimation {
//                                animate = 1
//                            }
//                        }) {
//                            Image(systemName: "arrowtriangle.down.fill")
//                                .foregroundColor(Color.white)
//                                .font(.system(size: 10))
//                                .cornerRadius(4)
//                        }
//                        .padding(8)
//                        .background(Color("MyEduCare"))
//                        .cornerRadius(4)
//                    }
//                    .padding(7)
//
//                    if clubViewModel.clubList.count > 0 {
//                        ScrollView(.horizontal, showsIndicators: false) {
//                            HStack(spacing: 10) {
//                                ForEach(clubTypes.indices, id: \.self) { (index: Int) in
//                                    VStack(alignment: .leading, spacing: 0) {
//                                        Button(action: {
//                                            filterButtonClicked = true
//                                            selectedClubFilterIndex = index
//                                        }) {
//                                            HStack {
//                                                Text("\(clubViewModel.clubFiltersCount(clubFilterName: clubTypes[index])) \(clubTypes[index])")
//
//                                                Spacer()
//                                            }
//                                            .font(.system(size: 14))
//                                            .padding(8)
//                                        }
//                                    }
//                                    .foregroundColor(filterButtonClicked ? clubTypes[selectedClubFilterIndex] == clubTypes[index] ? .white : clubTypeColors[index] : clubTypeColors[index])
//                                    .background(filterButtonClicked ? clubTypes[selectedClubFilterIndex] == clubTypes[index] ? clubTypeColors[index] : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(clubTypeColors[index]))
//                                }
//                            }
//                            .padding(10)
//                        }
//
//                        ScrollView(.vertical, showsIndicators: false) {
//                            VStack {
//                                if filterButtonClicked {
//                                    ForEach(clubViewModel.filterClubs(clubFilterIndex: selectedClubFilterIndex), id: \.self) { filteredClub in
//                                        Button(action: {
//                                            clubViewModel.loadSingleClub(clubIdx: filteredClub.clubIdx)
//
//                                            indivClub = filteredClub
//                                        }) {
//                                            IndividualClubCardView(clubs: filteredClub, clubViewModel: clubViewModel)
//                                        }
//                                    }
//                                } else {
//                                    ForEach(clubViewModel.clubList, id: \.self) { club in
//                                        Button(action: {
//                                            clubViewModel.loadSingleClub(clubIdx: club.clubIdx)
//
//                                            indivClub = club
//
//                                            openIndivSheet = true
//                                        }) {
//                                            IndividualClubCardView(clubs: club, clubViewModel: clubViewModel)
//                                        }
//                                    }
//
//                                }
//                            }
//                            .padding(.top, 1)
//                            .padding(.bottom, 10)
//                            .sheet(item: $indivClub) { indivClub in
//                                ExtendClubView(clubViewModel: clubViewModel, club: indivClub)
//                            }
//                        }
//                    } else {
//                        CustomEmptyDataView(noDataText: "You have no clubs")
//                    }
//                }
//            }
//
//            ZStack {
//                if isChooseTermPickerClicked {
//                    Color.black.opacity(isChooseTermPickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                isChooseTermPickerClicked = false
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
//                            Picker(selection: $selectedClubSemesterIndex, label: Text("Select Term")) {
//                                ForEach(clubViewModel.clubSemesterNamesArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(clubViewModel.clubSemesterNamesArray[index])")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//                            Button(action: {
//                                clubViewModel.getClubsList(semester_idx: clubViewModel.clubSemesters[selectedClubSemesterIndex].semesterIdx)
//
//                                selectedTermName = clubViewModel.clubSemesters[selectedClubSemesterIndex].termName
//
//                                isChooseTermPickerClicked = false
//                                isSelectTermButtonClicked = true
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
//            clubViewModel.loadSemesters()
//        }
//    }
//}
