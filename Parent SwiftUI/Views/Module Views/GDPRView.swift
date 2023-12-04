//
//  GDPRView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct GDPRView: View {
    // back
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var gdprViewModel = GDPRViewModel()
    
    @State var showEducationalYearPicker = false
    @State var showAlert = false
    @State var selectButtonClicked = false
    @State var animationSwitch = true
    @State var changePicker = false
    
    @State var selectedYearIndex = 0
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedYearIndex,
            initialFunction: gdprViewModel.getGDPREducationalYears,
            pickerArray: $gdprViewModel.displayYearArray,
            buttonFunction: selectYear,
            selectedPickerValueName: $gdprViewModel.selectedYearName,
            noDataDescription: "You have no posts",
            arrayCount: Binding<Int>(
                get: { gdprViewModel.gdpr.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Edu-Social",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(gdprViewModel.gdpr.indices, id: \.self) { (index: Int) in
                                    IndividualGDPRRulesView(gdpr: gdprViewModel.gdpr[index], gdprViewModel: gdprViewModel, index: index)
                                    Divider()
                                }
                            }
                        }
                        .background(Color("Background"))
                        
                        if gdprViewModel.parentAnswersArray.count == 0 {
                            Button(action: {
                                showAlert = true
                            }) {
                                Text("Save Form")
                                    .padding(8)
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.white)
                                    .background(Color("MyEduCare"))
                                    .cornerRadius(15)
                            }
                            .padding([.leading, .trailing], 8)
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Warning!"), message: Text("You can only fill in the GDPR form once! Are you sure you want to proceed?"), primaryButton: .destructive(Text("YES")) {
                                    gdprViewModel.sendGDPRForm(db: gdprViewModel.selectedDb)
                                }, secondaryButton: .default(Text("NO")))
                            }
                            
                            Text("")
                                .alert(isPresented: $gdprViewModel.areYouSureClicked) {
                                    Alert(title: Text("Success!"), message: Text("\(gdprViewModel.successMessage)"), dismissButton: .default(Text("Done")) {
                                        presentationMode.wrappedValue.dismiss()
                                    })
                                }
                        }
                    }
                    .padding([.top, .bottom], 10)
                    .background(Color(UIColor.secondarySystemBackground))
                    .onAppear {
                        isLoading = false
                    }
                }
            })
    }
    
    func selectYear() {
        gdprViewModel.selectedYearName = gdprViewModel.gdprYears[selectedYearIndex].displayYear
        gdprViewModel.selectedDb = gdprViewModel.gdprYears[selectedYearIndex].db
        gdprViewModel.getGDPRRules(db: gdprViewModel.gdprYears[selectedYearIndex].db)
    }
}

