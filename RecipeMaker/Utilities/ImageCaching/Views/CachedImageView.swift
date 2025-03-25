//
//  LazyImageView.swift
//  RecipeMaker
//
//  Created by Arbi Derhartunian on 3/21/25.
//
import SwiftUI
extension CachedImageView {
    enum Constants {
        static let imageSizeWidth: CGFloat = 100
        static let imageSizeHeight: CGFloat = 100
        static let errorLoadingTitle: String = "Eror Loading Image"
        static let cornerRadius: CGFloat = 30
    }
}
struct CachedImageView: View {
    let url: URL?
    @State private var image: UIImage?
    private let imageSize: CGSize
    public var errorLoadingImageTitle = Constants.errorLoadingTitle
    init(url: URL?, size: CGSize = CGSize(width: Constants.imageSizeHeight, height: Constants.imageSizeWidth)) {
        self.url = url
        self.imageSize = size
    }
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                    .frame(width: imageSize.width, height: imageSize.height)
            } else {
                ProgressView()
                    .frame(width: imageSize.width, height: imageSize.height)
                    .task {
                        await loadImage()
                }
            }
        }
    }
}
//MARK: Loading Image from Cache if it exists otherwise fetch from API
private extension CachedImageView {
     func loadImage() async {
        guard let url = url?.absoluteString else { return }
        if let cachedImage = try? await ImageCache.shared.image(for: url) {
            self.image = cachedImage
            return
        }
        guard let imageUrl = self.url else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: imageUrl)
            if let downloadedImage = UIImage(data: data) {
                let resizedImage = await downloadedImage.resizeImage(downloadedImage)
                await ImageCache.shared.insertImage(resizedImage, for: url)
                self.image = resizedImage
            }
        } catch {
           //handle errors
        }
    }
}

