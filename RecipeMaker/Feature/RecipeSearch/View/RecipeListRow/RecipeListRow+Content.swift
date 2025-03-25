//
//  RecipeListRow+Content.swift
//  RecepieMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import SwiftUI
extension RecipeRow {
    struct Constants {
        static let landscapeScrollHeightMultiplier: CGFloat = 0.75
        static let scrollToTopButtonTrailingPadding: CGFloat = 20
        static let scrollToTopButtonBottomPaddingPortrait: CGFloat = 80
        static let scrollToTopButtonBottomPaddingLandscape: CGFloat = 20
        static let radialGradientStartRadius: CGFloat = 0
        static let radialGradientEndRadius: CGFloat = 2000
        static let safeAreaInsetHeightPortrait: CGFloat = 60
        static let safeAreaInsetHeightLandscape: CGFloat = 40
        static let scrollOffsetThreshold: CGFloat = -100
        static let animationDuration: CGFloat = 0.2
        static let gridSpacing: CGFloat = 10
        static let gridItemWidthDivider: CGFloat = 4
        static let gridCellMaxHeightLandscape: CGFloat = 300
        static let gridCellMinWidthPortrait: CGFloat = 150
        static let gridCellHeightPortrait: CGFloat = 350
        static let gridPaddingHorizontal: CGFloat = 8
        static let gridPaddingVertical: CGFloat = 10
        static let topAnchorid: String = "TOP_ANCHOR"
        static let frameHeight: CGFloat = 0
        static let maxItemsPerRowLandscape: Int = 4
    }
    @ViewBuilder
    func showRecipeList(proxy: GeometryProxy) -> some View {
        let isLandscape = horizontalSizeClass == .regular
        ScrollViewReader { scrollProxy in
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if isLandscape {
                        ScrollView(.vertical, showsIndicators: true) {
                            scrollContentView(proxy: proxy, isLandscape: true)
                        }
                        .frame(height: proxy.size.height * Constants.landscapeScrollHeightMultiplier)
                        .background(Color.white)
                    } else {
                        ScrollView(.vertical) {
                            scrollContentView(proxy: proxy, isLandscape: false)
                        }
                        .background(Color.white)
                    }
                }
                if showScrollToTop {
                    scrollToTopButton(proxy: scrollProxy)
                        .padding(.trailing, Constants.scrollToTopButtonTrailingPadding)
                        .padding(.bottom, isLandscape ? Constants.scrollToTopButtonBottomPaddingLandscape : Constants.scrollToTopButtonBottomPaddingPortrait)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .background(RadialGradient(colors: [.white, .gray], center: .top, startRadius: Constants.radialGradientStartRadius, endRadius: Constants.radialGradientEndRadius))
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: isLandscape ? Constants.safeAreaInsetHeightLandscape : Constants.safeAreaInsetHeightPortrait)
            }
        }
    }
    
    @ViewBuilder
    private func scrollContentView(proxy: GeometryProxy, isLandscape: Bool) -> some View {
        GeometryReader { geometry in
            let offset = geometry.frame(in: .global).minY
            Color.clear
                .onChange(of: offset) { _, newValue in
                    if offset < Constants.scrollOffsetThreshold && !showScrollToTop {
                        withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                            showScrollToTop = true
                        }
                    } else if offset >= 0 && showScrollToTop {
                        withAnimation(.easeInOut(duration: Constants.animationDuration)) {
                            showScrollToTop = false
                        }
                    }
                }
        }
        .frame(height: Constants.frameHeight)
        
        Text("")
            .frame(height: Constants.frameHeight)
            .id(Constants.topAnchorid)
        
        if isLandscape {
            LazyVGrid(columns: Array(repeating: GridItem(.fixed(proxy.size.width / Constants.gridItemWidthDivider - Constants.gridSpacing), spacing: Constants.gridSpacing), count: Constants.maxItemsPerRowLandscape), spacing: Constants.gridPaddingVertical) {
                ForEach(filteredProducts, id: \.id) { item in
                    presentCell(item: item)
                        .frame(maxWidth: .infinity, maxHeight: Constants.gridCellMaxHeightLandscape)
                }
            }
            .padding(.horizontal, Constants.gridPaddingHorizontal)
            .padding(.vertical, Constants.gridPaddingVertical)
            .animation(nil, value: showScrollToTop)
        } else {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.gridCellMinWidthPortrait), spacing: Constants.gridSpacing)], spacing: Constants.gridSpacing) {
                ForEach(filteredProducts, id: \.id) { item in
                    presentCell(item: item)
                        .frame(maxWidth: .infinity)
                        .frame(height: Constants.gridCellHeightPortrait)
                }
            }
            .padding(.horizontal, Constants.gridPaddingHorizontal)
            .animation(nil, value: showScrollToTop)
        }
    }
}
