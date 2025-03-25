//
//  RecepieMakerApp.swift
//  RecepieMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftUI
import SwiftData
@main
struct RecepieMakerApp: App {
    @State private var isLoading = true
    private let recipeDataService = DataService<FavoriteRecipe>(schema: Schema([FavoriteRecipe.self]))
    enum Constants {
        static let duration: UInt64 = 1_500_000_000
    }
    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    LoadingView()
                        .task {
                            try? await Task.sleep(nanoseconds: Constants.duration)
                            await MainActor.run {
                                isLoading = false
                            }
                        }
                } else {
                    RecipeMainView(recipeDataService: recipeDataService)
                }
            }
        }
    }
}
