import SwiftUI
import UIKit

/// In-memory cache for decoded images, backed by asset-catalog or on-disk lookups via
/// `MediaLibraryService`. Keeps timeline scrolling smooth by avoiding repeated decodes.
@Observable
final class MediaCacheService {
    static let shared = MediaCacheService()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(for item: MediaItem) async -> UIImage? {
        let key = cacheKey(for: item) as NSString
        if let cached = cache.object(forKey: key) {
            return cached
        }
        let image = await loadImage(for: item)
        if let image {
            cache.setObject(image, forKey: key)
        }
        return image
    }

    private func cacheKey(for item: MediaItem) -> String {
        item.fileURL?.absoluteString ?? item.assetName ?? item.id.uuidString
    }

    private func loadImage(for item: MediaItem) async -> UIImage? {
        if let url = item.fileURL {
            return await loadImage(from: url)
        }
        if let name = item.assetName {
            if let asset = UIImage(named: name) {
                return asset
            }
            if let bundleURL = MediaLibraryService.bundleURL(forMediaNamed: name) {
                return await loadImage(from: bundleURL)
            }
        }
        return nil
    }

    private func loadImage(from url: URL) async -> UIImage? {
        await Task.detached(priority: .userInitiated) {
            guard let data = try? Data(contentsOf: url) else { return nil }
            return UIImage(data: data)
        }.value
    }
}
