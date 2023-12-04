//
//  ReadingView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReadingView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var readingViewModel = ReadingViewModel()
    
    @State private var isLoading = true
    
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    @State var selectedPickerIndex = 0
        
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: readingViewModel.getBookList,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "You have no readings",
            arrayCount: Binding<Int>(
            get: { readingViewModel.books.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Reading",
            HeaderContent: {},
            BodyContent: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 10) {
                        ForEach(readingViewModel.books, id: \.self) { book in
                            IndividualBookCardView(books: book)
                        }
                    }
                    .padding([.top, .bottom], 10)
                }
                .background(Color(UIColor.secondarySystemBackground))
                .onAppear {
                    isLoading = false
                }
            })
    }
}

//struct ReadingView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var readingViewModel = ReadingViewModel()
//
//    var body: some View {
//        VStack(spacing: 0) {
//            VStack {
//                HStack {
//                    Button(action: {
//                        presentationMode.wrappedValue.dismiss()
//                    }) {
//                        Image(systemName: "arrow.backward")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 20, height: 20)
//                            .foregroundColor(Color.white)
//                    }
//                    .offset(y: -30)
//                    .padding(.leading, 8)
//
//                    Spacer()
//
//                    WebImage(url: URL(string: studentPhoto))
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 70, height: 70)
//                        .background(Color.white)
//                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
//                        .offset(x: 15)
//
//                    Spacer()
//
//                    Text("Reading")
//                        .foregroundColor(Color.white)
//                        .bold()
//                        .font(.system(size: 16))
//                        .offset(y: -35)
//
//                }
//            }
//            .padding(7)
//            .background(Color("MyEduCare").edgesIgnoringSafeArea(.top))
//
//            if readingViewModel.books.count > 0 {
//                ScrollView(.vertical, showsIndicators: false) {
//                    VStack(spacing: 10) {
//                        ForEach(readingViewModel.books, id: \.self) { book in
//                            VStack {
//                                IndividualBookCardView(books: book)
//                            }
//                            .padding(.top, 10)
//                        }
//                    }
//                }
//                .background(Color("Background"))
//            } else {
//                CustomEmptyDataView(noDataText: "You have no books")
//            }
//        }
//        .navigationBarBackButtonHidden()
//        .onAppear {
//            readingViewModel.getBookList()
//        }
//    }
//}
