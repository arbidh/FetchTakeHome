//
//  RecipeListRow+Category.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/24/25.
//

import SwiftUI

extension RecipeRow {
    enum ConstantsCategory {
        static let vgGridMinimumSize: CGFloat = 100
        static let vgGridSpacing: CGFloat = 5
        static let hStackSpacing: CGFloat = 15
        static let categoryUpImage: String = "chevron.up"
        static let categoryDownImage: String = "chevron.down"
    }
    private func toggleCategory(_ category: String) {
        if selectedCategory == category {
            selectedCategory = nil // Deselect if already selected
        } else {
            selectedCategory = category
        }
    }
    @ViewBuilder
    func showCategories() -> some View {
        if showAllCategories {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: ConstantsCategory.vgGridMinimumSize))], spacing: ConstantsCategory.vgGridSpacing) {
                Button(action: {
                    showAllCategories.toggle()
                }) {
                    Image(systemName: ConstantsCategory.categoryUpImage)
                        .font(.headline)
                        .padding()
                        .foregroundColor(.blue)
                }
                ForEach(categories, id: \.self) { category in
                    CategoryButton(category: category, isSelected: selectedCategory == category) {
                        toggleCategory(category)
                    }
                }
            }
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: ConstantsCategory.hStackSpacing) {
                    Button(action: {
                        showAllCategories.toggle()
                    }) {
                        Image(systemName: ConstantsCategory.categoryDownImage)
                            .font(.headline)
                            .padding()
                            .foregroundColor(.blue)
                    }
                    ForEach(categories, id: \.self) { category in
                        CategoryButton(category: category, isSelected: selectedCategory == category) {
                            toggleCategory(category)
                        }
                    }
                }
            }
        }
    }
}
