//
//  CommentsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentsView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject var commentsViewModel = CommentViewModel()
    
    @State var showIndividualContent: Bool = false
    @State var showView: Bool = true
    @State var isFirstComment: Bool = true
    @State var filterButtonClicked: Bool = false
    @State var isChooseSemesterPickerClicked: Bool = false
    @State var isSelectSemesterButtonClicked: Bool = false
    
    @State var selectedSemesterIndex = 0
    
    @State var commentIdx = ""
    @State var selectedCategoryName = ""
    @State var selectedSemesterName = ""
    
    @State private var animate = 0.0
    
    @State var indivComment: Comments?
    
    @State private var isLoading = true
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $commentsViewModel.selectedSemesterIndex,
            initialFunction: commentsViewModel.getCommentsSemesters,
            pickerArray: $commentsViewModel.commentSemesterNamesArray,
            buttonFunction: selectSemester,
            selectedPickerValueName: $commentsViewModel.currentSelectedSemesterName,
            noDataDescription: "You have no comments",
            arrayCount: Binding<Int>(
                get: { commentsViewModel.comments.count },
                set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Comments",
            HeaderContent: {},
            BodyContent: {
                ZStack {
                    VStack {
                        if commentsViewModel.comments.count > 0 {
                            VStack {
                                //filter buttons
                                HStack(alignment: .center, spacing: 10) {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(commentsViewModel.uniqueCommentCategoriesArray.indices, id: \.self) { (index: Int) in
                                                Button(action: {
                                                    filterButtonClicked = true
                                                    selectedCategoryName = commentsViewModel.uniqueCommentCategoriesArray[index]
                                                    
                                                    commentsViewModel.getSingleComment(comment_idx: commentsViewModel.filterComments(categoryName: selectedCategoryName)[0].commentIdx)
                                                }) {
                                                    HStack {
                                                        Text("\(commentsViewModel.commentCategoriesCount(categoryName: commentsViewModel.uniqueCommentCategoriesArray[index]))")
                                                        Text("\(commentsViewModel.uniqueCommentCategoriesArray[index])")
                                                    }
                                                    .font(.system(size: 14))
                                                    .padding(8)
                                                }
                                                .foregroundColor(filterButtonClicked ? selectedCategoryName == commentsViewModel.uniqueCommentCategoriesArray[index] ? .white :commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]] : commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]])
                                                .background(filterButtonClicked ? selectedCategoryName == commentsViewModel.uniqueCommentCategoriesArray[index] ? commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]] : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
                                                .cornerRadius(20)
                                                .overlay(RoundedRectangle(cornerRadius: 20)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundColor(commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]]))
                                                
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
                                            ForEach(commentsViewModel.filterComments(categoryName: selectedCategoryName), id: \.self) { filteredComments in
                                                Button(action: {
                                                    showIndividualContent = true
                                                    isFirstComment = false
                                                    
                                                    commentIdx = filteredComments.commentIdx
                                                    commentsViewModel.getSingleComment(comment_idx: commentIdx)
                                                    
                                                    indivComment = filteredComments
                                                    
                                                }) {
                                                    IndividualCommentsCardView(comments: filteredComments, commentViewModel: commentsViewModel)
                                                }
                                            }
                                            .sheet(item: $indivComment) { indivComment in
                                                ExtendCommentView(comments: indivComment, commentViewModel: commentsViewModel)
                                            }
                                        } else {
                                            ForEach(commentsViewModel.comments, id: \.id) { comment in
                                                Button(action: {
                                                    showIndividualContent = true
                                                    isFirstComment = false
                                                    
                                                    commentIdx = comment.commentIdx
                                                    commentsViewModel.getSingleComment(comment_idx: commentIdx)
                                                    
                                                    indivComment = comment
                                                    
                                                }) {
                                                    IndividualCommentsCardView(comments: comment, commentViewModel: commentsViewModel)
                                                }
                                            }
                                            .sheet(item: $indivComment) { indivComment in
                                                ExtendCommentView(comments: indivComment, commentViewModel: commentsViewModel)
                                            }
                                        }
                                    }
                                    .padding(.top, 1)
                                    .padding(.bottom, 10)
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
        commentsViewModel.getComments(semester_idx: commentsViewModel.commentSemesters[commentsViewModel.selectedSemesterIndex].semesterIdx)
        commentsViewModel.currentSelectedSemesterName = commentsViewModel.commentSemesters[commentsViewModel.selectedSemesterIndex].termName
    }
}

