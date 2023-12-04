//
//  PieChartView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 20.04.2023.
//

import SwiftUI

struct PieChartView: View {
    public let values: [Double]
    public var colors: [Color]
    
    public var innerRadiusFraction: CGFloat
    
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
        
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<self.values.count, id: \.self) { i in
                PieSliceView(pieSliceData: self.slices[i])
            }
            .frame(width: 200, height: 200)
            
            Circle()
                .fill(Color(UIColor.secondarySystemBackground))
                .frame(width: 180 * innerRadiusFraction, height: 180 * innerRadiusFraction)
            
        }
        .background(Color(UIColor.secondarySystemBackground))
        .foregroundColor(Color.white)
    }
}
