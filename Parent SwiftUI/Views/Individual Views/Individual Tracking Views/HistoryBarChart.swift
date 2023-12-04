//
//  HistoryBarChart.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

@available(iOS 15.0, *)
struct HistoryBarChart: View {
    
    @ObservedObject var trackingViewModel: TrackingViewModel
    
    @State var objective: String
    @State var trackingHistoryText: String
    @State var targetNotMetText: String
    @State var movingForwardText: String
    @State var targetMetText: String
    @State var exceedingExpectationsText: String
    @State var historySheetAppeared: Bool
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text(trackingHistoryText)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(10)
            .background(Color("MyEduCare"))

            
            VStack(alignment: .leading) {
                Text("Objective:")
                    .bold()
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                Text("\(objective)")
                    .offset(y: 8)
                    .foregroundColor(.black)
            }
            .padding(10)
                
            GeometryReader { geometry in
                VStack {
                    ScrollView(.horizontal, showsIndicators: true) {
                            Spacer()
                            HStack(alignment: .bottom) { // <-- here!
                                ForEach(trackingViewModel.trackingHistory, id: \.self) { history in
                                    HStack(alignment: .bottom) {
                                        IndividualHistoryBar(history: history, trackingViewModel: trackingViewModel)
                                    }
                                        
                                }
                            }
                            .frame(width: geometry.size.width)
                            .frame(minHeight: geometry.size.width)
                            .offset(y: -10)
                        Spacer()
                    }
                    HStack {
                        HStack {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 20, height: 20)
                            Text(targetNotMetText)
                                .font(.system(size: 11))
                        }
                        HStack(spacing: 5) {
                            Rectangle()
                                .fill(.orange)
                                .frame(width: 20, height: 20)
                            Text(movingForwardText)
                                .font(.system(size: 11))
                        }
                        HStack {
                            Rectangle()
                                .fill(.green)
                                .frame(width: 20, height: 20)
                            Text(targetMetText)
                                .font(.system(size: 11))
                        }
                        HStack {
                            Rectangle()
                                .fill(.blue)
                                .frame(width: 20, height: 20)
                            Text(exceedingExpectationsText)
                                .font(.system(size: 11))
                        }
                    }
                    .offset(y: -10)
                    .foregroundColor(.black)
                    
                }
            }
        }
    }
}
