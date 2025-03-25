//
//  MockRecipeDataService.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//
import XCTest
import SwiftUI
@testable import RecipeMaker

class MockRecipeDataService: DataService<FavoriteRecipe> {
    var mockFavoriteRecipes: [FavoriteRecipe] = []
    var shouldThrowError = false
    
    override func fetchAll() throws -> [FavoriteRecipe] {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fetch Failed"])
        }
        return mockFavoriteRecipes
    }
    
    override func isMatching(from id: String) -> Bool {
        return mockFavoriteRecipes.contains { $0.id == id }
    }
    
    override func add(_ item: T) throws {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Add failed"])
        }
        mockFavoriteRecipes.append(item)
    }
    
    override func remove(from id: String) throws {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Removal Failed"])
        }
        mockFavoriteRecipes.removeAll { $0.id == id }
    }
} 
