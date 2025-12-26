//
//  IOS_OfflineLoadKitApp.swift
//  IOS_OfflineLoadKit
//
//  Created by Noman belim on 26/12/25.
//
import SwiftUI

@main
struct IOS_OfflineLoadKitApp: App {

    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(
                    \.managedObjectContext,
                    persistenceController.container.viewContext
                )
        }
    }
}
