import Foundation
import ImageIO

#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif

public final class ForensicImageCache: @unchecked Sendable {
    public static let shared = ForensicImageCache()

    private let cache = NSCache<NSString, PlatformImage>()
    private let lock = NSLock()
    private var pathCache: [String: String] = [:]

    public init() {
        // Generous cache limit, automatically purges under memory pressure
        cache.countLimit = 120
        cache.totalCostLimit = 64 * 1024 * 1024 // 64 MB maximum RAM limit

        #if canImport(UIKit) && !os(macOS)
        NotificationCenter.default.addObserver(
            forName: UIApplication.didReceiveMemoryWarningNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.clear()
        }
        #endif
    }

    public func clear() {
        lock.lock()
        cache.removeAllObjects()
        pathCache.removeAll()
        lock.unlock()
    }

    /// Resolves bundle or disk path for an asset name with internal caching
    public func resolvePath(for name: String) -> String? {
        let cleanName = (name as NSString).deletingPathExtension
        lock.lock()
        if let existing = pathCache[cleanName] {
            lock.unlock()
            return existing
        }
        lock.unlock()

        let extensions = ["jpg", "jpeg", "png"]
        var candidates = [cleanName]
        if cleanName.hasPrefix("suspect_") {
            candidates.append(String(cleanName.dropFirst("suspect_".count)))
        } else {
            candidates.append("suspect_\(cleanName)")
        }
        if cleanName.hasPrefix("evidence_") {
            candidates.append(String(cleanName.dropFirst("evidence_".count)))
        } else {
            candidates.append("evidence_\(cleanName)")
        }

        let currentDir = FileManager.default.currentDirectoryPath
        let fallbackDir = (currentDir as NSString).appendingPathComponent("Sources/Caseboard/Resources/Assets")
        let resPath = Bundle.main.resourcePath

        for candidate in candidates {
            // 1. Check Bundle.main
            for ext in extensions {
                if let p = Bundle.main.path(forResource: candidate, ofType: ext) {
                    lock.lock()
                    pathCache[cleanName] = p
                    lock.unlock()
                    return p
                }
            }

            // 2. Check Bundle.main.resourcePath
            if let resPath = resPath {
                for ext in extensions {
                    let p1 = (resPath as NSString).appendingPathComponent("\(candidate).\(ext)")
                    if FileManager.default.fileExists(atPath: p1) {
                        lock.lock()
                        pathCache[cleanName] = p1
                        lock.unlock()
                        return p1
                    }
                    let p2 = (resPath as NSString).appendingPathComponent("Assets/\(candidate).\(ext)")
                    if FileManager.default.fileExists(atPath: p2) {
                        lock.lock()
                        pathCache[cleanName] = p2
                        lock.unlock()
                        return p2
                    }
                }
            }

            // 3. Check dev workspace local fallback
            for ext in extensions {
                let p = (fallbackDir as NSString).appendingPathComponent("\(candidate).\(ext)")
                if FileManager.default.fileExists(atPath: p) {
                    lock.lock()
                    pathCache[cleanName] = p
                    lock.unlock()
                    return p
                }
            }
        }

        return nil
    }

    /// High-performance target-size downsampling thumbnail loader (WWDC best-practice)
    /// Decodes only the thumbnail directly from disk without loading full 12MP bitmap into memory.
    public func image(named name: String, targetSize: CGSize? = nil) -> PlatformImage? {
        let cleanName = (name as NSString).deletingPathExtension
        let cacheKey: NSString
        if let sz = targetSize {
            cacheKey = "\(cleanName)_\(Int(sz.width))x\(Int(sz.height))" as NSString
        } else {
            cacheKey = cleanName as NSString
        }

        if let cached = cache.object(forKey: cacheKey) {
            return cached
        }

        guard let path = resolvePath(for: cleanName) else {
            return nil
        }

        let fileURL = URL(fileURLWithPath: path)

        if let sz = targetSize {
            let maxPixel = max(sz.width, sz.height) * 2.0 // 2x retina
            let options: [CFString: Any] = [
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceShouldCacheImmediately: true,
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceThumbnailMaxPixelSize: maxPixel
            ]

            guard let source = CGImageSourceCreateWithURL(fileURL as CFURL, nil),
                  let cgThumb = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
                return nil
            }

            #if canImport(UIKit)
            let image = UIImage(cgImage: cgThumb)
            #elseif canImport(AppKit)
            let image = NSImage(cgImage: cgThumb, size: sz)
            #endif

            let cost = Int(sz.width * sz.height * 4)
            cache.setObject(image, forKey: cacheKey, cost: cost)
            return image
        } else {
            // Full image decode
            #if canImport(UIKit)
            guard let image = UIImage(contentsOfFile: path) else { return nil }
            let cost = Int(image.size.width * image.size.height * 4)
            #elseif canImport(AppKit)
            guard let image = NSImage(contentsOfFile: path) else { return nil }
            let cost = Int(image.size.width * image.size.height * 4)
            #endif

            cache.setObject(image, forKey: cacheKey, cost: cost)
            return image
        }
    }
}
