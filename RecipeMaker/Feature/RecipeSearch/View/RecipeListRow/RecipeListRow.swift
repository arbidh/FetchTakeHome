//
//  RecipeListRow.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import SwiftUI
struct RecipeRow: View {
    @State var selectedCategory: String?
    @State private var showVideo = false
    @State private var showWeb = false
    @State private var showCell = false
    @State private var selectedRecipe: RecipeResult?
    @State private var extractedText = ""
    @State private var searchText = ""
    @Namespace var animation
    @State var showAllCategories = false
    let viewModel: RecipeListViewModel
    let favoriteVM: RecipeFavoritesViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.colorScheme) private var colorScheme
    @State private var result: [RecipeResult] = []
    @State var showScrollToTop = false
    let categories:[String]
    let horizontalSizeClassRegularPadding: CGFloat = 5
    let horizontalSizeClassCompactPadding: CGFloat = 10
    let gradientEndRadius: CGFloat = 2000
    let gradientStartRadius: CGFloat = 0
    let navigationTitle = "Search Your Desert"
    let defaultValueScrollOffest: CGFloat = 0
    let backgroundOpacity: CGFloat = 0.3
    var body: some View {
        GeometryReader { proxy in
            VStack {
                showCategories()
                    .padding(.bottom,
                            horizontalSizeClass == .regular ? horizontalSizeClassRegularPadding : horizontalSizeClassCompactPadding)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                showRecipeList(proxy: proxy)
                    .sheet(isPresented: Binding(
                        get: { showWeb && selectedRecipe != nil },
                        set: { if !$0 { showWeb = false; selectedRecipe = nil } }
                    )) {
                        WebContainer(showVideo: showVideo, selectedRecipe: selectedRecipe)
                    }
                    .sheet(isPresented: Binding(
                        get: { showVideo && selectedRecipe != nil },
                        set: { if !$0 { showVideo = false; selectedRecipe = nil } }
                    )) {
                        WebContainer(showVideo: showVideo, selectedRecipe: selectedRecipe)
                    }
                    .fullScreenCover(isPresented: Binding(
                        get: { showCell && selectedRecipe != nil },
                        set: { if !$0 { showCell = false;
                            selectedRecipe = nil } }
                    )){
                        if let selectedRecipe = selectedRecipe {
                            RecipeDetailView(recipe: selectedRecipe, namespace: animation, isPresented: $showCell)
                        }
                    }
            }
            .background(
                RadialGradient(
                    colors: [colorScheme == .dark ? Color.gray.opacity(backgroundOpacity) : .white,
                            colorScheme == .dark ? .black : .gray],
                    center: .top,
                    startRadius: gradientStartRadius,
                    endRadius: gradientEndRadius
                )
            )
            .navigationTitle(self.selectedCategory ?? navigationTitle)
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
    }
    
}
//MARK: Filtered Prodcuts and Category
extension RecipeRow {
    var filteredProducts: [RecipeResult] {
        viewModel.receipeResult.filter { recipe in
            let matchesSearch = searchText.isEmpty ||
                recipe.cuisine.localizedCaseInsensitiveContains(searchText) ||
                recipe.name.localizedCaseInsensitiveContains(searchText)
            
            let matchesCategory = selectedCategory == nil || recipe.cuisine == selectedCategory
            
            return matchesSearch && matchesCategory
        }
    }
}

//MARK: CELL 
extension RecipeRow {
    @ViewBuilder
    func presentCell(item: RecipeResult) -> some View {
        RecipeCardView(recipe: item, showVideo: $showVideo, showWebView: $showWeb, favoritesVM: favoriteVM) {
            selectedRecipe = item
            showCell = true
        } onWebTap: {
            selectedRecipe = item
            showWeb = true
        } onVideoTap: {
            selectedRecipe = item
            showVideo = true
        }
        .contentShape(Rectangle())
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

