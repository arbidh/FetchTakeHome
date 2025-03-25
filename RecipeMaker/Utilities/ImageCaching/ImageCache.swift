//
//  ImageCache.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//
import UIKit
//MARK: Image Caching
enum ImageCacheError: LocalizedError {
    case invalidImage
}
actor ImageCache {
    static let shared = ImageCache()
    private var cache = NSCache<NSString, UIImage>()
    enum Constants {
        static let countLimit = 100
        static let totalMBLimit = 50 * 1024 * 1024
    }
    private init() {
        cache.countLimit = Constants.countLimit
        cache.totalCostLimit = Constants.totalMBLimit
    }
    
    func image(for url: String) throws -> UIImage? {
        
        if let value = cache.object(forKey: url as NSString) {
            return value
        }
        throw ImageCacheError.invalidImage
    }
    
    func insertImage(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
    
} 
