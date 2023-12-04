//
//  HomeworkView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeworkView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var homeworkViewModel = HomeworkViewModel()
    
    @State var showIndividualContent: Bool = false
    @State var showView: Bool = true
    @State var isFirstHomework: Bool = true
    @State var filterButtonClicked: Bool = false
    @State var isChooseSemesterPickerClicked: Bool = false
    @State var isSelectSemesterButtonClicked: Bool = false
    
    @State var selectedSemesterIndex = 0
    @State var selectedFilterIndex = 0
    
    @State var homeworkIdx = ""
    @State var selectedCategoryName = ""
    @State var selectedSemesterName = ""

    @State private var animate = 0.0
    
    @State var indivHomework: Homework?
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $homeworkViewModel.selectedSemesterIndex,
            initialFunction: homeworkViewModel.getHomeworkSemesters,
            pickerArray: $homeworkViewModel.homeworkSemesterNamesArray,
            buttonFunction: selectSemester,
            selectedPickerValueName: $homeworkViewModel.currentSelectedSemesterName,
            noDataDescription: "You have no homeworks",
            arrayCount: Binding<Int>(
                get: { homeworkViewModel.homework.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Homework",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if homeworkViewModel.homework.count > 0 {
                            VStack {
                                //filter buttons
                                HStack(spacing: 10) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(homeworkViewModel.uniqueHomeworkCategoriesArray.indices, id: \.self) { (index: Int) in
                                                Button(action: {
                                                    filterButtonClicked = true
                                                    selectedCategoryName = homeworkViewModel.uniqueHomeworkCategoriesArray[index]
                                                    selectedFilterIndex = index
                                                
                                                }) {
                                                    HStack {
                                                        Text("\(homeworkViewModel.homeworkCategoriesCount(categoryName: homeworkViewModel.uniqueHomeworkCategoriesArray[index]))")
                                                        Text(LocalizedStringKey(homeworkViewModel.uniqueHomeworkCategoriesArray[index]))
                                                    }
                                                    .font(.system(size: 14))
                                                    .padding(8)
                                                }
                                                .foregroundColor(filterButtonClicked ? selectedCategoryName == homeworkViewModel.uniqueHomeworkCategoriesArray[index] ? .white : homeworkViewModel.getEveryHomeworkColor(index: index) : homeworkViewModel.getEveryHomeworkColor(index: index))
                                                .background(filterButtonClicked ? selectedCategoryName == homeworkViewModel.uniqueHomeworkCategoriesArray[index] ? homeworkViewModel.getEveryHomeworkColor(index: index) : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
                                                .cornerRadius(20)
                                                .overlay(RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundColor(homeworkViewModel.getEveryHomeworkColor(index: index)))
                                            }
                                        }
                                        .padding(.top, 10)
                                        .padding([.leading, .trailing, .bottom], 1)
                                    }
                                }
                                .padding([.leading, .trailing], 10)
                                
                                ScrollView(.vertical, showsIndicators: false) {
                                    VStack(spacing: 10) {
                                        if filterButtonClicked {
                                            ForEach(homeworkViewModel.filterHomeworks(categoryName: selectedCategoryName), id: \.self) { filteredHomeworks in
                                                Button(action: {
                                                    showIndividualContent = true
                                                    isFirstHomework = false

                                                    homeworkIdx = filteredHomeworks.homeworkIdx
                                                    
                                                    indivHomework = filteredHomeworks
                                                    
                                                   // call get single homework function

                                                }) {
                                                    VStack {
                                                        IndividualHomeworksCardView(homework: filteredHomeworks, homeworkViewModel: homeworkViewModel, index: selectedFilterIndex)
                                                    }
                                                }
                                            }
                                            .sheet(item: $indivHomework) { indivHomework in
                                                ExtendHomeworkView(homework: indivHomework, selectedFilterIndex: selectedFilterIndex, homeworkViewModel: homeworkViewModel)
                                            }
                                        } else {
                                            ForEach(homeworkViewModel.homework, id: \.id) { homework in
                                                Button(action: {
                                                    showIndividualContent = true
                                                    isFirstHomework = false
                                                    
                                                    homeworkIdx = homework.homeworkIdx
                                                    
                                                    print(homework.homeworkIdx)
                                                    
                                                    homeworkViewModel.getSingleHomework(homework: homework)
                                                    
                                                    indivHomework = homework
                                                }) {
                                                    VStack {
                                                        IndividualHomeworksCardView(homework: homework, homeworkViewModel: homeworkViewModel, index: selectedFilterIndex)
                                                    }
                                                }

                                            }
                                            .sheet(item: $indivHomework) { indivHomework in
                                                ExtendHomeworkView(homework: indivHomework, selectedFilterIndex: selectedFilterIndex, homeworkViewModel: homeworkViewModel)
                                            }
                                        }
                                    }
                                    .padding([.top, .bottom], 10)
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
        homeworkViewModel.getHomeworks(semester_idx: homeworkViewModel.homeworkSemesters[homeworkViewModel.selectedSemesterIndex].semesterIdx)

        homeworkViewModel.currentSelectedSemesterName = homeworkViewModel.homeworkSemesters[homeworkViewModel.selectedSemesterIndex].termName
    }
}

