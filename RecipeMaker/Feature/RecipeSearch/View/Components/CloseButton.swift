//
//  CloseButton.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI

struct CloseButton: View {
    @Binding var showDetails:Bool
    @Binding var isPresented: Bool
    let closeButtonAnimationResponse: CGFloat = 6
    let closeButtonDampingFraction: CGFloat = 0.8
    let presentationDelay: TimeInterval = 0.3
    let xImage = "xmark.circle.fill"
    var body: some View {
        HStack {
            Button {
                withAnimation(.spring(response: closeButtonAnimationResponse, dampingFraction: closeButtonDampingFraction)) {
                    self.showDetails = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + presentationDelay) {
                        isPresented = false
                    }
                }
            } label: {
                Image(systemName: xImage)
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding()
            }
            Spacer()
        }
    }
}
