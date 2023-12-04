//
//  DailySummaryView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct DailySummaryView: View {
    
    @StateObject var dailySummaryViewModel = DailySummaryViewModel()
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var openFeedbackSheet = false
    
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
        
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: dailySummaryViewModel.getDailySummary,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "You have no daily summary",
            arrayCount: Binding<Int>(
                get: { dailySummaryViewModel.dailySummaryCategories.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Daily Summary",
            HeaderContent: {
                DatePicker("Select Date", selection: $dailySummaryViewModel.selectedDate, displayedComponents: .date)
                    .onChange(of: dailySummaryViewModel.selectedDate) { _ in
                        dailySummaryViewModel.getDailySummary()
                    }
                    .padding(10)
                    .foregroundColor(.gray)
                    .background(Color.white)
            },
            BodyContent: {
                ZStack {
                    VStack(spacing: 20) {
                        if dailySummaryViewModel.dailySummaryCategories.count > 0 {
                            ScrollView(.vertical, showsIndicators: false) {
                                VStack(spacing: 10) {
                                    ForEach(dailySummaryViewModel.dailySummaryCategories, id: \.self) { cat in
                                        IndividualDailySummaryCategoriesView(dailySummary: cat, dailySummaryViewModel: dailySummaryViewModel)
                                        Divider()
                                    }
                                }
                                .padding(.top, 10)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 10)
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                    
                    if dailySummaryViewModel.dailySummaryCategories.count > 0 && dailySummaryViewModel.parentCanWrite {
                        ZStack(alignment: .bottomTrailing) {
                            Button(action: {
                                openFeedbackSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "pencil")
                                    Text("Feedback")
                                }
                                .padding(10)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(25)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                            .sheet(isPresented: $openFeedbackSheet) {
                                ParentFeedbackSheetView(dailySummaryViewModel: dailySummaryViewModel, openFeedbackSheet: $openFeedbackSheet)
                            }
                        }
                    }
                }
            })
    }
}

//struct DailySummaryView: View {
//    @StateObject var dailySummaryViewModel = DailySummaryViewModel()
//
//    @Environment(\.presentationMode) var presentationMode
//
//    @State var openFeedbackSheet = false
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
//                            .offset(x: 30)
//                        Spacer()
//                        Text("Daily Summary")
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
//                VStack(spacing: 20) {
//                    DatePicker("Select Date", selection: $dailySummaryViewModel.selectedDate, displayedComponents: .date)
//                        .onChange(of: dailySummaryViewModel.selectedDate) { _ in
//                            dailySummaryViewModel.getDailySummary()
//                        }
//                        .foregroundColor(.gray)
//                    if dailySummaryViewModel.dailySummaryCategories.count > 0 {
//                        ScrollView(.vertical, showsIndicators: false) {
//                            VStack(spacing: 10) {
//                                ForEach(dailySummaryViewModel.dailySummaryCategories, id: \.self) { cat in
//                                    IndividualDailySummaryCategoriesView(dailySummary: cat, dailySummaryViewModel: dailySummaryViewModel)
//                                    Divider()
//                                }
//                            }
//                        }
//                    } else {
//                        CustomEmptyDataView(noDataText: "No daily summary for selected date")
//                    }
//                }
//                .padding([.leading, .trailing], 10)
//            }
//
//            if dailySummaryViewModel.dailySummaryCategories.count > 0 && dailySummaryViewModel.parentCanWrite {
//                ZStack(alignment: .bottomTrailing) {
//                    Button(action: {
//                        openFeedbackSheet = true
//                    }) {
//                        HStack {
//                            Image(systemName: "pencil")
//                            Text("Feedback")
//                        }
//                        .padding(10)
//                        .background(Color.orange)
//                        .foregroundColor(.white)
//                        .cornerRadius(25)
//                    }
//                    .padding()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
//                    .sheet(isPresented: $openFeedbackSheet) {
//                        ParentFeedbackSheetView(dailySummaryViewModel: dailySummaryViewModel, openFeedbackSheet: $openFeedbackSheet)
//                    }
//                }
//            }
//        }
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            dailySummaryViewModel.getDailySummary()
//        }
//    }
//}
