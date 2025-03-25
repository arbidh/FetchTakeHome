//
//  RecipeFavoritesViewModel.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/22/25.
//
import SwiftUI

@Observable
class RecipeFavoritesViewModel {
    private let dataService: DataService<FavoriteRecipe>
    var favoriteRecipes: [FavoriteRecipe] = []
    var errorMessage: String = "Failed to load favorites: "
    var errorDeleteMessage: String = "Failed to delete favorites: "
    var showError: Bool = false
    var isDeleting: Bool = false
    
    init(dataService: DataService<FavoriteRecipe>) {
        self.dataService = dataService
    }
    
    @MainActor
    func addToFavorites(recipe: RecipeResult) throws {
        guard !isFavorite(recipeID: recipe.id) else { return }
        let favorite = FavoriteRecipe.mapper(from: recipe)
        try dataService.add(favorite)
    }

    @MainActor
    func loadFavorites() async {
        do {
            favoriteRecipes = try dataService.fetchAll()
        } catch {
            errorMessage = "\(errorMessage)\(error.localizedDescription)"
            showError = true
        }
    }
    
    @MainActor
    func deleteRecipe(_ recipe: FavoriteRecipe) async {
        guard !isDeleting else { return }
        isDeleting = true
        
        do {
            try dataService.remove(from: recipe.id)
            favoriteRecipes.removeAll { $0.id == recipe.id }
        } catch {
            errorMessage = "\(errorDeleteMessage) \(error.localizedDescription)"
            showError = true
        }
        
        isDeleting = false
    }
    
    @MainActor
    func isFavorite(recipeID: String) -> Bool {
        return dataService.isMatching(from: recipeID)
    }
    
    @MainActor
    func deleteRecipes(at offsets: IndexSet) {
        guard !isDeleting else { return }
        isDeleting = true
        let recipesToDelete = offsets.map { favoriteRecipes[$0] }

        for offset in offsets.sorted(by: >) {
            if offset < favoriteRecipes.count {
                favoriteRecipes.remove(at: offset)
            }
        }

        Task {
            for recipe in recipesToDelete {
                do {
                    try  dataService.remove(from: recipe.id)
                } catch {
                    await loadFavorites()
                    errorMessage = "\(errorDeleteMessage) \(error.localizedDescription)"
                    showError = true
                    break
                }
            }
            isDeleting = false
        }
    }
} 
