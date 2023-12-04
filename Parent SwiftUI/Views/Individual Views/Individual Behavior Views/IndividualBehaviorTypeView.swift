//
//  IndividualBehaviorTypeView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualBehaviorTypeView: View {
    var behavior: Behavior
    
    @ObservedObject var behaviorViewModel: BehaviorViewModel
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 7, height: 60)
                .foregroundColor(behaviorViewModel.pointColor(pointValue: behavior.type))
            
            WebImage(url: URL(string: behavior.behaviorIcon))
                .resizable()
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Text("\(behavior.behaviorName)")
                        .foregroundColor(.black)
                    HStack(spacing: 0) {
                        Text("\(behaviorViewModel.setPointSign(pointValue: behavior.type))")
                        Text("\(behavior.point)")
                    }
                    .foregroundColor(.black)
                }
                Text("\(behavior.subject)")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
        }
        .padding([.leading, .trailing], 10)
    }
}
