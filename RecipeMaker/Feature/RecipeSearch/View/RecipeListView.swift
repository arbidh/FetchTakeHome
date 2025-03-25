//
//  RecipeListView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
import SwiftData

struct RecipeListView: View {
    enum Constants {
        static let RowWidth: CGFloat = UIScreen.main.bounds.width - 32
        static let RowHeight: CGFloat = 80
        static let RowFontSize: CGFloat = 14
        static let RowAlertTitle: String = "Error Occurred"
        static let RowAlertButtonRetryTitle = "Retry"
        static let RowAlertButtonCancelTitle = "Cancel"
        static let navigationTitle = "Search Your Desert"
    }
    
    @State private var viewModel: RecipeListViewModel
    let favoriteVM: RecipeFavoritesViewModel
    @State private var categories:[String] = []
    @State private var isInitialLoading = true
    @State private var hasError = false
    @State private var errorMessage = "Unable To Load Recipes Please check your connection"
    @State private var selectedCategory: String? = nil
    @Environment(\.colorScheme) private var colorScheme
    
    init(favoriteVM: RecipeFavoritesViewModel) {
        self.favoriteVM = favoriteVM
        let network = APIService()
        let recipeService = RecipeService(httpClient: network)
        let viewModel = RecipeListViewModel(service: recipeService)
        _viewModel = State(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            RecipeRow(viewModel: viewModel, favoriteVM: favoriteVM, categories: categories)
                .task {
                    await loadInitialData()
                }
                .refreshable {
                    await loadInitialData()
                }
                .navigationTitle(selectedCategory ?? Constants.navigationTitle)
                .navigationBarTitleTextColor(colorScheme == .dark ? .white : .black)
                .alert(Constants.RowAlertTitle, isPresented: $hasError) {
                    Button(Constants.RowAlertButtonRetryTitle) {
                        Task {
                            await loadInitialData()
                        }
                    }
                    Button(Constants.RowAlertButtonCancelTitle, role: .cancel) {}
                } message: {
                    Text(errorMessage)
                }
        }
    }

    private func loadInitialData() async {
        do {
            try await viewModel.fetch()
             await favoriteVM.loadFavorites()
            let categoryArr = Set(viewModel.receipeResult.map{$0.cuisine})
            categories = Array(categoryArr)
        } catch {
            hasError = true
            errorMessage = errorMessage
        }
    }
}

extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor]
        return self
    }
}

#Preview {
    let dataService = DataService<FavoriteRecipe>(schema: Schema())
    let favoriteVM = RecipeFavoritesViewModel(dataService: dataService)
    RecipeListView(favoriteVM: favoriteVM)
}
