//
//  IndividualHistoryBar.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct IndividualHistoryBar: View {
    
    var history: History
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    init(history: History, trackingViewModel: TrackingViewModel) {
        self.history = history
        self.trackingViewModel = trackingViewModel
    }
    
    var body: some View {
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    Text(history.target)
                    Image(systemName: "star.fill")
                        .foregroundColor(trackingViewModel.starColor(stars: history.target))
                }
                Rectangle()
                    .fill(trackingViewModel.starColor(stars: history.target))
                    .frame(width: 40, height: trackingViewModel.barHeight(stars: history.target))
                
                Text(history.date)
                    .font(.system(size: 15))
                    .foregroundColor(.black)
            }

    }
}
