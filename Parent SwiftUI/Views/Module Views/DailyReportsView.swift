//
//  DailyReportsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DailyReportsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var dailyReportsViewModel = DailyReportsViewModel()
    
    @State var showIndividualContent: Bool = false
    @State var showView: Bool = true
    
    @State var dailyReportIdx = ""
    
    @State var allButtonIsClicked = true
    @State var readButtonIsClicked = false
    @State var unreadButtonIsClicked = false
    
    @State var isFirstReport = true
    
    @State var indivReport: DailyReports?
    
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: dailyReportsViewModel.getDailyReportsSemesters,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "You have no reports",
            arrayCount: Binding<Int>(
                get: { dailyReportsViewModel.dailyReports.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Daily Reports",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if dailyReportsViewModel.dailyReports.count > 0 {
                            HStack {
                                VStack {
                                    //filter buttons
                                    HStack {
                                        Button(action: {
                                            dailyReportsViewModel.filterReports(reportStatus: "All")
                                            showView = false
                                            
                                            allButtonIsClicked = true
                                            readButtonIsClicked = false
                                            unreadButtonIsClicked = false
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text("\(dailyReportsViewModel.dailyReports.count)")
                                                    .foregroundColor(allButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "All"))
                                                    .font(.system(size: 14))
                                                Text("All")
                                                    .foregroundColor(allButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "All"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(5)
                                            .background(allButtonIsClicked ? dailyReportsViewModel.filterColors(status: "All") : Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(20)
                                            .overlay(RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(dailyReportsViewModel.filterColors(status: "All")))
                                        }
                                        Button(action: {
                                            dailyReportsViewModel.filterReports(reportStatus: "Read")
                                            showView = false
                                            
                                            allButtonIsClicked = false
                                            readButtonIsClicked = true
                                            unreadButtonIsClicked = false
                                            
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text("\(dailyReportsViewModel.readReportsCount)")
                                                    .foregroundColor(readButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Read"))
                                                    .font(.system(size: 14))
                                                Text("Read")
                                                    .foregroundColor(readButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Read"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(5)
                                            .background(readButtonIsClicked ? dailyReportsViewModel.filterColors(status: "Read") : Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(20)
                                            .overlay(RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(dailyReportsViewModel.filterColors(status: "Read")))
                                        }
                                        Button(action: {
                                            dailyReportsViewModel.filterReports(reportStatus: "Unread")
                                            showView = false
                                            
                                            allButtonIsClicked = false
                                            readButtonIsClicked = false
                                            unreadButtonIsClicked = true
                                        }) {
                                            HStack {
                                                Spacer()
                                                Text("\(dailyReportsViewModel.unreadReportsCount)")
                                                    .foregroundColor(unreadButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Unread"))
                                                    .font(.system(size: 14))
                                                Text("Unread")
                                                    .foregroundColor(unreadButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Unread"))
                                                    .font(.system(size: 14))
                                                Spacer()
                                            }
                                            .padding(5)
                                            .background(unreadButtonIsClicked ? dailyReportsViewModel.filterColors(status: "Unread") : Color(UIColor.secondarySystemBackground))
                                            .cornerRadius(20)
                                            .overlay(RoundedRectangle(cornerRadius: 20)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(dailyReportsViewModel.filterColors(status: "Unread")))
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding([.leading, .trailing, .top], 10)
                                    
                                    ScrollView(.vertical, showsIndicators: false) {
                                        VStack(spacing: 10) {
                                            ForEach(dailyReportsViewModel.dailyReports, id: \.self) { reports in
                                                if (dailyReportsViewModel.copyIdsArray.contains(reports.dailyReportIdx)) {
                                                    Button(action: {
                                                        showIndividualContent = true
                                                        dailyReportIdx = reports.dailyReportIdx
                                                        
                                                        dailyReportsViewModel.reportStatus(reportIdx: reports.dailyReportIdx)
                                                        
                                                        isFirstReport = false
                                                        
                                                        indivReport = reports
                                                    }) {
                                                        VStack {
                                                            IndividualDailyReportsCardView(dailyReportsViewModel: dailyReportsViewModel, dailyReports: reports)
                                                        }
                                                    }
                                                    .sheet(item: $indivReport) { indivReport in
                                                        ExtendDailyReportsView(dailyReports: indivReport, dailyReportsViewModel: dailyReportsViewModel)
                                                    }
                                                } else if showView {
                                                    Button(action: {
                                                        showIndividualContent = true
                                                        dailyReportIdx = reports.dailyReportIdx
                                                        
                                                        dailyReportsViewModel.reportStatus(reportIdx: reports.dailyReportIdx)
                                                        
                                                        isFirstReport = false
                                                        
                                                        indivReport = reports
                                                    }) {
                                                        VStack {
                                                            IndividualDailyReportsCardView(dailyReportsViewModel: dailyReportsViewModel, dailyReports: reports)
                                                        }
                                                    }
                                                    .sheet(item: $indivReport) { indivReport in
                                                        ExtendDailyReportsView(dailyReports: indivReport, dailyReportsViewModel: dailyReportsViewModel)
                                                    }
                                                }
                                            }
                                        }
                                        .padding(.top, 1)
                                        .padding(.bottom, 10)
                                    }
                                }
                            }
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                }
            })
    }
}

//struct DailyReportsView: View {
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var dailyReportsViewModel = DailyReportsViewModel()
//
//    @State var showIndividualContent: Bool = false
//    @State var showView: Bool = true
//
//    @State var dailyReportIdx = ""
//
//    @State var allButtonIsClicked = true
//    @State var readButtonIsClicked = false
//    @State var unreadButtonIsClicked = false
//
//    @State var isFirstReport = true
//
//    @State var indivReport: DailyReports?
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
//                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .offset(x: 30)
//                        Spacer()
//                        Text("Daily Reports")
//                            .foregroundColor(Color.white)
//                            .bold()
//                            .font(.system(size: 16))
//                            .offset(y: -35)
//                    }
//                    .padding([.leading, .trailing], 8)
//                }
//                .padding(7)
//                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//                if dailyReportsViewModel.dailyReports.count > 0 {
//                    HStack {
//                        VStack {
//                            //filter buttons
//                            HStack {
//                                Button(action: {
//                                    dailyReportsViewModel.filterReports(reportStatus: "All")
//                                    showView = false
//
//                                    allButtonIsClicked = true
//                                    readButtonIsClicked = false
//                                    unreadButtonIsClicked = false
//                                }) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(dailyReportsViewModel.dailyReports.count)")
//                                            .foregroundColor(allButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "All"))
//                                            .font(.system(size: 14))
//                                        Text("All")
//                                            .foregroundColor(allButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "All"))
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    .padding(5)
//                                    .background(allButtonIsClicked ? dailyReportsViewModel.filterColors(status: "All") : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(dailyReportsViewModel.filterColors(status: "All")))
//                                }
//                                Button(action: {
//                                    dailyReportsViewModel.filterReports(reportStatus: "Read")
//                                    showView = false
//
//                                    allButtonIsClicked = false
//                                    readButtonIsClicked = true
//                                    unreadButtonIsClicked = false
//
//                                }) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(dailyReportsViewModel.readReportsCount)")
//                                            .foregroundColor(readButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Read"))
//                                            .font(.system(size: 14))
//                                        Text("Read")
//                                            .foregroundColor(readButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Read"))
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    .padding(5)
//                                    .background(readButtonIsClicked ? dailyReportsViewModel.filterColors(status: "Read") : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(dailyReportsViewModel.filterColors(status: "Read")))
//                                }
//                                Button(action: {
//                                    dailyReportsViewModel.filterReports(reportStatus: "Unread")
//                                    showView = false
//
//                                    allButtonIsClicked = false
//                                    readButtonIsClicked = false
//                                    unreadButtonIsClicked = true
//                                }) {
//                                    HStack {
//                                        Spacer()
//                                        Text("\(dailyReportsViewModel.unreadReportsCount)")
//                                            .foregroundColor(unreadButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Unread"))
//                                            .font(.system(size: 14))
//                                        Text("Unread")
//                                            .foregroundColor(unreadButtonIsClicked ? .white : dailyReportsViewModel.filterColors(status: "Unread"))
//                                            .font(.system(size: 14))
//                                        Spacer()
//                                    }
//                                    .padding(5)
//                                    .background(unreadButtonIsClicked ? dailyReportsViewModel.filterColors(status: "Unread") : Color(UIColor.secondarySystemBackground))
//                                    .cornerRadius(20)
//                                    .overlay(RoundedRectangle(cornerRadius: 20)
//                                        .stroke(lineWidth: 1)
//                                        .foregroundColor(dailyReportsViewModel.filterColors(status: "Unread")))
//                                }
//                            }
//                            .frame(maxWidth: .infinity)
//                            .padding([.leading, .trailing], 15)
//
//                            ScrollView(.vertical, showsIndicators: false) {
//                                VStack(spacing: 10) {
//                                    ForEach(dailyReportsViewModel.dailyReports, id: \.self) { reports in
//                                        if (dailyReportsViewModel.copyIdsArray.contains(reports.dailyReportIdx)) {
//                                            Button(action: {
//                                                showIndividualContent = true
//                                                dailyReportIdx = reports.dailyReportIdx
//
//                                                dailyReportsViewModel.reportStatus(reportIdx: reports.dailyReportIdx)
//
//                                                isFirstReport = false
//
//                                                indivReport = reports
//                                            }) {
//                                                VStack {
//                                                    IndividualDailyReportsCardView(dailyReportsViewModel: dailyReportsViewModel, dailyReports: reports)
//                                                }
//                                            }
//                                            .sheet(item: $indivReport) { indivReport in
//                                                ExtendDailyReportsView(dailyReports: indivReport, dailyReportsViewModel: dailyReportsViewModel)
//                                            }
//                                        } else if showView {
//                                            Button(action: {
//                                                showIndividualContent = true
//                                                dailyReportIdx = reports.dailyReportIdx
//
//                                                dailyReportsViewModel.reportStatus(reportIdx: reports.dailyReportIdx)
//
//                                                isFirstReport = false
//
//                                                indivReport = reports
//                                            }) {
//                                                VStack {
//                                                    IndividualDailyReportsCardView(dailyReportsViewModel: dailyReportsViewModel, dailyReports: reports)
//                                                }
//                                            }
//                                            .sheet(item: $indivReport) { indivReport in
//                                                ExtendDailyReportsView(dailyReports: indivReport, dailyReportsViewModel: dailyReportsViewModel)
//                                            }
//                                        }
//                                    }
//                                }
//                                .padding(.top, 1)
//                                .padding(.bottom, 10)
//                            }
//                        }
//                    }
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no reports")
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            dailyReportsViewModel.getDailyReportsSemesters()
//        }
//    }
//}

