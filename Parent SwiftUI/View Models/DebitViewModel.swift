//
//  DebitViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 11.04.2023.
//

import Foundation
import SwiftUI
import Alamofire
import UIKit

class DebitViewModel: ObservableObject {
    
    let defaults = UserDefaults.standard
    
    @Published var debits: [Debits] = []
    @Published var installments: [Installments] = []
    @Published var educationalYears: [EducationalYears] = []
    
    @Published var installmentsDict: [String: [Installments]] = [:]
    
    private var debitsArray: NSArray = []
    private var installmentsArray: NSArray = []
    @Published var educationalYearsArray: NSArray = []

    @Published var isExpandedArray: [Bool] = []
    
    @Published var dbsArray: [String] = []
    @Published var yearsArray: [String] = []
    
    @Published var installmentClickedDict: [String: Bool] = [:]
    @Published var installmentCurrencyDict: [String: String] = [:]
    
    @Published var installmentClickedIdxs: [String] = []
    
    @Published var isExpandedDict: [String: [Bool]] = [:]
    
    @Published var allPaidArray: [String] = []
    
    @Published var exchangeRate: String = ""
    
    @Published var totalAmount = 0.0
    @Published var totalAmountRounded = "0.00"
    @Published var totalAmountFormatted = "0.00"
    
    @Published var paymentUrl = ""
    
    @Published var selectedYearName = ""
    
    @Published var selectedDb = ""
    
    @Published var showWebView = false
    
    @Published var selectedDebitIdx = ""
    
    @Published var selectedYearIndex = 0
    
    
    func getDebits(selectedDb: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": selectedDb,
            "student_idx": studentIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_DEBTS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.debits = []
                    //self.isExpandedArray = []
                    
                    self.debitsArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.debitsArray {
                        let singleDebit = obj as! NSDictionary
                        
                        let name = singleDebit.value(forKey: "name") as? String ?? ""
                        let debitIdx = singleDebit.value(forKey: "idx") as? String ?? ""
                        let totalAmount = singleDebit.value(forKey: "total_amount") as? String ?? ""
                        let finalAmount = singleDebit.value(forKey: "final_amount") as? String ?? ""
                        let discount = singleDebit.value(forKey: "discount") as? String ?? ""
                        let currency = singleDebit.value(forKey: "currency") as? String ?? ""
                        let url = singleDebit.value(forKey: "url") as? String ?? ""
                        let schoolName = singleDebit.value(forKey: "school_name") as? String ?? ""
                        let onlinePaypass = singleDebit.value(forKey: "online_paypass") as? String ?? ""
                        let onlinePayUser = singleDebit.value(forKey: "online_payuser") as? String ?? ""
                        let remaining = singleDebit.value(forKey: "remaining") as? String ?? ""
                        
                        let remainingFormatted = self.convertToComma(numberToConvert: remaining)
                        let totalAmountFormatted = self.convertToComma(numberToConvert: totalAmount)
                        let finalAmountFormatted = self.convertToComma(numberToConvert: finalAmount)
                        
                        let oneDebit = Debits(name: name, debitIdx: debitIdx, totalAmount: totalAmountFormatted, finalAmount: finalAmountFormatted, discount: discount, currency: currency, url: url, schoolName: schoolName, onlinePaypass: onlinePaypass, onlinePayUser: onlinePayUser, remaining: remainingFormatted)
                        
                        self.debits.append(oneDebit)
                        self.isExpandedArray.append(false)
                        self.isExpandedDict[debitIdx] = self.isExpandedArray
                    }
                }
                