//struct HomeworkView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var homeworkViewModel = HomeworkViewModel()
//
//    @State var showIndividualContent: Bool = false
//    @State var showView: Bool = true
//    @State var isFirstHomework: Bool = true
//    @State var filterButtonClicked: Bool = false
//    @State var isChooseSemesterPickerClicked: Bool = false
//    @State var isSelectSemesterButtonClicked: Bool = false
//
//    @State var selectedSemesterIndex = 0
//    @State var selectedFilterIndex = 0
//
//    @State var homeworkIdx = ""
//    @State var selectedCategoryName = ""
//    @State var selectedSemesterName = ""
//
//    @State private var animate = 0.0
//
//    @State var indivHomework: Homework?
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
//                            .offset(x: 10)
//                        Spacer()
//                        Text("Homework")
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
//                        isChooseSemesterPickerClicked.toggle()
//                        withAnimation {
//                            animate = 1
//                        }
//                    }) {
//                        Text("\(isSelectSemesterButtonClicked ? selectedSemesterName : homeworkViewModel.currentSelectedSemesterName)")
//                            .foregroundColor(Color.gray)
//                            .padding(6)
//                            .frame(maxWidth: .infinity)
//                            .background(Color.white)
//                            .cornerRadius(4)
//                    }
//
//                    Button(action: {
//                        isChooseSemesterPickerClicked.toggle()
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
//                if homeworkViewModel.homework.count > 0 {
//                    VStack {
//                        //filter buttons
//                        HStack(spacing: 10) {
//                            Image(systemName: "chevron.left")
//                                .foregroundColor(.gray)
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack {
//                                    ForEach(homeworkViewModel.uniqueHomeworkCategoriesArray.indices, id: \.self) { (index: Int) in
//                                        Button(action: {
//                                            filterButtonClicked = true
//                                            selectedCategoryName = homeworkViewModel.uniqueHomeworkCategoriesArray[index]
//                                            selectedFilterIndex = index
//
//                                        }) {
//                                            HStack {
//                                                Text("\(homeworkViewModel.homeworkCategoriesCount(categoryName: homeworkViewModel.uniqueHomeworkCategoriesArray[index]))")
//                                                Text(LocalizedStringKey(homeworkViewModel.uniqueHomeworkCategoriesArray[index]))
//                                            }
//                                            .font(.system(size: 14))
//                                            .padding(8)
//                                        }
//                                        .foregroundColor(filterButtonClicked ? selectedCategoryName == homeworkViewModel.uniqueHomeworkCategoriesArray[index] ? .white : homeworkViewModel.getEveryHomeworkColor(index: index) : homeworkViewModel.getEveryHomeworkColor(index: index))
//                                        .background(filterButtonClicked ? selectedCategoryName == homeworkViewModel.uniqueHomeworkCategoriesArray[index] ? homeworkViewModel.getEveryHomeworkColor(index: index) : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
//                                        .cornerRadius(20)
//                                        .overlay(RoundedRectangle(cornerRadius: 20)
//                                            .stroke(lineWidth: 1)
//                                            .foregroundColor(homeworkViewModel.getEveryHomeworkColor(index: index)))
//                                    }
//                                }
//                                .padding(5)
//                            }
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.gray)
//                        }
//                        ScrollView(.vertical, showsIndicators: false) {
//                            VStack(spacing: 10) {
//                                if filterButtonClicked {
//                                    ForEach(homeworkViewModel.filterHomeworks(categoryName: selectedCategoryName), id: \.self) { filteredHomeworks in
//                                        Button(action: {
//                                            showIndividualContent = true
//                                            isFirstHomework = false
//
//                                            homeworkIdx = filteredHomeworks.homeworkIdx
//
//                                           // call get single homework function
//
//                                        }) {
//                                            VStack {
//                                                IndividualHomeworksCardView(homework: filteredHomeworks, homeworkViewModel: homeworkViewModel, index: selectedFilterIndex)
//                                            }
//                                        }
//                                    }
//                                } else {
//                                    ForEach(homeworkViewModel.homework, id: \.id) { homework in
//                                        Button(action: {
//                                            showIndividualContent = true
//                                            isFirstHomework = false
//
//                                            homeworkIdx = homework.homeworkIdx
//
//                                            print(homework.homeworkIdx)
//
//                                            homeworkViewModel.getSingleHomework(homework: homework)
//
//                                            indivHomework = homework
//                                        }) {
//                                            VStack {
//                                                IndividualHomeworksCardView(homework: homework, homeworkViewModel: homeworkViewModel, index: selectedFilterIndex)
//                                            }
//                                        }
//
//                                    }
//                                    .sheet(item: $indivHomework) { indivHomework in
//                                        ExtendHomeworkView(homework: indivHomework, selectedFilterIndex: selectedFilterIndex, homeworkViewModel: homeworkViewModel)
//                                    }
//                                }
//                            }
//                            .padding([.top, .bottom], 10)
//                        }
//                    }
//                    .padding([.leading, .trailing], 10)
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no homeworks")
//                }
//            }
//
//            // semester picker
//            ZStack {
//                if isChooseSemesterPickerClicked {
//                    Color.black.opacity(isChooseSemesterPickerClicked ? 0.3 : 0).edgesIgnoringSafeArea(.all)
//
//                    VStack(alignment: .center, spacing: 0) {
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                isChooseSemesterPickerClicked = false
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
//
//                        VStack {
//                            Picker(selection: $selectedSemesterIndex, label: Text("Select Term")) {
//                                ForEach(homeworkViewModel.homeworkSemesterNamesArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(homeworkViewModel.homeworkSemesterNamesArray[index])")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//
//                            Button(action: {
//                                homeworkViewModel.getHomeworks(semester_idx: homeworkViewModel.homeworkSemesters[selectedSemesterIndex].semesterIdx)
//
//                                selectedSemesterName = homeworkViewModel.homeworkSemesters[selectedSemesterIndex].termName
//
//                                isChooseSemesterPickerClicked = false
//                                isSelectSemesterButtonClicked = true
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
//
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
//            homeworkViewModel.getHomeworkSemesters()
//        }
//    }
//}
