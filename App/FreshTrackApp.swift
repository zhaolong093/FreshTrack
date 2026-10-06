//
//  FreshTrackApp.swift
//  FreshTrack
//
//  Created by 是她 on 2/10/2026.
//

import SwiftUI
import CoreData


@main
struct FreshTrackApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