            case .failure(let error):
                print(error)
            }
        }

    }
    
    func getInstallments(debitIdx: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": self.selectedDb,
            "debit_idx": debitIdx,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_INSTALLMENTS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.installments = []
                    self.allPaidArray = []
                    
                    self.installmentsArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.installmentsArray {
                        let singleInstallment = obj as! NSDictionary
                        
                        let period = singleInstallment.value(forKey: "period") as? String ?? ""
                        let instIdx = singleInstallment.value(forKey: "idx") as? String ?? ""
                        let instNumber = singleInstallment.value(forKey: "installment_number") as? String ?? ""
                        let amount = singleInstallment.value(forKey: "amount") as? String ?? ""
                        let remaining = singleInstallment.value(forKey: "remaining") as? String ?? ""
                        let checkBox = singleInstallment.value(forKey: "check_box") as? String ?? ""
                        let debitIdx = singleInstallment.value(forKey: "t_debiting_idx") as? String ?? ""
                        let allPaid = singleInstallment.value(forKey: "all_paid") as? String ?? ""
                        
                        let remainingFormatted = self.convertToComma(numberToConvert: remaining)
                        
                        let oneInstallment = Installments(period: period, instIdx: instIdx, instNumber: instNumber, amount: amount, remaining: remaining, checkBox: checkBox, debitIdx: debitIdx, allPaid: allPaid, remainingFormatted: remainingFormatted)
                        
                        self.installments.append(oneInstallment)
                        
                        if self.selectedDebitIdx != debitIdx && !self.installmentClickedIdxs.contains(instIdx) {
                            self.installmentClickedDict[instIdx] = false
                        }
                        
                        self.installmentsDict[debitIdx] = self.installments
                        self.allPaidArray.append(allPaid)
                    }
                    print(self.installmentClickedDict)
                    //print(self.installments)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getExchangeRate(index: Int, checked: Bool, currency: String, debitIdx: String) {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_GET_EXCHANGE_RATE, method: .post, parameters: parameters).responseJSON { response in
            //print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                self.exchangeRate = dict.value(forKey: "rate") as? String ?? ""
                
                if let remaining = self.installmentsDict[debitIdx]?[index].remaining.doubleValue, let rate = Double(self.exchangeRate) {
                    if checked {
                        if currency == "EURO" {
                            self.totalAmount = self.totalAmount + (remaining * rate)
                        } else {
                            self.totalAmount = self.totalAmount + remaining
                        }
                    } else {
                        if currency == "EURO" {
                            self.totalAmount = self.totalAmount - (remaining * rate)
                        } else {
                            self.totalAmount = self.totalAmount - remaining
                        }
                    }
                    
                    self.totalAmountRounded = String(format: "%.2f", self.totalAmount)
                    self.totalAmountFormatted = self.convertToComma(numberToConvert: self.totalAmountRounded)
                }
 
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPaymentUrl() {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": self.selectedDb,
            "student_idx": studentIdx,
            "parent_idx": defaults.string(forKey: "user_idx")!,
            "installments": self.installmentClickedIdxs,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        print(parameters)
        
        AF.request(URL_GET_PAYMENT_URL, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.paymentUrl = dict.value(forKey: "url") as? String ?? ""
                    
                    print(self.paymentUrl)
                    
//                    if let url = URL(string: self.paymentUrl) {
//                       UIApplication.shared.open(url)
//                    }
                    
                    self.showWebView = true
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getYears() {
        let parameters: Parameters = [
            "school_group": defaults.string(forKey: "school_group")!,
            "db": defaults.string(forKey: "db")!,
            "caller_idx": defaults.string(forKey: "user_idx")!,
            "app_name": "ios/parent"
        ]
        
        AF.request(URL_EDUCATIONAL_YEARS, method: .post, parameters: parameters).responseJSON { response in
            print(response)
            switch response.result {
            case .success(let JSON):
                let dict = JSON as! NSDictionary
                
                let error = dict.value(forKey: "error") as? Int ?? 1
                
                if error == 0 {
                    self.educationalYearsArray = dict.value(forKey: "data") as! NSArray
                    
                    for obj in self.educationalYearsArray {
                        let singleYear = obj as! NSDictionary
                        
                        let db = singleYear.value(forKey: "db") as? String ?? ""
                        let display = singleYear.value(forKey: "display") as? String ?? ""
                        let defaultYear = singleYear.value(forKey: "default") as? String ?? ""
                        
                        let oneYear = EducationalYears(db: db, display: display, defaultYear: defaultYear)
                        
                        self.educationalYears.append(oneYear)
                        self.dbsArray.append(db)
                        self.yearsArray.append(display)
                        
                        print(self.dbsArray)
                    }
                    
                    for i in 0..<self.educationalYears.count {
                        if self.educationalYears[i].defaultYear == "1" {
                            self.selectedYearName = self.educationalYears[i].display
                            self.selectedDb = self.educationalYears[i].db
                            self.getDebits(selectedDb: self.selectedDb)
                            self.selectedYearIndex = i
                        }
                    }
                    
                   // self.selectedDb = self.dbsArray[1]
                   // self.selectedYearName = self.yearsArray[1]
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func paymentWebView(paymentUrl: String) -> WebView {
        return WebView(url: paymentUrl)
    }
    
    func convertToComma(numberToConvert: String) -> String {
        var formattedNumber = "0.00"
        if let myInteger = Double(numberToConvert) {
            let myNumber = NSNumber(value: myInteger)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            numberFormatter.locale = Locale(identifier: "en_US")
            numberFormatter.maximumFractionDigits = 2
            numberFormatter.decimalSeparator = "."
            formattedNumber = numberFormatter.string(from: myNumber) ?? "0.00"
        }
        
        return formattedNumber
    }
}
