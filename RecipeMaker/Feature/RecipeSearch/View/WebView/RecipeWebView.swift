//
//  RecipeWebView.swift
//  RecepieMaker
//
//  Created by Arbi Derhartunian on 3/23/25.
//

import WebKit
import SwiftUI

struct RecipeWebView {
    let urlString: String
    class Coordinator: NSObject {
        var parent: RecipeWebView
        private var observation: NSKeyValueObservation?
        
        init(parent: RecipeWebView) {
            self.parent = parent
            super.init()
        }
        
        deinit {
            observation?.invalidate()
        }
    }
}
extension RecipeWebView : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let webURL = URL(string: urlString) else { return }
        let request = URLRequest(url: webURL)
        webView.load(request)
    }
}

