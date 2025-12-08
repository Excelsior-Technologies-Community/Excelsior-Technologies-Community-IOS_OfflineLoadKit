import Foundation

/// Any user model must conform to this to be eligible for offline caching
public protocol OfflineCacheable: Codable, Equatable {
    /// Unique key used for storing & retrieving cached data
    var cacheIdentifier: String { get }
}
