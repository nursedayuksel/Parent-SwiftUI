//
//  EduSocialView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 04.09.2023.
//

import SwiftUI

struct EduSocialView: View {
    @StateObject var eduSocialViewModel = EduSocialViewModel()
    
    @State private var isLoading = true
    
    @State var selectCourseDropdownClicked = false
    @State var selectCourseButtonClicked = false
    @State var openCreatePostSheet = false
    
    @State var selectedPickerIndex = 0
    @State var selectedPickerValueName = ""
    @State var pickerArray: [String] = []
    
    @State private var animate = 0.0
    
    
    var body: some View {
        ModuleBody(
            selectedPickerIndex: $selectedPickerIndex,
            initialFunction: eduSocialViewModel.getEduSocialPosts,
            pickerArray: $pickerArray,
            buttonFunction: empty,
            selectedPickerValueName: $selectedPickerValueName,
            noDataDescription: "There are no existing posts",
            arrayCount: Binding<Int>(
            get: { eduSocialViewModel.edusocialPosts.count },
            set: { _ in }
            ),
            isLoading: $isLoading,
            ModuleName: "Edu-Social",
            HeaderContent: {},
            BodyContent: {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(eduSocialViewModel.edusocialPosts, id: \.self) { post in
                            IndividualEduSocialPostView(edusocialPosts: post, edusocialViewModel: eduSocialViewModel)
                        }
                        
                        Spacer()
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
