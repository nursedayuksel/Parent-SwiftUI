//
//  MainPageView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct MainPageView: View {
    // back
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var delegate: AppDelegate
    
    @StateObject var moduleCheckViewModel = ModuleCheckViewModel()
    @ObservedObject var childrenViewModel: ChildrenViewModel
    
    @State var selectedStudentIdx: String
    
    var navigationHelper = NavigationHelper()
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    delegate.job = ""
                    if delegate.job == "" {
                        presentationMode.wrappedValue.dismiss()
                    }
                    childrenViewModel.loadBadgesForEachStudent(studentIdx: selectedStudentIdx)
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                }
                .offset(y: -45)
                
                Spacer()
                
                VStack {
                    WebImage(url: URL(string: studentPhoto))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 90, height: 90)
                        .background(Color.white)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    Text("\(studentName) - \(studentClass)")
                        .bold()
                        .foregroundColor(.white)
                }
                .offset(x: -15)
                
                Spacer()
            }
            .padding([.leading, .trailing], 10)
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 30)), count: 3), spacing: 40) {
                    ForEach(0..<moduleNames.count, id: \.self) { (index: Int) in
                        if !moduleCheckViewModel.moduleBanCode.contains(String(moduleCheckViewModel.moduleDict[moduleNames[index]] ?? 0)) {
                            NavigationLink(destination: navigationHelper.navigateToModules(moduleName: moduleNames[index])) {
                                ZStack {
                                    VStack(spacing: 7) {
                                        if moduleCheckViewModel.moduleBadgeCode.contains(moduleCodes[index]) && moduleCheckViewModel.moduleBadgeCounter[moduleCodes[index]] != "0" {
                                            Image("\(moduleImages[index])")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                                .overlay(
                                                    Text("\(moduleCheckViewModel.moduleBadgeCounter[moduleCodes[index]]!)")
                                                        .padding(6)
                                                        .font(.system(size: 14))
                                                        .background(Color.red)
                                                        .foregroundColor(.white)
                                                        .clipShape(Circle())
                                                        .offset(x: 10, y: -10), alignment: .topTrailing)
                                        } else {
                                            Image("\(moduleImages[index])")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                        }
                                        
                                        Text(LocalizedStringKey(moduleNames[index]))
                                            .foregroundColor(Color(UIColor.darkGray))
                                            .font(.system(size: 15))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.top, 40)
            }
            .background(Rectangle()
                .fill(Color(UIColor.secondarySystemBackground))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .ignoresSafeArea())
        }
        .background(Color("MyEduCare").ignoresSafeArea())
        .onAppear {
            moduleCheckViewModel.loadBadges()
            //delegate.job = ""
        }
    }
}
