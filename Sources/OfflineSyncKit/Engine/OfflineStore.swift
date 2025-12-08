import Foundation

/// A simple and universal storage engine for any Codable model
/// Developers DO NOT need Core Data — caching works instantly
public final class OfflineStore {

    public static let shared = OfflineStore()
    private init() {}

    /// Saves any `OfflineCacheable` type as encoded JSON
    public func save<T: OfflineCacheable>(_ object: T) {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(object) {
            UserDefaults.standard.set(data, forKey: object.cacheIdentifier)
        }
    }

    /// Loads cached JSON and decodes into specified model
    public func load<T: OfflineCacheable>(id: String, as type: T.Type) -> T? {
        guard let data = UserDefaults.standard.data(forKey: id) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
