//
//  RecipeResult.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import Foundation
struct Recepie: Decodable, Hashable {
    let recipes: [RecipeResult]
}

struct RecipeResult: Identifiable, Decodable, Hashable, Sendable {
    var id: String {
        return uuid ?? ""
    }
    let uuid: String?
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let sourceUrl: String?
    let youtubeUrl: String?
    
    static func mapper(from favoriteRecipe: FavoriteRecipe) -> RecipeResult {
        return .init(
            uuid: favoriteRecipe.id,
            cuisine: favoriteRecipe.cuisine,
            name: favoriteRecipe.name,
            photoUrlLarge: favoriteRecipe.photoURL,
            photoUrlSmall: favoriteRecipe.photoURL,
            sourceUrl: favoriteRecipe.sourceUrl,
            youtubeUrl: favoriteRecipe.youtubeUrl
        )
    }
}
