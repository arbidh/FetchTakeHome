//
//  SnackbarView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
struct SnackbarView: View {
    let message: String

    private enum Constants {
        static let iconSize: CGFloat = 20
        static let iconColor: Color = .red
        static let textFontSize: CGFloat = 16
        static let textFontWeight: Font.Weight = .medium
        static let horizontalPadding: CGFloat = 20 - 8
        static let verticalPadding: CGFloat = 16
        static let shadowOpacity: Double = 0.15
        static let shadowRadius: CGFloat = 10
        static let shadowXOffset: CGFloat = 0
        static let shadowYOffset: CGFloat = -5
        static let bottomPadding: CGFloat = 49
        static let heartImageName: String = "heart.fill"
    }
    var body: some View {
        HStack(spacing: Constants.horizontalPadding) {
            Image(systemName: Constants.heartImageName)
                .foregroundColor(Constants.iconColor)
                .font(.system(size: Constants.iconSize))

            Text(message)
                .foregroundColor(.black)
                .font(.system(size: Constants.textFontSize, weight: Constants.textFontWeight))

            Spacer()
        }
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(Color.white)
                .shadow(color: Color.black.opacity(Constants.shadowOpacity),
                        radius: Constants.shadowRadius,
                        x: Constants.shadowXOffset,
                        y: Constants.shadowYOffset)
        )
        .padding(.bottom, Constants.bottomPadding)
        .transition(.move(edge: .bottom))
    }
}

