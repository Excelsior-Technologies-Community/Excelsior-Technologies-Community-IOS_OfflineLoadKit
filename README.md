# OfflineSyncKit

A **generic offline-first sync engine** for iOS (Swift / SwiftUI).

It lets any developer:

- Use **their own API** (any URL, any format)
- Use **their own data model**
- Get **automatic caching** of the last successful response
- Get **automatic refreshing** when the backend changes
- Work **offline-first** – the UI still shows the last known data when internet is off

Repo:  
https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_OfflineLoadKit

---

##  Features

-   Generic: works with **any Codable model**
-   Offline-first: last successful value is kept locally
-   Auto-sync: periodically calls your API in the background
-   Change detection: UI updates only when backend data changes
-   Network-aware: only syncs when internet is available
-   Extremely simple SwiftUI integration

You only need to:

1. Create a model that conforms to `OfflineCacheable`
2. Write your own API function that returns that model
3. Plug it into `OfflineEngine`

---

##  Requirements

- iOS 15.0+
- Xcode 15+
- Swift Package Manager

---

##  Installation (Swift Package Manager)

### 1. Using Xcode UI

1. Open your Xcode project.
2. Go to **File → Add Packages…**
3. In the search bar, paste:

   ```text
   https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_OfflineLoadKit
   ```

4. Choose **Up to Next Major Version** (recommended).
5. Add the product **OfflineSyncKit** to your app target.

---

### 2. Using `Package.swift` (SPM)

```swift
dependencies: [
    .package(
        url: "https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_OfflineLoadKit",
        from: "1.0.0"
    )
]
```

And inside your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "OfflineSyncKit", package: "Excelsior-Technologies-Community-IOS_OfflineLoadKit")
    ]
)
```

---

##   Quick Start (Step-by-Step)

This guide helps new developers integrate OfflineSyncKit into any SwiftUI project.

---

## Step 1: Import

```swift
import OfflineSyncKit
import SwiftUI
```

---

## Step 2: Create your own model

Your model must:

- Conform to `Codable`
- Conform to `Equatable`
- Conform to `OfflineCacheable`
- Provide a unique `cacheIdentifier`

Example:

```swift
struct JobModel: OfflineCacheable {
    let id: String
    let title: String
    let description: String
    let location: String

    var cacheIdentifier: String { id }
}
```

---

## Step 3: Write your own API call

```swift
func fetchJobFromAPI() async throws -> JobModel {
    let url = URL(string: "https://your-api.com/api/v1/jobs/48")!
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let http = response as? HTTPURLResponse,
          (200..<300).contains(http.statusCode) else {
        throw URLError(.badServerResponse)
    }

    return try JSONDecoder().decode(JobModel.self, from: data)
}
```

---

## Step 4: Bind it to a SwiftUI screen

```swift
struct JobScreen: View {

    @StateObject private var engine = OfflineEngine<JobModel>()

    var body: some View {
        VStack(spacing: 8) {

            if let job = engine.value {
                Text(job.title).font(.title.bold())
                Text(job.description).font(.body)
                Text("Location: \(job.location)").font(.subheadline)
            } else {
                Text("Loading job…").foregroundColor(.gray)
            }

        }
        .padding()
        .onAppear {
            engine.startAutoSync(
                id: "job_48",
                interval: 10
            ) {
                try await fetchJobFromAPI()
            }
        }
    }
}
```

### What happens in this screen:

- First, it loads the last known stored value if available.
- It then performs an immediate API request.
- It auto-refreshes every `interval` seconds.
- The engine updates the UI only when data actually changes.

---

## 🔍 Internal Components (High-Level)

### **1. OfflineCacheable**
Every offline-sync-capable model must define:

```swift
public protocol OfflineCacheable: Codable, Equatable {
    var cacheIdentifier: String { get }
}
```

This identifier uniquely represents one cached dataset.

---

### **2. OfflineEngine<T>**
The core engine:

- Generic over any `OfflineCacheable` model.
- Observed in SwiftUI with `@StateObject`.
- Automatically manages:

  - Loading last known value  
  - Scheduling periodic sync  
  - Detecting when data changes  
  - Updating published value  

You start it using:

```swift
engine.startAutoSync(
    id: "unique_key",
    interval: 10,
    fetchRemote: { try await yourAPIFunction() }
)
```

---

### **3. NetworkMonitor**
Lets the engine sync only when the device is online.

You can also observe it directly:

```swift
@StateObject var network = NetworkMonitor.shared

Text(network.isConnected ? "Online" : "Offline")
```

---

##  Support

If you need help integrating this into your app:

- Open an Issue on GitHub  
- Or contact maintainers

Happy coding & seamless offline syncing  

