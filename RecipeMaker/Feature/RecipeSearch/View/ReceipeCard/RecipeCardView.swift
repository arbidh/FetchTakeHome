//
//  RecipeCardView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftUI
import SwiftData

struct RecipeCardView: View {
    let recipe: RecipeResult
    @Namespace var animation
    @State private var isShowingDetail = false
    @Binding var showVideo: Bool
    @Binding var showWebView: Bool
    @Environment(SnackbarPresenter.self) private var snackbarManager
    let favoritesVM: RecipeFavoritesViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var onRecipeTap: () -> Void
    var onWebTap: () -> Void
    var onVideoTap: () -> Void
    let grayOpacity: CGFloat = 0.3
    let shadowRadius: CGFloat = 5
    let padding: CGFloat = 4
    let vstackSpacingHorizontalRegular: CGFloat = 4
    let vstackSpacingHorizontalCompact: CGFloat = 2
    let roundedRectangleCornerRadius: CGFloat = 20
    var body: some View {
        VStack(spacing: horizontalSizeClass == .regular
               ? vstackSpacingHorizontalRegular
               : vstackSpacingHorizontalCompact) {
            CardContent(recipe: recipe, favoritesVM: self.favoritesVM, onRecipeTap: onRecipeTap, onWebTap: onWebTap, onVideoTap: onVideoTap)
        }
        .padding(padding)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: roundedRectangleCornerRadius))
        .shadow(color: .gray.opacity(grayOpacity), radius: shadowRadius)
        .onTapGesture {
            onRecipeTap()
        }
        .fullScreenCover(isPresented: $isShowingDetail) {
            RecipeDetailView(recipe: recipe, namespace: animation, isPresented: $isShowingDetail)
        }
    }
}



