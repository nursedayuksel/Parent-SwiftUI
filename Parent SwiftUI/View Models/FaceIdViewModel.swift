//
//  FaceIdViewModel.swift
//  Parent SwiftUI
//
//  Created by Nurseda on 24.05.2023.
//

import Foundation
import SwiftUI
import LocalAuthentication

class FaceIdViewModel: ObservableObject {
    @Published var appUnlocked = false
    @Published var authorizationError: Error?
       
    func requestBiometricUnlock() {
        print("it Wroks!")
        let context = LAContext()

        var error: NSError? = nil

        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)

        if canEvaluate {
            if context.biometryType != .none {
                context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "To access your data") { (success, error) in
                    DispatchQueue.main.async {
                        self.appUnlocked = success
                        self.authorizationError = error
                        print(self.appUnlocked)
                    }
                }
            } else {

            }
        }
    }
}
