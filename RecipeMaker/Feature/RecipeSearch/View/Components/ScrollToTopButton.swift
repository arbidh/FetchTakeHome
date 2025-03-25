//
//  ScrollToTopButton.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftUI
extension RecipeRow {
    @ViewBuilder
    public func scrollToTopButton(proxy: ScrollViewProxy) -> some View {
        let topAnchor = "TOP_ANCHOR"
        let scrollId = "SCROLL_TO_TOP_BUTTON"
        let upArrowImageName = "arrow.up.circle.fill"
        let fontSize: CGFloat = 40
        let shadowOpacity: CGFloat = 0.3
        let animationResponse: CGFloat = 0.3
        let shadowRadius: CGFloat = 5
        let shadowX: CGFloat = 0
        let shadowY: CGFloat = 2
        Button(action: {
            withAnimation(.spring(response: animationResponse)) {
                proxy.scrollTo(topAnchor, anchor: .top)
                showScrollToTop = false
            }
        }) {
            Image(systemName: upArrowImageName)
                .font(.system(size: fontSize))
                .foregroundColor(.blue)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: .gray.opacity(shadowOpacity), radius: shadowRadius, x: shadowX, y: shadowY)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .id(scrollId)
    }
}
