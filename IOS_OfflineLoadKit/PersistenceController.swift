//
//  PersistenceController.swift
//  IOS_OfflineLoadKit
//
//  Created by Noman belim on 26/12/25.
//

import Foundation
import CoreData

struct PersistenceController {

    static let shared = PersistenceController()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "IOS_OfflineLoadKit")

        if inMemory {
            container.persistentStoreDescriptions.first?.url =
                URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Core Data load failed: \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
