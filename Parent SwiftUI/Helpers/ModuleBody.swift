//
//  ModuleBody.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 04.05.2023.
//

import SwiftUI

struct ModuleBody<HeaderContent: View, BodyContent: View>: View {
    let headerContent: HeaderContent
    let text: String
    let bodyContent: BodyContent
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var delegate: AppDelegate
    
    @Binding var isLoading: Bool
    @Binding var arrayCount: Int
    
    @State var choosePickerClicked: Bool = false
    @Binding var selectedPickerIndex: Int
    
    @Binding var selectedPickerValueName: String
    @Binding var pickerArray: [String]
    
    var noDataIcon: String = "exclamationmark.icloud"
    var noDataDescription: String = ""
    @State private var animate = 0.0
    var buttonFunction: () -> Void
    var initialFunction: () -> Void
    
    init(selectedPickerIndex: Binding<Int>, initialFunction: @escaping () -> Void, pickerArray: Binding<[String]>, buttonFunction: @escaping () -> Void, selectedPickerValueName: Binding<String>, noDataIcon: String = "exclamationmark.icloud", noDataDescription:String = "", arrayCount: Binding<Int>, isLoading: Binding<Bool>, ModuleName: String, @ViewBuilder HeaderContent: () -> HeaderContent, @ViewBuilder BodyContent: () -> BodyContent) {
        self.headerContent = HeaderContent()
        self.text = ModuleName
        self.bodyContent = BodyContent()
        _arrayCount = arrayCount
        _isLoading = isLoading
        self.noDataIcon = noDataIcon
        self.noDataDescription = noDataDescription
        _selectedPickerValueName = selectedPickerValueName
        self.buttonFunction = buttonFunction
        _pickerArray = pickerArray
        self.initialFunction = initialFunction
        _selectedPickerIndex = selectedPickerIndex
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack{
                    VStack {
                        ZStack {
                            HStack {
                                Button(action: {
                                    if delegate.job == "" {
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        delegate.job = "home"
                                    }
                                }) {
                                    Image(systemName: "arrow.left")
                                        .frame(height: 96, alignment: .trailing)
                                }
                                .offset(y: -20)
                                .frame( alignment: .topLeading)
                                .font(.system(size: 27))
                                .foregroundColor(Color("MyEduCare"))
                                
                                Spacer()
                                
                                Text(text)
                                    .bold()
                                    .offset(y: -20)
                                    .font(.system(size: 17))
                                    .foregroundColor(Color("MyEduCare"))
                            }
                            
                            HStack {
                                UserImage()
                            }
                        }
                        
                        if pickerArray.count > 0 {
                            HStack {
                                Button(action: {
                                    self.choosePickerClicked.toggle()
                                    
                                    withAnimation {
                                        animate = 1
                                    }
                                }) {
                                    Text(selectedPickerValueName)
                                        .foregroundColor(Color.gray)
                                        .padding(6)
                                        .frame(maxWidth: .infinity)
                                        .background(Color(UIColor.secondarySystemBackground))
                                        .cornerRadius(4)
                                }
                                
                                Button(action: {
                                    self.choosePickerClicked.toggle()
                                    
                                    withAnimation {
                                        animate = 1
                                    }
                                }) {
                                    Image(systemName: "arrowtriangle.down.fill")
                                        .foregroundColor(Color.white)
                                        .font(.system(size: 15))
                                        .cornerRadius(4)
                                }
                                .padding(8)
                                .background(Color("MyEduCare"))
                                .cornerRadius(4)
                            }
                        }
                    }
                    .padding([.top, .bottom, .leading,.trailing], 10)
                    .background(Color.white)
                    
                    headerContent
                }
                
                if arrayCount > 0 {
                    VStack(spacing: 15) {
                        bodyContent
                        Spacer()
                    }
                    .background(Color(UIColor.secondarySystemBackground))
                } else {
                    if isLoading {
                        VStack (spacing: 0) {
                            Spacer()
                            HStack {
                                Spacer()
                                ProgressView()
                                    .tint(Color("MyEduCare"))
                                    .scaleEffect(1.5)
                                    .onAppear {
                                        // Wait for 3 seconds before showing the "You have no exams" message
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            isLoading = false
                                        }
                                    }
                                Spacer()
                            }
                            Spacer()
                        }
                        .background(Color.black.opacity(0.2))
                    } else {
                        VStack {
                            Spacer()
                            Image(systemName: noDataIcon)
                                .foregroundColor(Color("MyEduCare"))
                                .font(.system(size: 150))
                                .offset(y: -15)
                            Text(noDataDescription)
                                .bold()
                                .foregroundColor(.gray)
                                .font(.system(size: 20))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.secondarySystemBackground))
                    }
                }
            }
            
            ZStack {
                if choosePickerClicked {
                    Color.black.opacity(choosePickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)

                    VStack(alignment: .center, spacing: 0) {
                        HStack {
                            Spacer()
                            Button(action: {
                                choosePickerClicked = false

                                withAnimation {
                                    animate = 0
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.black)
                            }
                        }
                        VStack {
                            Picker(selection: $selectedPickerIndex, label: Text("Select Term")) {
                                ForEach(pickerArray.indices, id: \.self) { (index: Int) in
                                    Text("\(pickerArray[index])")
                                }
                            }.pickerStyle(WheelPickerStyle())
                            
                            Button(action: {
                                
                                buttonFunction()
                                
                                choosePickerClicked = false
                                print("picker index is: \(selectedPickerIndex)")

                                withAnimation {
                                    animate = 0
                                }
                            }) {
                                Text("Select")
                                    .bold()
                                    .padding(13)
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20))
                                    .frame(maxWidth: .infinity)
                                    .background(Color("MyEduCare"))
                                    .cornerRadius(9)
                            }
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(25)
                    .frame(width: 300)
                    .scaleEffect(animate)
                }
            }
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .onAppear {
            initialFunction()
        }
    }
}