//struct GDPRView: View {
//    // back
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var gdprViewModel = GDPRViewModel()
//
//    @State var showEducationalYearPicker = false
//    @State var showAlert = false
//    @State var selectButtonClicked = false
//    @State var animationSwitch = true
//    @State var changePicker = false
//
//    @State var selectedYearIndex = 0
//    @State var selectedYear = ""
//    @State var selectedDb = ""
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
//                        .padding(.leading, 8)
//                        Spacer()
//                        VStack(alignment: .center) {
//                            WebImage(url: URL(string: studentPhoto))
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 70, height: 70)
//                                .background(Color.white)
//                                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                                .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                        }
//                        .offset(x: 30)
//
//                        Spacer()
//                        Text("GDPR Form")
//                            .foregroundColor(Color.white)
//                            .bold()
//                            .font(.system(size: 16))
//                            .offset(y: -35)
//
//                    }
//                }
//                .padding(7)
//                .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//                HStack {
//                    Button(action: {
//                        showEducationalYearPicker.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        if gdprViewModel.gdprYears.count > 0 {
//                            Text("\(changePicker ? selectedYear : gdprViewModel.gdprYears[0].displayYear)")
//                                .foregroundColor(Color.gray)
//                        }
//                    }
//                    .padding(6)
//                    .frame(maxWidth: .infinity)
//                    .background(Color.white)
//                    .cornerRadius(4)
//
//
//                    Button(action: {
//                        showEducationalYearPicker.toggle()
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
//                Spacer()
//
//                if gdprViewModel.gdpr.count == 0 {
//                    Spacer()
//                    Image(systemName: "exclamationmark.icloud")
//                        .foregroundColor(Color("MyEduCare"))
//                        .font(.system(size: 150))
//                        .offset(y: -15)
//
//                    Text("No existing form")
//                        .bold()
//                        .foregroundColor(.gray)
//                        .font(.system(size: 20))
//
//                    Spacer()
//                    Spacer()
//                } else {
//                    ScrollView(.vertical, showsIndicators: false) {
//                        VStack(alignment: .leading, spacing: 20) {
//                            ForEach(gdprViewModel.gdpr.indices, id: \.self) { (index: Int) in
//                                IndividualGDPRRulesView(gdpr: gdprViewModel.gdpr[index], gdprViewModel: gdprViewModel, index: index)
//                                Divider()
//                            }
//                        }
//                    }
//                    .background(Color("Background"))
//
//                    if gdprViewModel.parentAnswersArray.count == 0 {
//                        Button(action: {
//                            showAlert = true
//                        }) {
//                            Text("Save Form")
//                                .padding(8)
//                                .frame(maxWidth: .infinity)
//                                .foregroundColor(.white)
//                                .background(Color("MyEduCare"))
//                                .cornerRadius(15)
//                        }
//                        .padding([.leading, .trailing], 8)
//                        .alert(isPresented: $showAlert) {
//                            Alert(title: Text("Warning!"), message: Text("You can only fill in the GDPR form once! Are you sure you want to proceed?"), primaryButton: .destructive(Text("YES")) {
//                                gdprViewModel.sendGDPRForm(db: selectedDb)
//                            }, secondaryButton: .default(Text("NO")))
//                        }
//
//                        Text("")
//                            .alert(isPresented: $gdprViewModel.areYouSureClicked) {
//                                Alert(title: Text("Success!"), message: Text("\(gdprViewModel.successMessage)"), dismissButton: .default(Text("Done")) {
//                                    presentationMode.wrappedValue.dismiss()
//                                })
//                            }
//                    }
//                }
//            }
//            .background(Color("Background").edgesIgnoringSafeArea(.bottom))
//
//            ZStack {
//                if selectButtonClicked {
//                    if animationSwitch {
//                        Color.black.opacity(animationSwitch ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//                        ActivityIndicator()
//                            .frame(width: 200, height: 200)
//                            .foregroundColor(Color("MyEduCare"))
//                            .onAppear {
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                                    //self.animationSwitch = false
//                                    self.selectButtonClicked = false
//                                }
//                            }
//                    }
//                }
//            }
//
//            ZStack {
//                if showEducationalYearPicker {
//                    Color.black.opacity(showEducationalYearPicker ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack() {
//                            Spacer().frame(width: 300, alignment: .topTrailing)
//                            Button(action: {
//                                showEducationalYearPicker = false
//
//                                withAnimation {
//                                    animate = 0
//                                }
//
//                            }) {
//                                Image(systemName: "xmark")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 15, height: 15)
//                                    .foregroundColor(Color.black)
//                            }
//                        }
//                        VStack {
//                            Text("Select subject")
//                                .bold()
//                                .foregroundColor(Color.black)
//                                .font(.system(size: 20))
//                            Picker(selection: $selectedYearIndex, label: Text("Select Subject")) {
//                                ForEach(gdprViewModel.displayYearArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(gdprViewModel.displayYearArray[index])")
//                                }
//                            }
//                            .pickerStyle(WheelPickerStyle())
//
//                            Button(action: {
//                                selectedYear = gdprViewModel.gdprYears[selectedYearIndex].displayYear
//                                selectedDb = gdprViewModel.gdprYears[selectedYearIndex].db
//
//                                gdprViewModel.getGDPRRules(db: gdprViewModel.gdprYears[selectedYearIndex].db)
//
//                                showEducationalYearPicker = false
//                                selectButtonClicked = true
//                                changePicker = true
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
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            gdprViewModel.getGDPRRules(db: UserDefaults.standard.string(forKey: "db")!)
//            gdprViewModel.getGDPREducationalYears()
//            selectedDb = UserDefaults.standard.string(forKey: "db")!
//        }
//    }
//}

