//
//  RecipeDetailView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI

struct RecipeDetailView: View {
    enum Constants {
        static let closeButtonAnimationResponse: CGFloat = 6
        static let closeButtonDampingFraction: CGFloat = 0.8
        static let easinEaseoutDuration: TimeInterval = 30
        static let mainContainerVStackSpacing: CGFloat = 36
        static let mainContainerButtonHeight: CGFloat = 36
        static let mainContainerWebText: String = "Web"
        static let mainConterinerVideoText: String = "Video"
        static let closeButtonImageName = "xmark.circle.fill"
        static let closeButtonSize: CGFloat = 30
        static let closeButtonPadding: CGFloat = 16
        
        enum Content {
            static let animationDuration: CGFloat = 0.3
            static let detailContentSpacing:CGFloat = 20
            static let clipCornerRadius: CGFloat = 30
            static let detailContentTop: CGFloat = 20
            static let imageMaxWidthShowingDetails:CGFloat = 300
            static let imageMaxWidthNotShowingDetails: CGFloat = 200
            static let progressViewWidth: CGFloat = 200
            static let progressViewHeight: CGFloat = 200
            static let cuisingSpacing: CGFloat = 15
            static let contentSpacing: CGFloat = 20
            static let abilitiesConrerRadius: CGFloat = 15
            static let detailshadowRadius: CGFloat = 5
            static let mainContainerVStackSpacing: CGFloat = 8
            static let cuisineText: String = "Cuisine"
            static let cuisineImage: String = "fork.knife.circle"
            static let loadingRecipeDetails: String = "Loading Recipe Details.."
            static let cuisineImageHeight: CGFloat = 30
            static let cuisineSpacing: CGFloat = 30
            static let cuisineCornerRadius: CGFloat = 30
            static let cuisineShadwGrayOpacity: CGFloat = 0.5
            static let cuisineShadowRadius: CGFloat = 30
            static let contentCornerRadius: CGFloat = 30
            static let contentShadow: CGFloat = 30
            static let contentName: String = "name"
            static let detailOpacity: CGFloat = 1
        }
    }
    @State var recipe: RecipeResult
    let namespace: Namespace.ID
    @Binding var isPresented: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    @State private var showDetails = false
    @State private var showWebView = false
    @State private var showVideo = false
    @State private var playVideo = false

    init(recipe: RecipeResult, namespace: Namespace.ID, isPresented: Binding<Bool>) {
        self.recipe = recipe
        self.namespace = namespace
        self._isPresented = isPresented
    }
    
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .systemBackground)
                .ignoresSafeArea()
            mainContainer()
                .sheet(isPresented: $showWebView) {
                    WebContainer(showVideo: false, selectedRecipe: recipe)
                }
                .sheet(isPresented: $showVideo) {
                    WebContainer(showVideo: true, selectedRecipe: recipe)
                }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            withAnimation(.easeInOut(duration: Constants.easinEaseoutDuration)) {
                showDetails = true
            }
        }
    }
}
//MARK: Containers
extension RecipeDetailView {
    private func mainContainer() -> some View {
        VStack {
            HStack {
                Button(action: {
                    withAnimation(.spring(response: Constants.closeButtonAnimationResponse,
                                       dampingFraction: Constants.closeButtonDampingFraction)) {
                        showDetails = false
                        isPresented = false
                    }
                }) {
                    Image(systemName: Constants.closeButtonImageName)
                        .font(.system(size: Constants.closeButtonSize))
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                }
                .padding(Constants.closeButtonPadding)
                Spacer()
            }
            
            DetailContent(recipe: recipe, showDetail: showDetails)
            
            VStack(spacing: Constants.Content.mainContainerVStackSpacing) {
                if let _ = recipe.sourceUrl {
                    Button(action: { showWebView = true }) {
                        Text(Constants.mainContainerWebText)
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.mainContainerButtonHeight)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
                
                if let _ = recipe.youtubeUrl {
                    Button(action: { showVideo = true }) {
                        Text(Constants.mainConterinerVideoText)
                            .frame(maxWidth: .infinity)
                            .frame(height: Constants.mainContainerButtonHeight)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
    }
}
