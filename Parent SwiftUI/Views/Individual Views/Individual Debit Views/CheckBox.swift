//
//  CheckBox.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct CheckBox: View {
    @Binding var checked: [String: Bool]
    @State var checkmarkColor: Color
    
    @ObservedObject var debitViewModel: DebitViewModel
    
    @State var index: Int
    @State var instIdx: String
    @State var currency: String
    @State var debitIdx: String
    
    var body: some View {
        HStack(spacing: 5) {
            ZStack {
                Image(systemName: "square")
                    .foregroundColor(.gray)
                    .font(.system(size: 25))
                if checked[instIdx] ?? false {
                    Image(systemName: "checkmark")
                        .frame(width: 5, height: 5)
                        .foregroundColor(checkmarkColor)
                }
            }
            .onTapGesture {
                debitViewModel.selectedDebitIdx = debitIdx
                
                checked[instIdx]!.toggle()
                
                debitViewModel.getExchangeRate(index: index, checked: checked[instIdx]!, currency: currency, debitIdx: debitIdx)
                
                if checked[instIdx]! {
                    debitViewModel.installmentClickedIdxs.append(instIdx)
                } else {
                    debitViewModel.installmentClickedIdxs.removeAll{ $0 == instIdx }
                }
                
                print(debitViewModel.installmentClickedIdxs)
            }
        }
    }
}
