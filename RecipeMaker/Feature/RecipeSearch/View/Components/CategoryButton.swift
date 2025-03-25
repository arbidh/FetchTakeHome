//
//  CategoryButton.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftUI

struct CategoryButton: View {
    let category: String
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    
    enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let lineLimit: Int = 4
        static let verticalPadding: CGFloat = 8
        static let maxWidth: CGFloat = 120
        static let minHeight: CGFloat = 40
        static let cornerRadius: CGFloat = 20
        static let grayOpacity: CGFloat = 0.1
        static let grayOpacityDark: CGFloat = 0.3
        static let animationResponse:CGFloat = 0.3
        static let dampingFraction: CGFloat = 0.7
    }

    var body: some View {
        Button(action: action) {
            Text(category)
                .font(.subheadline)
                .padding(.horizontal, Constants.horizontalPadding)
                .lineLimit(Constants.lineLimit)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding(.vertical, Constants.verticalPadding)
                .frame(maxWidth: Constants.maxWidth)
                .frame(minHeight: Constants.minHeight)
                .background(
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(isSelected ? Color.blue : (colorScheme == .dark ? Color.gray.opacity(Constants.grayOpacityDark) : Color.gray.opacity(Constants.grayOpacity)))
                )
                .foregroundColor(isSelected ? .white : (colorScheme == .dark ? .white : .primary))
        }
        .buttonStyle(.plain)
        .animation(.spring(response: Constants.animationResponse, dampingFraction: Constants.dampingFraction), value: isSelected)
        .transaction { transaction in
            transaction.animation = nil
        }
    }
}

