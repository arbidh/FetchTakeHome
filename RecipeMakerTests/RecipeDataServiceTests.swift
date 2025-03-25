//
//  RecipeDataServiceTests.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import XCTest
import SwiftData
import SwiftUI
@testable import RecipeMaker

@MainActor
final class RecipeDataServiceTests: XCTestCase {
    var sut: DataService<FavoriteRecipe>!
    var testRecipe: RecipeResult!
    
    @MainActor
    override func setUp() {
        super.setUp()
        sut = MockRecipeDataService(schema: Schema([FavoriteRecipe.self]))
        testRecipe = RecipeResult(uuid: "1", cuisine: "Test Cuisine", name: "Test Recipe", photoUrlLarge: "htttps://test.com/photo.jpg", photoUrlSmall: "https://test.com/photo.jpg", sourceUrl: "https://test.com/recipe", youtubeUrl: "https://youtube.com/test")
    }
    
    override func tearDown() {
        sut = nil
        testRecipe = nil
        super.tearDown()
    }

    func testAddToFavorites() throws {
        let favorites = FavoriteRecipe.mapper(from: testRecipe)
        try sut.add(favorites)
        XCTAssertTrue(sut.isMatching(from: favorites.id))
    }
    
    func testAddTwoFavorites() throws {
        let favorites1 = FavoriteRecipe.mapper(from: testRecipe)
        try sut.add(favorites1)
        let testRecipe1 = RecipeResult(uuid: "2", cuisine: "Test Cuisine", name: "Test Recipe2", photoUrlLarge: "htttps://test.com/photo.jpg", photoUrlSmall: "https://test.com/photo.jpg", sourceUrl: "https://test.com/recipe", youtubeUrl: "https://youtube.com/test")
        let favorites2 = FavoriteRecipe.mapper(from: testRecipe1)
        try sut.add(favorites2)
        let favoriteRecipes:[FavoriteRecipe] = try sut.fetchAll()
        XCTAssert(favoriteRecipes.count == 2)
    }
    
    func testAddRemoveFromFavorites() throws {
        let testRecipe = createFavoritesTestModels()[0]
        try sut.add(testRecipe)
        try sut.remove(from: testRecipe.id)
        XCTAssertFalse(sut.isMatching(from: testRecipe.id))
    }
    
    func testRemove2Favorites() throws {
        let testRecipe:[FavoriteRecipe] = createFavoritesTestModels()
        let testRecipe1 = testRecipe[1]
        try sut.remove(from: testRecipe[0].id)
  
        try sut.remove(from: testRecipe1.id)
        let favoriteRecipes:[FavoriteRecipe] = try sut.fetchAll()
        XCTAssert(favoriteRecipes.count == 0)
    }

    func testGetFavorites() async throws {
        try removeAll()
        let testRecipe = createFavoritesTestModels()[0]
        try sut.add(testRecipe)
        let favorites = try sut.fetchAll()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.id, testRecipe.id)
    }
    
    private func removeAll() throws {
        for favor in try sut.fetchAll() {
            try sut.remove(from: favor.id)
        }
    }
    
    private func createFavoritesTestModels() -> [FavoriteRecipe] {
        let recipe = RecipeResult(uuid: "1", cuisine: "Test Cuisine1", name: "Test Recipe2", photoUrlLarge: "htttps://test.com/photo.jpg", photoUrlSmall: "https://test.com/photo.jpg", sourceUrl: "https://test.com/recipe", youtubeUrl: "https://youtube.com/test")
        let receipe2 = RecipeResult(uuid: "2", cuisine: "Test Cuisine2", name: "Test Recipe2", photoUrlLarge: "htttps://test.com/photo.jpg", photoUrlSmall: "https://test.com/photo.jpg", sourceUrl: "https://test.com/recipe", youtubeUrl: "https://youtube.com/test")
        let favorite = FavoriteRecipe.mapper(from: recipe)
        let favorite2 = FavoriteRecipe.mapper(from: receipe2)
        return [favorite,favorite2]
    }
}
