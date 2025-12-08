import Network
import Combine

/// Lightweight network observer for online/offline detection
public final class NetworkMonitor: ObservableObject {
    
    public static let shared = NetworkMonitor()
    
    @Published public private(set) var isConnected: Bool = true
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "OfflineSyncKit.Network")
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: queue)
    }
}
