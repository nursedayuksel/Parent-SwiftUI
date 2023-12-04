//
//  IndividualGDPRRulesView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import Foundation

struct IndividualGDPRRulesView: View {
    var yesNoArray: [String] = ["Yes", "No"]
    var yesNoArrayColor: [Color] = [Color("MyEduCare"), .red]
    
    var gdpr: GDPR
    
    @ObservedObject var gdprViewModel: GDPRViewModel
    
    @State var index: Int
    
    @State var isOpenAndCloseButtonClicked = false
    
    /* Indicates whether the user want to see all the text or not. */
    @State private var expanded: Bool = false

    /* Indicates whether the text has been truncated in its display. */
    @State private var truncated: Bool = false
    
    @State var checkboxClicked = false
    
    @State var initialValues = true
    
    @State var selectedRuleIdx = ""
    
    private func determineTruncation(_ geometry: GeometryProxy) {
        // Calculate the bounding box we'd need to render the
        // text given the width from the GeometryReader.
        let total = self.gdpr.rule.boundingRect(
            with: CGSize(
                width: geometry.size.width,
                height: .greatestFiniteMagnitude
            ),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.systemFont(ofSize: 16)],
            context: nil
        )

        if total.size.height > geometry.size.height {
            self.truncated = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Circle()
                    .fill(.black)
                    .frame(width: 5, height: 5)
                
                Text("\(gdpr.rule)")
                    .foregroundColor(.black)
                    .lineLimit(self.expanded ? nil : 2)
                    .lineSpacing(6)
                    .background(GeometryReader { geometry in
                        Color.clear.onAppear {
                            self.determineTruncation(geometry)
                        }
                    })
            }
                
            if self.truncated {
                HStack {
                    self.toggleButton
                    
                    Spacer()
                }
            }
            
            HStack {
                Spacer()
                
                if gdprViewModel.parentAnswersArray.count == 0 {
                    HStack {
                        // yes checkmark
                        HStack(spacing: 2) {
                            Button(action: {
                                initialValues = false
                                gdprViewModel.yesChecked[index].toggle()
                                selectedRuleIdx = gdpr.ruleIdx
                                
                                if gdprViewModel.yesChecked[index] {
                                    gdprViewModel.noChecked[index] = false
                                }
                                
                                if gdprViewModel.yesChecked[index] == false && gdprViewModel.noChecked[index] == false {
                                    self.gdprViewModel.ruleIdxsAndValuesDict[self.gdprViewModel.ruleIdxsArray[index]] = "0" // not set
                                } else if gdprViewModel.yesChecked[index] == true {
                                    self.gdprViewModel.ruleIdxsAndValuesDict[self.gdprViewModel.ruleIdxsArray[index]] = "1" // yes
                                } else {
                                    self.gdprViewModel.ruleIdxsAndValuesDict[self.gdprViewModel.ruleIdxsArray[index]] = "2"// no
                                }

                                print(self.gdprViewModel.ruleIdxsAndValuesDict)
                                
                            }) {
                                ZStack {
                                    Image(systemName: "square")
                                        .foregroundColor(Color(UIColor.systemGray4))
                                        .font(.system(size: 25))

                                    if initialValues {
                                        if gdpr.defaultOption == "1" {
                                            Image(systemName: "checkmark")
                                                .frame(width: 5, height: 5)
                                                .foregroundColor(Color("MyEduCare"))
                                        }
                                    } else {
                                        if selectedRuleIdx == gdpr.ruleIdx && gdprViewModel.yesChecked[index] {
                                            Image(systemName: "checkmark")
                                                .frame(width: 5, height: 5)
                                                .foregroundColor(Color("MyEduCare"))
                                        }
                                    }
                                }
                            }
                            
                            Text("Yes")
                                .foregroundColor(Color("MyEduCare"))
                        }

                        // no checkmark
                        HStack(spacing: 2) {
                            Button(action: {
                                initialValues = false
                                gdprViewModel.noChecked[index].toggle()
                                selectedRuleIdx = gdpr.ruleIdx
                                
                                if gdprViewModel.noChecked[index] {
                                    gdprViewModel.yesChecked[index] = false
                                }
                                
                                if gdprViewModel.yesChecked[index] == false && gdprViewModel.noChecked[index] == false {
                                    self.gdprViewModel.ruleIdxsAndValuesDict[self.gdprViewModel.ruleIdxsArray[index]] = "0" // not set
                                } else if gdprViewModel.yesChecked[index] == true {
                                    self.gdprViewModel.ruleIdxsAndValuesDict[self.gdprViewModel.ruleIdxsArray[index]] = "1" // yes
                                } else {
                                    self.gdprViewModel.ruleIdxsAndValuesDict[self.gdprViewModel.ruleIdxsArray[index]] = "2"// no
                                }

                                print(self.gdprViewModel.ruleIdxsAndValuesDict)
                                
                            }) {
                                ZStack {
                                    Image(systemName: "square")
                                        .foregroundColor(Color(UIColor.systemGray4))
                                        .font(.system(size: 25))

                                    if initialValues {
                                        if gdpr.defaultOption == "2" {
                                            Image(systemName: "checkmark")
                                                .frame(width: 5, height: 5)
                                                .foregroundColor(.red)
                                        }
                                    } else {
                                        if selectedRuleIdx == gdpr.ruleIdx && gdprViewModel.noChecked[index] {
                                            Image(systemName: "checkmark")
                                                .frame(width: 5, height: 5)
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                            
                            Text("No")
                                .foregroundColor(.red)
                        }

                    }
                } else {
                    Text("\(gdprViewModel.yesOrNo(parentAnswer: gdpr.parentAnswer))")
                        .foregroundColor(gdprViewModel.parentAnswerColor(parentAnswer: gdpr.parentAnswer))
                }
            }
        }
        .padding([.leading, .trailing], 8)
    }
    
    var toggleButton: some View {
        Button(action: { self.expanded.toggle() }) {
            Text(self.expanded ? "Show less" : "Show more")
                .font(.system(size: 13))
                .foregroundColor(.red)
        }
    }
}

struct ActivityIndicator: View {
    
    @State private var isAnimating: Bool = false
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            ForEach(0..<5) { index in
                Group {
                    Circle()
                        .frame(width: geometry.size.width / 5, height: geometry.size.height / 5)
                        .scaleEffect(calcScale(index: index))
                        .offset(y: calcYOffset(geometry))
                }.frame(width: geometry.size.width, height: geometry.size.height)
                    .rotationEffect(!self.isAnimating ? .degrees(0) : .degrees(360))
                    .animation(Animation
                                .timingCurve(0.5, 0.15 + Double(index) / 5, 0.25, 1, duration: 1.5)
                                .repeatForever(autoreverses: false))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            self.isAnimating = true
        }
    }
    
    func calcScale(index: Int) -> CGFloat {
        return (!isAnimating ? 1 - CGFloat(Float(index)) / 5 : 0.2 + CGFloat(index) / 5)
    }
    
    func calcYOffset(_ geometry: GeometryProxy) -> CGFloat {
        return geometry.size.width / 10 - geometry.size.height / 2
    }
    
}
