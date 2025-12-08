Here’s a complete `README.md` you can drop into the repo `Excelsior-Technologies-Community-IOS_OfflineLoadKit` 👇

You can tweak wording later if you want to add screenshots, badges, etc.

---

````markdown
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

## ✨ Features

- ✅ Generic: works with **any Codable model**
- ✅ Offline-first: last successful value is cached locally
- ✅ Auto-sync: periodically calls your API in the background
- ✅ Change detection: UI updates only when backend data changes
- ✅ Network-aware: only syncs when internet is available
- ✅ Very simple to integrate in SwiftUI

You only need to:

1. Create a model that conforms to `OfflineCacheable`
2. Write your own API function that returns that model
3. Plug it into `OfflineEngine`

---

## 📦 Requirements

- iOS 15.0+
- Xcode 15+
- Swift Package Manager

---

## 🔧 Installation (Swift Package Manager)

### 1. Using Xcode UI

1. Open your Xcode project.
2. Go to **File → Add Packages…**
3. In the search bar, paste:

   ```text
   https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_OfflineLoadKit
````

4. Choose **Dependency Rule**:

   * `Up to Next Major Version` (recommended) – e.g. from `1.0.0`
5. Add the product **OfflineSyncKit** to your app target.

---

### 2. Using `Package.swift` (SPM manifest)

If you use a SwiftPM-based app / framework, add this to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/Excelsior-Technologies-Community/Excelsior-Technologies-Community-IOS_OfflineLoadKit",
        from: "1.0.0"
    )
]
```

Then in your target:

```swift
.target(
    name: "YourApp",
    dependencies: [
        .product(name: "OfflineSyncKit", package: "Excelsior-Technologies-Community-IOS_OfflineLoadKit")
    ]
)
```

---

## 🚀 Quick Start (Step-by-Step)

This section is for a **new iOS developer** who wants to use this in their own project.

### Step 1: Import the framework

In your Swift file (e.g. a SwiftUI view or ViewModel):

```swift
import OfflineSyncKit
import SwiftUI
```

---

### Step 2: Create your own model

Your model must:

* Conform to `Codable`
* Conform to `Equatable`
* Conform to `OfflineCacheable`
* Provide a `cacheIdentifier` (a unique key as `String` – e.g. an id)

Example:

```swift
struct JobModel: OfflineCacheable {
    let id: String
    let title: String
    let description: String
    let location: String

    // Unique cache key for this job.
    // This is used as the storage key for offline caching.
    var cacheIdentifier: String { id }
}
```

You can design this model structure however you like, as long as it matches your API response.

---

### Step 3: Write your own API call

You decide **how to call your backend**.

Example (simple GET):

```swift
func fetchJobFromAPI() async throws -> JobModel {
    let url = URL(string: "https://your-api.com/api/v1/jobs/48")!
    let (data, response) = try await URLSession.shared.data(from: url)

    guard let http = response as? HTTPURLResponse,
          (200..<300).contains(http.statusCode) else {
        throw URLError(.badServerResponse)
    }

    // Decode your own JobModel
    return try JSONDecoder().decode(JobModel.self, from: data)
}
```

You can add headers, auth tokens, POST, etc. as needed.

---

### Step 4: Use `OfflineEngine` in a SwiftUI view

Now you connect everything together.

```swift
struct JobScreen: View {

    @StateObject private var engine = OfflineEngine<JobModel>()

    var body: some View {
        VStack(spacing: 8) {
            if let job = engine.value {
                Text(job.title)
                    .font(.title.bold())

                Text(job.description)
                    .font(.body)

                Text("Location: \(job.location)")
                    .font(.subheadline)
            } else {
                Text("Loading job…")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .onAppear {
            engine.startAutoSync(
                id: "job_48",                 // cache key; must be same every time
                interval: 10                  // auto-refresh every 10 seconds
            ) {
                try await fetchJobFromAPI()   // 👈 your async API function
            }
        }
    }
}
```

### What this does:

* On first launch:

  * It **tries to load cached data** for `id: "job_48"` from local storage.
  * If found → UI displays immediately (instant offline mode).
* Then it calls your `fetchJobFromAPI()` once.
* Every `interval` seconds (e.g. 10s), it:

  * Calls your API again
  * Checks if the new response is different from the last one
  * If changed → updates `engine.value` → your UI updates automatically
  * Also saves the latest value to offline storage

---

## 🔍 How It Works Internally (Short Version)

OfflineSyncKit mainly consists of:

### 1. `OfflineCacheable`

A protocol that your model must conform to:

```swift
public protocol OfflineCacheable: Codable, Equatable {
    var cacheIdentifier: String { get }
}
```

This lets the engine:

* Encode/decode your model to JSON
* Compare old vs new values
* Use `cacheIdentifier` as the storage key

---

### 2. `OfflineStore`

A simple storage layer that encodes your model as JSON and stores it (currently using `UserDefaults` for simplicity):

```swift
OfflineStore.shared.save(yourModel)
OfflineStore.shared.load(id: "some_id", as: YourModel.self)
```

---

### 3. `OfflineEngine<T>`

The core engine:

* Generic over any `OfflineCacheable` model
* Observed with `@StateObject` in SwiftUI
* Exposes:

```swift
@Published public var value: T?
```

So your UI can react to changes automatically.

You start it with:

```swift
engine.startAutoSync(
    id: "your_cache_key",
    interval: 10,
    fetchRemote: { try await yourAPIFunction() }
)
```

---

### 4. `NetworkMonitor`

Used internally to know if the device is online/offline.
The engine only syncs when `isConnected == true`.

You can also use it directly if you want:

```swift
@StateObject var network = NetworkMonitor.shared

Text(network.isConnected ? "Online" : "Offline")
```
 

## 💬 Support / Questions

If you face any issues using this package in your project:

* Open a **GitHub Issue** on the repo, or
* Contact the maintainer via GitHub profile

Happy coding & offline syncing 🚀

```

::contentReference[oaicite:0]{index=0}
```
