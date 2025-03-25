//
//  RecipeFavoritesView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftUI

struct FavoritesView: View {
    @State var viewModel: RecipeFavoritesViewModel
    @Namespace var animation
    @State private var isPresented = false
    @State private var selectedRecipe: FavoriteRecipe? = nil
    @Environment(\.colorScheme) var colorScheme
    let imageViewWidth: CGFloat = 50
    let imageViewHeight: CGFloat = 50
    let cornerRadius: CGFloat = 10
    let navigationTitle: String = "Desert Recipes"
    let alertErrorText: String = "Error occured Loading Recipes"
    let alertButtonText: String = "OK"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.favoriteRecipes, id: \.self) { recipe in
                    HStack {
                        if let photoURL = recipe.photoURL, let url = URL(string: photoURL) {
                            CachedImageView(url: url)
                                .frame(width: imageViewWidth, height: imageViewHeight)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        }
                        
                        VStack(alignment: .leading) {
                            Text(recipe.name)
                                .font(.headline)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            Text(recipe.cuisine)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectFavorite(recipe)
                    }
                }
                .onDelete { indexSet in
                    if !viewModel.isDeleting {
                        viewModel.deleteRecipes(at: indexSet)
                    }
                }
            }
            .navigationTitle(navigationTitle)
            .onAppear {
                Task {
                    await viewModel.loadFavorites()
                }
            }
            .onChange(of: selectedRecipe) { newValue, oldValue in
                if newValue != nil {
                    isPresented = true
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                if let selectedRecipe = selectedRecipe {
                    let recipe = RecipeResult.mapper(from: selectedRecipe)
                    RecipeDetailView(recipe: recipe, namespace: animation, isPresented: $isPresented)
                }
            }
            .alert(alertErrorText, isPresented: $viewModel.showError) {
                Button(alertButtonText, role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
        .background(colorScheme == .dark ? Color(UIColor.systemBackground): .white)
    }
    
    private func selectFavorite(_ favRecipe: FavoriteRecipe) {
        selectedRecipe = favRecipe
        isPresented = true
    }
}
