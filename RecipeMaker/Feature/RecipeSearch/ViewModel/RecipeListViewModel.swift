//
//  RecipeListViewModel.swift
//  SparqChallenge
//
//  Created by Arbi Derhartunian on 3/5/25.
//

import Foundation

@Observable
class RecipeListViewModel {
    @MainActor  var receipeResult: [RecipeResult] = []
    private var isLoading = false
    
    private let recipeService: RecipeService
    init(service: RecipeService) {
        self.recipeService = service
    }

}
//MARK: Fetching from ListProtocol
extension RecipeListViewModel {
    @MainActor
    func fetch() async throws {
        guard !isLoading else { return }
        isLoading = true
        
        do {
            let result = try await recipeService.fetchRecipes()
            switch result {
            case .success(let recipeResult):
                self.receipeResult = recipeResult.recipes
            case .failure(let error):
                throw error
            }
        } catch {
            throw error
        }
        isLoading = false
    }
}
