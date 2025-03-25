//
//  UImage+Extension.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//

import UIKit
///MARK: Resize Image
extension UIImage {
     func resizeImage(_ image: UIImage) async -> UIImage {
         let size = CGSize(width: image.size.width * 2, height: image.size.height * 2) 
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { context in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