//struct CommentsView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @StateObject var commentsViewModel = CommentViewModel()
//
//    @State var showIndividualContent: Bool = false
//    @State var showView: Bool = true
//    @State var isFirstComment: Bool = true
//    @State var filterButtonClicked: Bool = false
//    @State var isChooseSemesterPickerClicked: Bool = false
//    @State var isSelectSemesterButtonClicked: Bool = false
//
//    @State var selectedSemesterIndex = 0
//
//    @State var commentIdx = ""
//    @State var selectedCategoryName = ""
//    @State var selectedSemesterName = ""
//
//    @State private var animate = 0.0
//
//    @State var indivComment: Comments?
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
//                        Text("Comments")
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
//                        Text(isSelectSemesterButtonClicked ? selectedSemesterName : commentsViewModel.currentSelectedSemesterName)
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
//                if commentsViewModel.comments.count > 0 {
//                    VStack {
//                        //filter buttons
//                        HStack(spacing: 10) {
//                            Image(systemName: "chevron.left")
//                                .foregroundColor(.gray)
//                            ScrollView(.horizontal, showsIndicators: false) {
//                                HStack {
//                                    ForEach(commentsViewModel.uniqueCommentCategoriesArray.indices, id: \.self) { (index: Int) in
//                                        Button(action: {
//                                            filterButtonClicked = true
//                                            selectedCategoryName = commentsViewModel.uniqueCommentCategoriesArray[index]
//
//                                            commentsViewModel.getSingleComment(comment_idx: commentsViewModel.filterComments(categoryName: selectedCategoryName)[0].commentIdx)
//                                        }) {
//                                            HStack {
//                                                Text("\(commentsViewModel.commentCategoriesCount(categoryName: commentsViewModel.uniqueCommentCategoriesArray[index]))")
//                                                Text("\(commentsViewModel.uniqueCommentCategoriesArray[index])")
//                                            }
//                                            .font(.system(size: 14))
//                                            .padding(8)
//                                        }
//                                        .foregroundColor(filterButtonClicked ? selectedCategoryName == commentsViewModel.uniqueCommentCategoriesArray[index] ? .white :commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]] : commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]])
//                                        .background(filterButtonClicked ? selectedCategoryName == commentsViewModel.uniqueCommentCategoriesArray[index] ? commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]] : Color(UIColor.secondarySystemBackground) : Color(UIColor.secondarySystemBackground))
//                                        .cornerRadius(20)
//                                        .overlay(RoundedRectangle(cornerRadius: 20)
//                                            .stroke(lineWidth: 1)
//                                            .foregroundColor(commentsViewModel.commentColorDictionary[commentsViewModel.uniqueCommentCategoriesArray[index]]))
//
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
//                                    ForEach(commentsViewModel.filterComments(categoryName: selectedCategoryName), id: \.self) { filteredComments in
//                                        Button(action: {
//                                            showIndividualContent = true
//                                            isFirstComment = false
//
//                                            commentIdx = filteredComments.commentIdx
//                                            commentsViewModel.getSingleComment(comment_idx: commentIdx)
//
//                                        }) {
//                                            IndividualCommentsCardView(comments: filteredComments, commentViewModel: commentsViewModel)
//                                        }
//                                    }
//                                } else {
//                                    ForEach(commentsViewModel.comments, id: \.id) { comment in
//                                        Button(action: {
//                                            showIndividualContent = true
//                                            isFirstComment = false
//
//                                            commentIdx = comment.commentIdx
//                                            commentsViewModel.getSingleComment(comment_idx: commentIdx)
//
//                                            indivComment = comment
//
//                                        }) {
//                                            IndividualCommentsCardView(comments: comment, commentViewModel: commentsViewModel)
//                                        }
//                                    }
//                                    .sheet(item: $indivComment) { indivComment in
//                                        ExtendCommentView(comments: indivComment, commentViewModel: commentsViewModel)
//                                    }
//                                }
//                            }
//                            .padding([.top, .bottom], 10)
//                        }
//                    }
//                    .padding([.leading, .trailing], 10)
//                } else {
//                    CustomEmptyDataView(noDataText: "You have no comments")
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
//                        VStack {
//                            Picker(selection: $selectedSemesterIndex, label: Text("Select Term")) {
//                                ForEach(commentsViewModel.commentSemesterNamesArray.indices, id: \.self) { (index: Int) in
//                                    Text("\(commentsViewModel.commentSemesterNamesArray[index])")
//                                }
//                            }.pickerStyle(WheelPickerStyle())
//                            Button(action: {
//                                commentsViewModel.getComments(semester_idx: commentsViewModel.commentSemesters[selectedSemesterIndex].semesterIdx)
//
//                                selectedSemesterName = commentsViewModel.commentSemesters[selectedSemesterIndex].termName
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
//            commentsViewModel.getCommentsSemesters()
//        }
//    }
//}

