//
//  MockAPIService.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//
import Foundation
@testable import RecipeMaker

class MockAPIService: HTTPClient {
    enum MockError: Error {
        case failedToLoadData
    }
    
    var shouldFail = false
    var mockDataType: MockDataType = .valid
    
    enum MockDataType {
        case valid
        case invalid
        case empty
    }
    
    func fetch(path: String) async throws -> HTTPClient.Result {
        if shouldFail {
            return .failure(.connectivity)
        }
        
        guard let data = mockData else {
            return .failure(.invalidResponse)
        }
        
        return .success((data: data, response: HTTPURLResponse(url: URL(string: "https://test.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!))
    }
    
    private var mockData: Data? {
        switch mockDataType {
        case .invalid:
            return getJSON("malformed")?.data(using: .utf8)
        case .empty:
            return emptyJSON.data(using: .utf8)
        case .valid:
            return getJSON("validData")?.data(using: .utf8)
        }
    }
    
    func getJSON(_ fileName: String) -> String? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: url)
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
    
    
    private let emptyJSON = """
    {
        "recipes": []
    }
    """
} 
