//
//  SnackbarManager.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
@Observable
class SnackbarPresenter {
    var isShowing = false
    var message = ""
    enum Constants {
        static let animationResponse: CGFloat = 0.5
        static let animationDampingFraction: CGFloat = 0.7
        static let hideDelay: CGFloat = 2
    }
    func show(message: String) {
        self.message = message
        withAnimation(.spring(response: Constants.animationResponse, dampingFraction: Constants.animationDampingFraction)) {
            self.isShowing = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.hideDelay) {
            withAnimation(.spring(response: Constants.animationResponse, dampingFraction: Constants.animationDampingFraction)) {
                self.isShowing = false
            }
        }
    }
}
