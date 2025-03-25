//
//  RecipeService.swift
//  RecepiMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//
import Foundation

protocol RecipeList {
    func fetchRecipes() async throws -> RecipeService.Result
}

final class RecipeService: RecipeList {
    private let httpClient: HTTPClient
    private let baseEndpoint = "/recipes.json"
    
    public enum Result: Equatable {
        case success(Recepie)
        case failure(Error)
    }
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    func fetchRecipes() async throws -> Result {
        do {
            let result = try await httpClient.fetch(path: baseEndpoint)
            switch result {
            case .failure(_):
                return .failure(.connectivity)
            case let .success((data, response)):
                return handleSuccess(data: data, response: response)
            }
        } catch {
            throw error
        }
    }
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
        case decodingError
    }
}

extension RecipeService {
    func handleSuccess(data: Data, response: HTTPURLResponse) -> Result {
        do {
            let recipes = try RecipeMapper.decode(data, response)
            return .success(recipes)
        } catch {
            if error is DecodingError {
                return .failure(.decodingError)
            }
            return .failure(.invalidData)
        }
    }
}

private class RecipeMapper {
    static func decode(_ data: Data, _ response: HTTPURLResponse) throws -> Recepie {
        guard response.isOK else {
            throw RecipeService.Error.invalidData
        }
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let value = try decoder.decode(Recepie.self, from: data)
            return value
        }catch {
            throw error
        }
    }
}
