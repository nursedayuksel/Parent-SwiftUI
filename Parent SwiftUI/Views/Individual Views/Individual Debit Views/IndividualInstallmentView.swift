//
//  IndividualInstallmentView.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI
import Foundation

struct IndividualInstallmentView: View {
    var installments: Installments
    
    @ObservedObject var debitViewModel: DebitViewModel
    
    @State var currency: String
    @State var index: Int
    @State var debitIdx: String
    
    init(installments: Installments, debitViewModel: DebitViewModel, currency: String, index: Int, debitIdx: String) {
        self.installments = installments
        self.debitViewModel = debitViewModel
        self.currency = currency
        self.index = index
        self.debitIdx = debitIdx
    }
    var body: some View {
       if installments.debitIdx == debitIdx {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(installments.period)")
                        .foregroundColor(.gray)
                    Text("Remaining: \(installments.remainingFormatted) \(currency)")
                        .bold()
                }
                
                Spacer()
                
                if debitViewModel.installmentClickedDict.count > 0 && installments.checkBox == "1" {
                    CheckBox(checked: $debitViewModel.installmentClickedDict, checkmarkColor: Color("MyEduCare"), debitViewModel: debitViewModel, index: index, instIdx: installments.instIdx, currency: currency, debitIdx: debitIdx)
                } else {
                    EmptyView()
                }
            }
       }
    }
}
