import Foundation
import Combine

/// The main engine that:
/// - Loads cached data instantly
/// - Polls API every X seconds
/// - Updates automatically when server data changes
/// - Stores updates offline
@MainActor
public final class OfflineEngine<T: OfflineCacheable>: ObservableObject {

    @Published public var value: T?

    private var lastSnapshot: T?
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>()

    public init() {}

    /// Starts automatic syncing
    /// - id: unique ID for caching
    /// - interval: polling frequency in seconds
    /// - fetchRemote: developer's own API call returning T
    public func startAutoSync(
        id: String,
        interval: TimeInterval = 10,
        fetchRemote: @escaping () async throws -> T
    ) {
        // Load cached data instantly
        if let cached = OfflineStore.shared.load(id: id, as: T.self) {
            self.value = cached
            self.lastSnapshot = cached
        }

        // Immediate first fetch
        Task { await sync(fetchRemote) }

        // Start polling timer
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { await self.sync(fetchRemote) }
        }
    }

    /// Performs one API → compare → update → save cycle
    private func sync(_ fetchRemote: @escaping () async throws -> T) async {
        guard NetworkMonitor.shared.isConnected else { return }

        do {
            let newVal = try await fetchRemote()

            if newVal != lastSnapshot {
                print("🔄 New backend data detected")
                self.value = newVal
                self.lastSnapshot = newVal
                OfflineStore.shared.save(newVal)
            } else {
                print("ℹ️ No changes on server")
            }

        } catch {
            print("❌ Sync failed:", error)
        }
    }
}
