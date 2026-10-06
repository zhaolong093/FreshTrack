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
    
    private let persistenceController: PersistenceController
    private let addFoodItemUseCase: AddFoodItemUseCase
    
    init() {
        let persistenceController = PersistenceController.shared
        let repository = CoreDataFoodRepository(context: persistenceController.container.viewContext)
        
        self.persistenceController = persistenceController
        self.addFoodItemUseCase = AddFoodItemUseCase(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(addFoodItemUseCase: addFoodItemUseCase)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
