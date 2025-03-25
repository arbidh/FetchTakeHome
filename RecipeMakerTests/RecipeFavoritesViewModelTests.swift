
//
//  RecipeFavoriesViewModelTests.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//
import XCTest
import SwiftData
@testable import RecipeMaker
@MainActor
final class RecipeFavoritesViewModelTests: XCTestCase {
    var sut: RecipeFavoritesViewModel!
    var mockDataService: MockRecipeDataService!
    
    override func setUp() {
        super.setUp()
        mockDataService = MockRecipeDataService(schema: Schema([FavoriteRecipe.self]))
        sut = RecipeFavoritesViewModel(dataService: mockDataService)
    }
    
    override func tearDown() {
        sut = nil
        mockDataService = nil
        super.tearDown()
    }
    

    func testLoadFavorites_Failure() async {
        mockDataService.shouldThrowError = true
        await sut.loadFavorites()
        XCTAssertTrue(sut.favoriteRecipes.isEmpty)
        XCTAssertTrue(sut.showError)
        XCTAssertFalse(sut.errorMessage.isEmpty)
    }
    
    func testDeleteRecipe_Success() async {
        let recipe = FavoriteRecipe(id: "1", name: "Test Recipe", photoURL: nil, cuisine: "Italian", sourceUrl: nil, youtubeUrl: nil)
        mockDataService.mockFavoriteRecipes = [recipe]
        await sut.deleteRecipe(recipe)
        XCTAssertTrue(sut.favoriteRecipes.isEmpty)
        XCTAssertFalse(sut.showError)
    }
    
    func testDeleteRecipe_Failure() async {

        let recipe = FavoriteRecipe(id: "1", name: "Test Recipe", photoURL: nil, cuisine: "Italian", sourceUrl: nil, youtubeUrl: nil)
        mockDataService.shouldThrowError = true
        await sut.deleteRecipe(recipe)
        XCTAssertTrue(sut.showError)
        XCTAssertFalse(sut.errorMessage.isEmpty)
    }
    
    func testDeleteRecipes_Multiple() async {
        let recipes = [
            FavoriteRecipe(id: "1", name: "Recipe 1", photoURL: nil, cuisine: "Italian", sourceUrl: nil, youtubeUrl: nil),
            FavoriteRecipe(id: "2", name: "Recipe 2", photoURL: nil, cuisine: "French", sourceUrl: nil, youtubeUrl: nil)
        ]
        mockDataService.mockFavoriteRecipes = recipes
        await sut.loadFavorites()

       
        await sut.deleteRecipe(recipes[0])
        await sut.deleteRecipe(recipes[1])
        let expectation = XCTestExpectation(description: "Delete multiple recipes")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertTrue(self.sut.favoriteRecipes.isEmpty)
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 2)
    }
} 
