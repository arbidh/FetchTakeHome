//
//  SnackbarPresenterTests.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//
import XCTest
@testable import RecipeMaker

@MainActor
final class SnackbarPresenterTests: XCTestCase {
    var sut: SnackbarPresenter!
    
    override func setUp() {
        super.setUp()
        sut = SnackbarPresenter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testShowSnackbar() {
        let message = "Test Message"
        sut.show(message: message)
        XCTAssertTrue(sut.isShowing)
        XCTAssertEqual(sut.message, message)
    }
    
    func testSnackbarAutoHide() async throws {
        let message = "Test Message"
        sut.show(message: message)
        try await Task.sleep(nanoseconds: 2_100_000_000)
        XCTAssertFalse(sut.isShowing)
    }
    
    func testMultipleSnackbarMessages() {
        let message1 = "First Message"
        let message2 = "Second Message"
        sut.show(message: message1)
        sut.show(message: message2)
        XCTAssertTrue(sut.isShowing)
        XCTAssertEqual(sut.message, message2)
    }
} 
