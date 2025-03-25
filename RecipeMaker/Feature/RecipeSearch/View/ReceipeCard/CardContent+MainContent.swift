//
//  CardContent+MainContent.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
extension CardContent {
    @ViewBuilder
    func buttonContainer() -> some View {
        if recipe.sourceUrl != nil, horizontalSizeClass == .compact {
            Button(action: onWebTap) {
                Image(systemName: Constants.webButtonImage)
                Text(Constants.webButtonText)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.buttonHeight)
            }
            .buttonStyle(.borderedProminent)
        }
        if recipe.youtubeUrl != nil, horizontalSizeClass == .compact  {
            Button(action: onVideoTap) {
                Image(systemName: Constants.youttubeButtonImage)
                Text(Constants.youtubeButtonText)
                    .frame(maxWidth: .infinity)
                    .frame(height: Constants.buttonHeight)
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    func mainContainer() -> some View  {
        VStack(alignment: .center, spacing: Constants.mainContainerVStackSpacing) {
            Text(recipe.name)
                .font(.headline)
                .multilineTextAlignment(.center)
                .lineLimit(Constants.mainContainerRecipeNameLineLimit)
                .frame(height: Constants.mainContainerRecipeNameHeight)
                .foregroundColor(.black)
                .bold()
            
            Text(recipe.cuisine)
                .foregroundColor(.black)
                .font(.caption)
                .lineLimit(Constants.mainContainerCuisineLineLimit)
            Button(action: toggleFavorite) {
                HStack {
                    Image(systemName: isFavorite
                          ? Constants.heartFillImage
                          : Constants.hearEmptyImage)
                        .foregroundColor(isFavorite ? .red : .gray)
                }
                .padding(Constants.mainContainerPadding)
            }
        }
    }
}
