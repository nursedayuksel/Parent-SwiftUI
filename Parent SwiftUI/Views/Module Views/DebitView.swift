//
//  DebitView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct DebitView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var debitViewModel = DebitViewModel()
    
    @State private var animate = 0.0
    
    @State var showYearPicker = false

    @State var selectedYearIdx = ""
    @State var selectedDb = ""
    
    @State var selectButtonClicked = false
    
    @State var showWebView = false
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $debitViewModel.selectedYearIndex,
            initialFunction: debitViewModel.getYears,
            pickerArray: $debitViewModel.yearsArray,
            buttonFunction: selectYear,
            selectedPickerValueName: $debitViewModel.selectedYearName,
            noDataDescription: "You have no debits",
            arrayCount: Binding<Int>(
                get: { debitViewModel.debits.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Debits",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 10) {
                                ForEach(debitViewModel.debits.indices, id: \.self) { (index: Int) in
                                    IndividualDebitView(debits: debitViewModel.debits[index], debitViewModel: debitViewModel, index: index)
                                }
                            }
                            .padding([.top, .bottom], 10)
                        }
                        
                        if debitViewModel.installmentClickedIdxs.count > 0 {
                            HStack(spacing: 20) {
                                Text("\(debitViewModel.totalAmountFormatted) RON")
                                    .foregroundColor(Color("MyEduCare"))
                                Spacer()
                                Button(action: {
                                    debitViewModel.getPaymentUrl()
                                    showWebView = true
                                    
                                    print(debitViewModel.paymentUrl)
                                }) {
                                    HStack {
                                        Text("Pay")
                                    }
                                    .padding(13)
                                    .foregroundColor(.white)
                                    .background(Color("MyEduCare"))
                                    .cornerRadius(15)
                                }
                                .sheet(isPresented: $debitViewModel.showWebView) {
                                    WebView(url: "\(debitViewModel.paymentUrl)")
                                }
                            }
                            .padding([.leading, .trailing], 10)
                        }
                        
                        Spacer()
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                }
            })
    }
    
    func selectYear() {
        debitViewModel.selectedYearName = debitViewModel.educationalYears[debitViewModel.selectedYearIndex].display

        debitViewModel.getDebits(selectedDb: debitViewModel.dbsArray[debitViewModel.selectedYearIndex])
        
        debitViewModel.selectedDb = debitViewModel.dbsArray[debitViewModel.selectedYearIndex]
        
        debitViewModel.installmentClickedDict = [:]
        debitViewModel.installmentsDict = [:]
        debitViewModel.installmentCurrencyDict = [:]
        debitViewModel.installmentClickedIdxs = []
        debitViewModel.totalAmount = 0.0
        debitViewModel.totalAmountRounded = "0.0"
        debitViewModel.isExpandedArray = []
        
        for _ in 0..<debitViewModel.debits.count {
            debitViewModel.isExpandedArray.append(false)
        }
    }
}

//struct DebitView: View {
//    
//    @Environment(\.presentationMode) var presentationMode
//    
//    @StateObject var debitViewModel = DebitViewModel()
//    
//    @State private var animate = 0.0
//    
//    @State var showYearPicker = false
//
//    @State var selectedYearIdx = ""
//    @State var selectedDb = ""
//    
//    @State var selectButtonClicked = false
//    
//    @State var showWebView = false
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
//                            .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
//                            .frame(width: 70, height: 70)
//                            .background(Color.white)
//                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                        Spacer()
//                        Text("Debits")
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
//                        showYearPicker.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Text("\(debitViewModel.selectedYearName)")
//                            .foregroundColor(Color.gray)
//                            .padding(6)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(4)
//                    }
//                    
//                    Button(action: {
//                        showYearPicker.toggle()
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
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(spacing: 20) {
//                        ForEach(debitViewModel.debits.indices, id: \.self) { (index: Int) in
//                            IndividualDebitView(debits: debitViewModel.debits[index], debitViewModel: debitViewModel, index: index)
//                        }
//                    }
//                    .padding(10)
//                }
//                
//                if debitViewModel.installmentClickedIdxs.count > 0 {
//                    HStack(spacing: 20) {
//                        Text("\(debitViewModel.totalAmountFormatted) RON")
//                            .foregroundColor(Color("MyEduCare"))
//                        Spacer()
//                        Button(action: {
//                            debitViewModel.getPaymentUrl()
//                            showWebView = true
//                            
//                            print(debitViewModel.paymentUrl)
//                        }) {
//                            HStack {
//                                Text("Pay")
//                            }
//                            .padding(13)
//                            .foregroundColor(.white)
//                            .background(Color("MyEduCare"))
//                            .cornerRadius(15)
//                        }
//                        .sheet(isPresented: $debitViewModel.showWebView) {
//                            WebView(url: "\(debitViewModel.paymentUrl)")
//                        }
//                    }
//                    .padding([.leading, .trailing], 10)
//                }
//                
//                Spacer()
//            }
//            
//            ZStack {
//                if showYearPicker {
//                    Color.black.opacity(showYearPicker ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//                        
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer().frame(width: 300, alignment: .topTrailing)
//                            Button(action: {
//                                showYearPicker = false
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
//                            Text("Select Year")
//                                .bold()
//                                .foregroundColor(Color.black)
//                                .font(.system(size: 20))
//                            Picker(selection: $debitViewModel.selectedYearIndex, label: Text("Select Subject")) {
//                                ForEach(debitViewModel.yearsArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(debitViewModel.yearsArray[index])")
//                                }
//                            }
//                            .pickerStyle(WheelPickerStyle())
//                     
//                            Button(action: {
//                                
//                                debitViewModel.selectedYearName = debitViewModel.educationalYears[debitViewModel.selectedYearIndex].display
//    
//                                debitViewModel.getDebits(selectedDb: debitViewModel.dbsArray[debitViewModel.selectedYearIndex])
//                                
//                                debitViewModel.selectedDb = debitViewModel.dbsArray[debitViewModel.selectedYearIndex]
//                                
//                                showYearPicker = false
//                                selectButtonClicked = true
//                                
//                                debitViewModel.installmentClickedDict = [:]
//                                debitViewModel.installmentsDict = [:]
//                                debitViewModel.installmentCurrencyDict = [:]
//                                debitViewModel.installmentClickedIdxs = []
//                                debitViewModel.totalAmount = 0.0
//                                debitViewModel.totalAmountRounded = "0.0"
//                                debitViewModel.isExpandedArray = []
//                                
//                                for _ in 0..<debitViewModel.debits.count {
//                                    debitViewModel.isExpandedArray.append(false)
//                                }
//                                
//                                withAnimation {
//                                    animate = 0
//                                }
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
//        .background(Color("Background"))
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            debitViewModel.getYears()
//        }
//    }
//}

