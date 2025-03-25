//
//  LazyImageViewTests.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import XCTest
import SwiftUI
@testable import RecipeMaker

@MainActor
final class CachedImageView: XCTestCase {
    var imageCache: ImageCache!

    override func setUp() {
        super.setUp()
        imageCache = ImageCache.shared
    }
    override func tearDown() {
        imageCache = nil
        super.tearDown()
    }
    
    func testInsertImageLoadSuccess() async throws {
        let expectation = XCTestExpectation(description: "Image loaded")
        let testImageURL = URL(string: "https://one.com/test.jpg")!
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        _ = URLSession(configuration: config)
        let mockImageData = UIImage(systemName: "photo")
        MockURLProtocol.mockData = mockImageData?.pngData()
        MockURLProtocol.mockResponse = HTTPURLResponse(
            url: testImageURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "image/jpeg"]
        )
        await imageCache.insertImage(mockImageData!, for: testImageURL.relativePath)
        let image  = try await imageCache.image(for: testImageURL.relativePath)
        XCTAssertNotNil(image)
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testImageLoading_Failure() async {
        let expectation = XCTestExpectation(description: "Image loading failed")
        let testImageURL = URL(string: "https://one.com/no.jpg")!
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        _ = URLSession(configuration: config)
        MockURLProtocol.mockError = NSError(domain: "test", code: -1, userInfo: nil)

        do {
            _  = try await imageCache.image(for: testImageURL.relativePath)
            XCTFail("Expected error but got success")
        } catch {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testCacheSuccess() async throws {

        let testImageURL = URL(string: "https://one.com/onepic.jpg")!
        let mockImage = UIImage(systemName: "photo")!
        await imageCache.insertImage(mockImage, for: testImageURL.absoluteString)
        let cachedImage = try await imageCache.image(for: testImageURL.absoluteString)
        XCTAssertNotNil(cachedImage)
    }
    
    func testCacheMiss() async {
        let testImageURL = URL(string: "https://one.com/none.jpg")!
        let cachedImage = try? await imageCache.image(for: testImageURL.absoluteString)
        XCTAssertNil(cachedImage)
    }
}

// Mock URLProtocol for testing network requests
private final class MockURLProtocol: URLProtocol {
    static var mockData: Data?
    static var mockResponse: URLResponse?
    static var mockError: Error?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.mockError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        if let data = MockURLProtocol.mockData,
           let response = MockURLProtocol.mockResponse {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
} 
