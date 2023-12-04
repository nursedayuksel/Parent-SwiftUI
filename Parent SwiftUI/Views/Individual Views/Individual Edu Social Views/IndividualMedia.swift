//
//  IndividualMedia.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.09.2023.
//

import SwiftUI
import SDWebImageSwiftUI
import _AVKit_SwiftUI
import AVFoundation

struct IndividualMedia: View {
    @Binding var selectedImage: String
    
    var body: some View {
        VStack {
            if selectedImage.contains("mp4") {
                VideoPlayer(player: AVPlayer(url: URL(string: selectedImage)!))
                    .scaledToFit()
                    //.frame(width: 200)
                    //.frame(height: 300)
                    .cornerRadius(5)
            } else {
                WebImage(url: URL(string: selectedImage))
                    .resizable()
                    .scaledToFit()
                    //.frame(minWidth: 200)
                    //.frame(maxHeight: 300)
                    .cornerRadius(5)
            }
        }
        .padding()
        
    }
}
