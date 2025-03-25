//
//  WebContainer.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/22/25.
//

import SwiftUI

struct WebContainer: View {
    @State var hello: Bool = false
    @State var url: String?
    @State var showVideo: Bool
    @State var selectedRecipe: RecipeResult?
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    // Constants for button styling
    private let closeButtonSize: CGFloat = 30
    private let closeButtonPadding: CGFloat = 16
    private let imageName = "xmark.circle.fill"
    
    var body: some View {
        if let url = showVideo ? selectedRecipe?.youtubeUrl : selectedRecipe?.sourceUrl {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 12) {
                    Text(selectedRecipe?.name ?? "")
                        .font(.headline)
                        .padding(.top, 50)  // Add padding to avoid overlap with close button
                    
                    if let cuisine = selectedRecipe?.cuisine {
                        Text(cuisine)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    RecipeWebView(urlString: url)
                        .edgesIgnoringSafeArea(.bottom)
                }
                
                // Close button
                Button(action: { dismiss() }) {
                    Image(systemName: imageName)
                        .resizable()
                        .frame(width: closeButtonSize, height: closeButtonSize)
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .background(
                            Circle()
                                .fill(colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.8))
                                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
                        )
                }
                .padding(closeButtonPadding)
                .zIndex(1) // Ensure button stays on top
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    WebContainer(url: "", showVideo: false, selectedRecipe: nil)
}

#Preview {
    WebContainer(url: "", showVideo: false, selectedRecipe: nil)
}
