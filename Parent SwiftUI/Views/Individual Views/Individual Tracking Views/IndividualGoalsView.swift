//
//  IndividualGoalsView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct IndividualGoalsView: View {
    
    @ObservedObject var trackingVieWModel: TrackingViewModel
    
    var trackingObjectives: Tracking

    var maxRating: Int = 4
    @State private var historyChartAppeared = false
    
    init(trackingObjectives: Tracking, trackingViewModel: TrackingViewModel) {
        self.trackingObjectives = trackingObjectives
        self.trackingVieWModel = trackingViewModel
    }
    
    var body: some View {
        HStack{
            Text("\(trackingObjectives.object_name)")
                .font(.system(size: 13))
                .foregroundColor(.black)
            Spacer()
            VStack(spacing: 8){
                HStack {
                    ForEach(1..<maxRating+1) { index in
                        Image(systemName: Int(trackingObjectives.stars) ?? 0 >= index ? "star.fill" : "star")
                            .foregroundColor(trackingVieWModel.starColor(stars: trackingObjectives.stars))
                    }
                }
                Text("\(trackingObjectives.EN)")
                    .font(.system(size: 13))
                    .foregroundColor(Color.gray)
                Button(action: {
                    trackingVieWModel.getTrackingHistory(objectiveIdx: trackingObjectives.idx)
                    
                    historyChartAppeared.toggle()
                }) {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .foregroundColor(.white)
                        Text("History")
                            .foregroundColor(.white)
                    }
                }
                .padding(8)
                .background(Color.orange)
                .cornerRadius(8)
            }
            
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
        .sheet(isPresented: $historyChartAppeared) {
            if #available(iOS 15.0, *) {
                HistoryBarChart(trackingViewModel: trackingVieWModel, objective: trackingObjectives.object_name, trackingHistoryText: "Tracking history", targetNotMetText: "Target not met", movingForwardText: "Moving forward", targetMetText: "Target met", exceedingExpectationsText: "Exceeding expectations", historySheetAppeared: historyChartAppeared)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
}
