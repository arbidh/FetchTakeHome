//
//  APIService.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import Foundation

// MARK: HTTP Client Protocol
protocol HTTPClient {
    typealias Result = Swift.Result<(data: Data, response: HTTPURLResponse), APIError>
    func fetch(path: String) async throws -> Result
}

// MARK: API Service Implementation
final class APIService: HTTPClient {
    private let session: URLSession
    private let host = "d3jbb8n5wk0qxi.cloudfront.net"
    init(session: URLSession = .shared) {
        self.session = session
    }
    func fetch(path: String) async throws -> HTTPClient.Result {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        guard let url = components.url else {
            return .failure(APIError.invalidURL)
        }
        return await request(with: url)
    }
}
//MARK: APISERVICE MAPPER
extension APIService {
    func request(with url: URL) async -> HTTPClient.Result {
        do {
            let (data, response) = try await session.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(APIError.invalidResponse)
            }
            return .success((data: data, response: httpResponse))
        } catch {
            if error is DecodingError {
                return .failure(APIError.decodingError)
            }
            return .failure(APIError.connectivity)
        }
    }
}

// MARK: - Error Types
enum APIError: String, LocalizedError {
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid Response from API"
    case networkError = "Network Error occured"
    case decodingError = "Decoding Error occured"
    case connectivity = "Connectivity Error Occured"
}

// MARK: - HTTP Response Extension
extension HTTPURLResponse {
    private static var OK_200: Int { 200 }
    var isOK: Bool {
        return statusCode == Self.OK_200
    }
}
