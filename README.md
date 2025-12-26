# 📦 IOS_OfflineLoadKit

**IOS_OfflineLoadKit** is a **SwiftUI + Core Data offline-first starter project** built for **beginners**.

This project teaches **Core Data from zero**, including:

* Creating a Core Data project
* Adding Core Data to an existing project
* Saving & fetching data
* Working completely **offline**
* Fixing common Core Data crashes
* Adding new entities later
* **Using Core Data relationships (destination & inverse)**

---

## 🎯 What this project does

* User enters:

  * First Name
  * Last Name
  * Age
* Data is saved locally using **Core Data**
* Internet is turned **OFF**
* App still shows saved data ✅

👉 This proves **offline persistence using Core Data**

---

## 🛠 Tech Stack

* Swift
* SwiftUI
* Core Data
* iOS

---

## 🚀 Creating a New Project (Recommended Way)

When creating a new project in Xcode:

1. Open Xcode → **New Project**
2. Select **App**
3. Choose:

| Option    | Value      |
| --------- | ---------- |
| Interface | SwiftUI    |
| Language  | Swift      |
| Storage   | None       |
| CloudKit  | ❌ Disabled |

👉 Core Data is added **manually** to teach how it works.

---

## 🧩 Adding Core Data to an Existing Project

### Step 1: Add Core Data Model

* Right-click project → **New File**
* Choose **Core Data → Data Model**
* Name it exactly:

```
IOS_OfflineLoadKit.xcdatamodeld
```

⚠️ The model name **must match** the Core Data container name.

---

### Step 2: Create First Entity (`Person`)

Open `IOS_OfflineLoadKit.xcdatamodeld`:

* Add Entity → `Person`
* Add attributes:

  * `firstName` → String
  * `lastName` → String
  * `age` → Integer 16

---

### Step 3: Entity ↔ Class Mapping (VERY IMPORTANT)

Select `Person` entity → Inspector:

| Field   | Value                  |
| ------- | ---------------------- |
| Class   | Person                 |
| Module  | Current Product Module |
| Codegen | Manual / None          |

Then:

* **Editor → Create NSManagedObject Subclass**

This generates:

* `Person+CoreDataClass.swift`
* `Person+CoreDataProperties.swift`

---

## 🧱 Core Data Stack (`PersistenceController`)

This project uses a custom Core Data stack:

* Loads Core Data model
* Creates persistent store (SQLite)
* Provides `viewContext`
* Works fully **offline**

⚠️ Container name **must match model name**:

```
NSPersistentContainer(name: "IOS_OfflineLoadKit")
```

---

## 🔗 Connecting Core Data to SwiftUI (MANDATORY)

Core Data **must be injected** into the App lifecycle.

If not:
❌ App crashes
❌ Context is disconnected

This project correctly injects:

* `managedObjectContext`
* Into `ContentView`

---

## 📶 Offline Testing (How to Verify)

1. Run app
2. Enter data
3. Tap **Save**
4. Turn **Airplane Mode ON**
5. Kill app
6. Open again

✅ Data still visible
👉 Core Data works offline by default

---

## ❗ Common Errors & Fixes

### ❌ `No NSEntityDescriptions found`

✔ Model name mismatch
✔ Model not added to target

---

### ❌ `Cannot find Entity in scope`

✔ NSManagedObject subclass not generated

---

### ❌ `Context not connected to persistent store`

✔ Core Data not injected into App file

---

### ❌ App crashes on launch

✔ Duplicate `.xcdatamodeld` files
✔ Clean build required

---

# 🔗 Core Data Relationships (IMPORTANT SECTION)

Relationships allow **entities to connect to each other**
(example: One Person → Many Tasks).

---

## 🧠 Relationship Concepts (Simple)

| Term         | Meaning                         |
| ------------ | ------------------------------- |
| Relationship | Connection between two entities |
| Destination  | Entity you are connecting to    |
| Inverse      | Reverse relationship            |
| To-One       | One object                      |
| To-Many      | Multiple objects                |

---

## 📌 Example: Person → Task Relationship

### Step 1: Create Second Entity

Add Entity → `Task`

Attributes:

* `title` → String
* `createdAt` → Date

---

### Step 2: Add Relationship (Person → Task)

Select **Person** entity:

* Add Relationship:

  * Name: `tasks`
  * Destination: `Task`
  * Type: **To Many**
  * Optional: Yes

---

### Step 3: Add Inverse Relationship (Task → Person)

Select **Task** entity:

* Add Relationship:

  * Name: `person`
  * Destination: `Person`
  * Type: **To One**

Now set:

* `Person.tasks` → Inverse = `person`
* `Task.person` → Inverse = `tasks`

⚠️ **Inverse is mandatory** for Core Data consistency.

---

### Step 4: Generate Classes

* Editor → Create NSManagedObject Subclass
* Select `Task`

---

### Step 5: How Relationship Works (Conceptually)

* One `Person` can have **many Tasks**
* Each `Task` belongs to **one Person**
* Core Data automatically manages links

No extra database code needed.

---

## ➕ Adding a NEW Entity Later (Existing Project)

If developer wants to add a new entity:

1. Open `.xcdatamodeld`
2. Add Entity
3. Add attributes
4. Set:

   * Class name
   * Module
   * Codegen = Manual / None
5. Generate NSManagedObject subclass
6. Clean & Run

✅ Existing data remains safe
✅ Offline support continues working

---

## 🧠 Key Learning Points

* Core Data is **local database**
* Internet is NOT required
* Model name must match container
* Entity ≠ Swift class
* Relationships need **destination + inverse**
* Most Core Data crashes are **setup mistakes**

---

## 🔮 Future Improvements

* Edit & delete records
* Core Data migrations
* API + offline sync
* Background saving
* Conflict resolution

   
