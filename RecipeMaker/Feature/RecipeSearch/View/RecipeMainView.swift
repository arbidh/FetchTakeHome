//
//  RecipeMainView.swift
//  RecepieMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
struct RecipeMainView: View {
    @State private var snackBarPresenter = SnackbarPresenter()
    @State private var recipeDataService: DataService<FavoriteRecipe>
    @State private var favoritesViewModel: RecipeFavoritesViewModel

    init(recipeDataService: DataService<FavoriteRecipe>) {
        _recipeDataService = State(initialValue: recipeDataService)
        _favoritesViewModel = State(initialValue: RecipeFavoritesViewModel(dataService: recipeDataService))
    }
    let tabListViewText: String = "Recipes"
    let tabListViewImageName: String = "book"
    let tabfavoriteText: String = "Favorite"
    let tabfavoriteImageName: String = "heart.fill"
    let animationResponse: CGFloat = 0.5
    let animationDamping: CGFloat = 0.7
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                RecipeListView(favoriteVM: favoritesViewModel)
                    .tabItem {
                        Label(tabListViewText, systemImage: tabListViewImageName)
                    }
                FavoritesView(viewModel: favoritesViewModel)
                    .tabItem {
                        Label(tabfavoriteText, systemImage: tabfavoriteImageName)
                    }
            }
            if snackBarPresenter.isShowing {
                SnackbarView(message: snackBarPresenter.message)
                    .transition(.move(edge: .bottom))
                    .animation(.spring(response: animationResponse, dampingFraction: animationDamping), value: snackBarPresenter.isShowing)
            }
        }
        .environment(snackBarPresenter)
    }
}
