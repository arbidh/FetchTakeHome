//
//  LoadingView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//
import SwiftUI
struct LoadingView: View {
    @State private var isAnimating = false
    @State private var dots = ""
    let systemImageString: String = "birthday.cake"
    let mainTitle: String = "Desert Search"
    let topSpacing: CGFloat = 20
    let imageWidth: CGFloat = 60
    let imageHeight: CGFloat = 60
    let loadingTitle: String = "Loading"
    let rotationDegress: CGFloat = 360
    let maxDots: Int = 3
    let animationDuration: TimeInterval = 1
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: topSpacing) {
            Text(mainTitle)
                .font(.largeTitle)
                .bold()
                .foregroundColor(.blue)
            
            Image(systemName: systemImageString)
                .resizable()
                .frame(width: imageWidth, height: imageHeight)
                .foregroundColor(.blue)
                .rotationEffect(.degrees(isAnimating ? rotationDegress : 0))
                .animation(
                    .linear(duration: animationDuration)
                    .repeatForever(autoreverses: false),
                    value: isAnimating
                )
            
            Text("\(loadingTitle)\(dots)")
                .font(.title2)
                .bold()
                .foregroundColor(.gray)
        }
        .onAppear {
            isAnimating = true
        }
        .onReceive(timer) { _ in
            if dots.count >= maxDots {
                dots = ""
            } else {
                dots += "."
            }
        }
    }
} 
