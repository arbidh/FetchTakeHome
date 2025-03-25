//
//  REcipeListViewModelTests.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//
import XCTest
@testable import RecipeMaker

@MainActor
final class RecipeListViewModelTests: XCTestCase {
    var mockAPIService: MockAPIService!
    var sut: RecipeListViewModel!
    
    override func setUp() {
        super.setUp()
        mockAPIService = MockAPIService()
        sut = RecipeListViewModel(service: RecipeService(httpClient: mockAPIService))
    }
    
    override func tearDown() {
        mockAPIService = nil
        sut = nil
        super.tearDown()
    }
    
    func testFetchRecipesEmpty() async throws {
        mockAPIService.mockDataType = .empty
        try await sut.fetch()
        XCTAssertTrue(sut.receipeResult.isEmpty)
    }
    
    func testFetchRecipesMalformed() async {
        mockAPIService.mockDataType = .invalid
        do {
            try await sut.fetch()
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertEqual(error as! RecipeService.Error, .decodingError)
        }
    }
    
    func testFetchRecipesNetworkError() async {
        do {
            try await sut.fetch()
            XCTFail("Expected to throw error")
        } catch {
            XCTAssertEqual(error as! RecipeService.Error, .connectivity)
        }
    }
} 
