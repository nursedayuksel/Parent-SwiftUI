//
//  IndividualEduSocialPostView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import _AVKit_SwiftUI
import AVFoundation

struct IndividualEduSocialPostView: View {
    var edusocialPosts: EduSocialPosts
    @ObservedObject var edusocialViewModel: EduSocialViewModel
    
    @State var selectedImage = ""
    
    @State var deleteButtonClicked = false
    
    @State var heartClicked = false
    
    @State var likedPostsArray: [String] = []
    
    let columns = [
        GridItem(.flexible(), spacing: 2),
        GridItem(.flexible(), spacing: 2)
    ]
    
    @State var openIndividualMediaSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                WebImage(url: URL(string: edusocialPosts.teacherPhoto))
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color("MyEduCare"), lineWidth: 1))
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(edusocialPosts.teacherName) (\(edusocialPosts.subject))")
                        .bold()
                    Text("\(edusocialPosts.postDate), \(edusocialPosts.postTime)")
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            
            Text("\(edusocialPosts.title)")
                .bold()
                .font(.system(size: 18))
            HStack {
                Text("\(edusocialPosts.message)")
                    .font(.system(size: 17))
                Spacer()
            }
            
            // if the post has image/video
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(edusocialPosts.imagesArray, id: \.self) { image in
                        Button(action: {
                            openIndividualMediaSheet = true
                            selectedImage = image
                        }) {
                            if image.contains("mp4") {
                                VideoPlayer(player: AVPlayer(url: URL(string: image)!))
                                    .scaledToFill()
                                    //.frame(width: 200)
                                    .frame(height: 300)
                                    .cornerRadius(5)
                            } else {
                                WebImage(url: URL(string: image))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(minWidth: 200)
                                    .frame(maxHeight: 300)
                                    .cornerRadius(5)
                            }
                        }
                    }
                    .sheet(isPresented: $openIndividualMediaSheet) {
                        IndividualMedia(selectedImage: $selectedImage)
                    }
                }
            }
            
            HStack {
                Button(action: {
                    heartClicked = true
                    
                    if heartClicked && !edusocialViewModel.likedPostsArray.contains(edusocialPosts.postIdx) {
                        edusocialViewModel.likePost(postIdx: edusocialPosts.postIdx)
                        edusocialViewModel.likedPostsArray.append(edusocialPosts.postIdx)
                    }
                }) {
                    if heartClicked || edusocialViewModel.likedPostsArray.contains(edusocialPosts.postIdx) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(Color("MyEduCare"))
                            .font(.system(size: 25))
                    } else {
                        Image(systemName: "heart")
                            .foregroundColor(Color("MyEduCare"))
                            .font(.system(size: 25))
                    }
                }
                
                Spacer()
            }
            
            Divider()
        }
        .padding([.leading, .trailing], 10)
    }
}
