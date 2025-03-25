//
//  FavoriteRecipe.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftData
import Foundation

@Model
final class FavoriteRecipe:IdentifiableModel {
    @Attribute(.unique) var id: String
    var name: String
    var photoURL: String?
    var cuisine: String
    var dateAdded: Date = Date()
    var sourceUrl: String?
    var youtubeUrl: String?

    init(id: String, name: String, photoURL: String?, cuisine: String, sourceUrl: String?, youtubeUrl: String?) {
        self.id = id
        self.name = name
        self.photoURL = photoURL
        self.cuisine = cuisine
        self.sourceUrl = sourceUrl
        self.youtubeUrl = youtubeUrl
    }
    
    static func mapper(from recipe: RecipeResult) -> FavoriteRecipe {
        return .init(
            id: recipe.id,
            name: recipe.name,
            photoURL: recipe.photoUrlLarge,
            cuisine: recipe.cuisine,
            sourceUrl: recipe.sourceUrl,
            youtubeUrl: recipe.youtubeUrl
        )
    }
}
