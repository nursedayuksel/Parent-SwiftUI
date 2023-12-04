//
//  IndividualDebitVIew.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import SwiftUI

struct IndividualDebitView: View {
    
    var debits: Debits
    @ObservedObject var debitViewModel: DebitViewModel
    
    @State var index: Int
    
    @State var selectedDebitIdx = ""
    
    init(debits: Debits, debitViewModel: DebitViewModel, index: Int) {
        self.debits = debits
        self.debitViewModel = debitViewModel
        self.index = index
    }
    
    var body: some View {
        VStack {
            DisclosureGroup(isExpanded: $debitViewModel.isExpandedArray[index]) {
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 15) {
                            Divider()
                            ForEach(Array((debitViewModel.installmentsDict[debits.debitIdx]?.enumerated()) ?? debitViewModel.installments.enumerated()), id: \.element) { index, installments in
                                IndividualInstallmentView(installments: installments, debitViewModel: debitViewModel, currency: debits.currency, index: index, debitIdx: debits.debitIdx)
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 300)
                }
            } label: {
                VStack(alignment: .leading, spacing: 10) {
                    Text("\(debits.name)")
                        .bold()
                        .foregroundColor(.black)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Total: \(debits.totalAmount) \(debits.currency)")
                        Text("Total after discount: \(debits.finalAmount) \(debits.currency)")
                        
                        HStack {
                            Text("Remaining:")
                            Spacer()
                            Text("\(debits.remaining) \(debits.currency)")
                                .font(.system(size: 22))
                                .foregroundColor(Color("MyEduCare"))
                                .offset(x: 25)
                        }
                    }
                    .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .onTapGesture {
                    withAnimation {
                        
                        debitViewModel.isExpandedArray[index].toggle()
                        
                        debitViewModel.getInstallments(debitIdx: debits.debitIdx)
                        
                        //selectedDebitIdx = debits.debitIdx
                        
                        print(debitViewModel.isExpandedArray)
                        
                        // for collapsing the rest of the already expanded disclosure groups when expanding one of them
                        if debitViewModel.isExpandedArray[index] {
                            debitViewModel.installmentsDict[debits.debitIdx] = debitViewModel.installments
                            for i in 0..<debitViewModel.isExpandedArray.count {
                                if i != index && debitViewModel.isExpandedArray[i] == debitViewModel.isExpandedArray[index] {
                                    //debitViewModel.isExpandedArray[i] = false
                                    print(debitViewModel.isExpandedArray)
                                    debitViewModel.installments = []
                                    //debitViewModel.installmentsDict[debits.debitIdx] = debitViewModel.installments

                                    //debitViewModel.installmentClickedArray = []
                                    
                                  //  debitViewModel.getInstallments(debitIdx: debits.debitIdx)
                                }
                            }
                        }
                        
                        //print(debitViewModel.isExpandedArray)
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 1)
        .padding([.leading, .trailing], 10)
    }
}

