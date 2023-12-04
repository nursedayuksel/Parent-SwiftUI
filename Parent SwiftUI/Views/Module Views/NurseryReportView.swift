//
//  NurseryReportView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct NurseryReportView: View {
    // back
    @Environment(\.presentationMode) var presentationMode

    @State var showMonthPicker = false
    @State var selectButtonClicked = false
    
    @State var selectedMonthIndex: Int = Calendar.current.component(.month, from: Date())-1
    
    @ObservedObject var nurseryReportViewModel = NurseryReportViewModel()
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedMonthIndex,
            initialFunction: nurseryReportViewModel.initialNurseryReportProgress,
            pickerArray: $nurseryReportViewModel.monthDict,
            buttonFunction: selectMonth,
            selectedPickerValueName: $nurseryReportViewModel.selectedMonthName,
            noDataDescription: "You have no nursery reports",
            arrayCount: Binding<Int>(
                get: { nurseryReportViewModel.nurseryCategories.count == 0 ? nurseryReportViewModel.generalComment.count : nurseryReportViewModel.nurseryCategories.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Nursery Report",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        ScrollView(.vertical) {
                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(nurseryReportViewModel.nurseryCategories, id: \.self) { categories in
                                    IndividualCategoriesView(nurseryCategories: categories, nurseryReportViewModel: nurseryReportViewModel)
                                }
                                
                                if nurseryReportViewModel.generalComment != "" {
                                    
                                    VStack(alignment: .leading) {
                                        Text("General comment:")
                                            .foregroundColor(.black)
                                        HStack {
                                            Text("\(nurseryReportViewModel.generalComment)")
                                            Spacer()
                                        }
                                        .foregroundColor(.gray)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 20))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                    }
                                    .padding([.leading, .trailing], 8)
                                }
                            }
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                        }
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                }
            })
    }
    
    func selectMonth() {
        nurseryReportViewModel.getNurseryReportProgress(month: selectedMonthIndex + 1)
        nurseryReportViewModel.selectedMonthName = nurseryReportViewModel.monthDict[selectedMonthIndex]
    }
}

//struct NurseryReportView: View {
//    // back
//    @Environment(\.presentationMode) var presentationMode
//
//    @State var showMonthPicker = false
//    @State var selectButtonClicked = false
//
//    @State var selectedMonthIndex: Int = 0
//    @State var selectedMonthName = ""
//
//    @ObservedObject var nurseryReportViewModel = NurseryReportViewModel()
//
//    @State private var animate = 0.0
//
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0) {
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
//                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
//                            .frame(width: 70, height: 70)
//                            .background(Color.white)
//                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                            .offset(x: 30)
//                        Spacer()
//                        Text("Nursery Report")
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
//                HStack {
//                    Button(action: {
//                        showMonthPicker.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Text(selectButtonClicked ? "\(selectedMonthName)" : monthDict[Calendar.current.component(.month, from: Date())-1])
//                            .foregroundColor(Color.gray)
//                    }
//                    .padding(6)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
//                    .cornerRadius(4)
//
//
//                    Button(action: {
//                        showMonthPicker.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Image(systemName: "arrowtriangle.down.fill")
//                            .foregroundColor(Color.white)
//                            .font(.system(size: 10))
//                            .cornerRadius(4)
//                    }
//                    .padding(8)
//                    .background(Color("MyEduCare"))
//                    .cornerRadius(4)
//                }
//                .padding(7)
//
//                if nurseryReportViewModel.nurseryCategories.count == 0 && generalComment == "" {
//                    CustomEmptyDataView(noDataText: "You have no records")
//                } else {
//                    ScrollView(.vertical) {
//                        VStack(alignment: .leading, spacing: 10) {
//                            ForEach(nurseryReportViewModel.nurseryCategories, id: \.self) { categories in
//                                IndividualCategoriesView(nurseryCategories: categories, nurseryReportViewModel: nurseryReportViewModel)
//                            }
//                            if generalComment != "" {
//
//                                VStack(alignment: .leading) {
//                                    Text("General comment:")
//                                    HStack {
//                                        Text("\(generalComment)")
//                                        Spacer()
//                                    }
//                                    .foregroundColor(.gray)
//                                    .padding()
//                                    .frame(maxWidth: .infinity)
//                                    .background(Color.white)
//                                    .clipShape(RoundedRectangle(cornerRadius: 20))
//                                    .overlay(
//                                        RoundedRectangle(cornerRadius: 20)
//                                            .stroke(Color.black, lineWidth: 1)
//                                    )
//                                }
//                                .padding([.leading, .trailing], 8)
//                            }
//                        }
//                        .padding(.top, 20)
//                        .padding(.bottom, 20)
//                    }
//
//                    Spacer()
//                }
//            }
//
//            ZStack {
//                if showMonthPicker {
//                    Color.black.opacity(showMonthPicker ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack() {
//                            Spacer().frame(width: 300, alignment: .topTrailing)
//                            Button(action: {
//                                showMonthPicker = false
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
//                            Text("Select month")
//                                .bold()
//                                .foregroundColor(Color.black)
//                                .font(.system(size: 20))
//                            Picker(selection: $selectedMonthIndex, label: Text("Select subject")) {
//                                ForEach(monthDict.indices, id: \.self) { (index: Int) in
//                                    Text("\(monthDict[index])")
//                                }
//                            }
//                            .pickerStyle(WheelPickerStyle())
//
//                            Button(action: {
//                                showMonthPicker = false
//                                selectButtonClicked = true
//
//                                nurseryReportViewModel.getNurseryReportProgress(month: selectedMonthIndex + 1)
//                                withAnimation {
//                                    animate = 0
//                                }
//                                selectedMonthName = monthDict[selectedMonthIndex]
//                            }) {
//                                Text("Select")
//                                    .bold()
//                                    .foregroundColor(Color.white)
//                                    .font(.system(size: 20))
//                            }
//                            .padding(13)
//                            .frame(maxWidth: .infinity)
//                            .background(Color("MyEduCare"))
//                            .cornerRadius(9)
//                        }
//                    }
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(25)
//                    .frame(width: 200)
//                    .scaleEffect(animate)
//                }
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .background(Color("Background"))
//        .onAppear {
//            nurseryReportViewModel.getNurseryReportProgress(month: Calendar.current.component(.month, from: Date()))
//        }
//    }}
