//
//  CardContent.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
struct CardContent: View {
    enum Constants {
        static let imageFrameWidth: CGFloat = 180
        static let imageFrameHeight: CGFloat = 110
        static let imageCornerRadius: CGFloat = 15
        static let buttonContainerBottom: CGFloat = 2
        static let webButtonImage: String = "desktopcomputer"
        static let webButtonText: String = "Web"
        static let youtubeButtonText:String = "Video"
        static let youttubeButtonImage: String = "play.square"
        static let buttonHeight: CGFloat = 32
        static let removeFromFavoriteText = "removed From Favorites"
        static let addToFavoriteText = "added To Favorites"
        static let failedFavoriteText = "failed To update Favorites"
        static let mainContainerVStackSpacing: CGFloat = 2
        static let mainContainerRecipeNameLineLimit: Int = 2
        static let mainContainerRecipeNameHeight: CGFloat = 50
        static let mainContainerCuisineLineLimit: Int = 1
        static let heartFillImage = "heart.fill"
        static let hearEmptyImage = "heart"
        static let mainContainerPadding: CGFloat = 2
    }
    let recipe: RecipeResult
    @State var isFavorite: Bool = false
    let favoritesVM: RecipeFavoritesViewModel
    @Environment(SnackbarPresenter.self) private var snackbarPresenter
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var onRecipeTap: () -> Void
    var onWebTap: () -> Void
    var onVideoTap: () -> Void
    //MARK: BODY
    var body: some View {
        CachedImageView(url: URL(string: recipe.photoUrlSmall ?? ""))
            .scaledToFill()
            .frame(width: Constants.imageFrameWidth, height: Constants.imageFrameHeight)
            .clipShape(RoundedRectangle(cornerRadius: Constants.imageCornerRadius))
        mainContainer()
        buttonContainer()
            .frame(maxWidth: .infinity)
            .padding(.bottom, Constants.buttonContainerBottom)
            .onAppear {
                isFavorite = favoritesVM.isFavorite(recipeID: recipe.id)
            }
            .onChange(of: recipe.id) { _, _ in
                isFavorite = favoritesVM.isFavorite(recipeID: recipe.id)
        }
    }
    //MARK: TOGGLE FAVORITE ON/OFF
    func toggleFavorite() {
        do {
            if isFavorite {
                Task {
                    await favoritesVM.deleteRecipe(FavoriteRecipe.mapper(from: recipe))
                }
                snackbarPresenter.show(message: "\(recipe.name) \(Constants.removeFromFavoriteText)")
            } else {
                try favoritesVM.addToFavorites(recipe: recipe)
                snackbarPresenter.show(message: "\(recipe.name) \(Constants.addToFavoriteText)")
            }
            isFavorite.toggle()
        } catch {
            snackbarPresenter.show(message: "\(Constants.failedFavoriteText) \(error.localizedDescription)")
        }
    }
}
