import Foundation

#if !SWIFT_PACKAGE
extension Bundle {
    static var module: Bundle { Bundle.main }
}
#endif

public final class CaseContentLoader: @unchecked Sendable {
    public static let shared = CaseContentLoader()

    private var cachedCases: [String: CaseModel] = [:]
    private let lock = NSRecursiveLock()

    public init() {}

    /// Loads all bundled cases from the module resources or filesystem
    public func loadAllBundledCases() -> [CaseModel] {
        lock.lock()
        defer { lock.unlock() }

        if !cachedCases.isEmpty {
            return Array(cachedCases.values).sorted { $0.caseId < $1.caseId }
        }

        let bundle = Bundle.module
        var urls: [URL] = []

        if let caseURLs = bundle.urls(forResourcesWithExtension: "json", subdirectory: "Cases") {
            urls.append(contentsOf: caseURLs)
        }
        if let rootURLs = bundle.urls(forResourcesWithExtension: "json", subdirectory: nil) {
            urls.append(contentsOf: rootURLs.filter { $0.pathExtension == "json" })
        }

        // Fallback for direct source inspection
        let currentDir = FileManager.default.currentDirectoryPath
        let directDir = URL(fileURLWithPath: currentDir).appendingPathComponent("Sources/Caseboard/Resources/Cases")
        if let directFiles = try? FileManager.default.contentsOfDirectory(at: directDir, includingPropertiesForKeys: nil) {
            for f in directFiles where f.pathExtension == "json" {
                if !urls.contains(where: { $0.lastPathComponent == f.lastPathComponent }) {
                    urls.append(f)
                }
            }
        }

        let decoder = JSONDecoder()
        for url in urls {
            guard let data = try? Data(contentsOf: url),
                  let caseModel = try? decoder.decode(CaseModel.self, from: data) else {
                continue
            }
            cachedCases[caseModel.caseId] = caseModel
        }

        return Array(cachedCases.values).sorted { $0.caseId < $1.caseId }
    }

    /// Retrieves a specific case by its ID
    public func loadCase(withId caseId: String) -> CaseModel? {
        lock.lock()
        defer { lock.unlock() }

        if let cached = cachedCases[caseId] {
            return cached
        }

        // Check if it is a daily case
        if caseId.hasPrefix("daily_") {
            let dateStr = String(caseId.dropFirst("daily_".count))
            let generated = DailyCaseGenerator().generateDailyCase(forDateString: dateStr)
            cachedCases[caseId] = generated
            return generated
        }

        // Otherwise load all and search
        let all = loadAllBundledCases()
        return all.first { $0.caseId == caseId }
    }
}
