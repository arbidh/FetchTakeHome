//
//  RecipeDetailView+Content.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI

extension RecipeDetailView {
    public func DetailContent(recipe: RecipeResult, showDetail: Bool ) -> some View {
        ScrollView {
            VStack(spacing: Constants.Content.detailContentSpacing) {
                RecipeContent(recipe: recipe, showDetails: showDetail)
            }
            .padding(.top, Constants.Content.detailContentTop)
        }
    }
    
    public func LoadingView() -> some View {
        ProgressView(Constants.Content.loadingRecipeDetails)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension RecipeDetailView {
    public func RecipeImage(recipe: RecipeResult, showDetails: Bool) -> some View {
        AsyncImage(url: URL(string: recipe.photoUrlLarge ?? "")) { image in
            image
                .resizable()
                .scaledToFit()
                .frame(maxWidth: showDetails ? Constants.Content.imageMaxWidthShowingDetails : Constants.Content.imageMaxWidthNotShowingDetails)
                .clipShape(RoundedRectangle(cornerRadius:Constants.Content.clipCornerRadius))
                .matchedGeometryEffect(id: "\(Constants.Content.cuisineText):\(recipe.id)", in: namespace)
        } placeholder: {
            ProgressView()
                .frame(width: Constants.Content.progressViewWidth, height: Constants.Content.progressViewHeight)
        }
    }
}

extension RecipeDetailView {
    public func RecipeName(detail: RecipeResult, showDetails: Bool) -> some View {
        Text(detail.name.capitalized)
            .font(.title)
            .bold()
            .matchedGeometryEffect(id: "\(Constants.Content.contentName)\(detail.name)", in: namespace)
            .opacity(Constants.Content.detailOpacity)
            .foregroundStyle(Color(UIColor.darkText))
    }
    public func RecipeContent(recipe: RecipeResult, showDetails: Bool ) -> some View {
        LazyVStack(spacing: Constants.Content.contentSpacing) {
            RecipeImage(recipe: recipe, showDetails: showDetails)
            RecipeName(detail: recipe, showDetails: showDetails )
            Cuisine(detail: recipe)

        }
    }
}

extension RecipeDetailView {
    public func Cuisine(detail: RecipeResult,
                        imageSystemName:String = Constants.Content.cuisineImage,
                        imageHeight: CGFloat = Constants.Content.cuisineImageHeight)
                        -> some View {
            VStack(alignment: .leading, spacing: Constants.Content.cuisingSpacing) {
            Text(Constants.Content.cuisineText)
                .font(.headline)
                .padding(.horizontal)
            HStack {
                VStack(alignment: .leading, spacing: Constants.Content.cuisineSpacing) {
                    Text(recipe.cuisine.capitalized)
                        .font(.system(.body, design: .rounded))
                        .bold()
                }
                Spacer()
                Image(systemName: imageSystemName)
                    .foregroundColor(.yellow)
                
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: Constants.Content.cuisineCornerRadius)
                    .fill(Color(.systemBackground))
                    .shadow(color: .gray.opacity(Constants.Content.cuisineShadwGrayOpacity), radius: Constants.Content.cuisineShadowRadius)
            )
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(Constants.Content.contentCornerRadius)
            .shadow(radius:Constants.Content.contentShadow)
        }
    }
}
