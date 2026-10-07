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
    private let viewFoodInventoryUseCase: ViewFoodInventoryUseCase
    private let markFoodAsConsumedUseCase: MarkFoodAsConsumedUseCase
    private let findExpiringFoodUseCase: FindExpiringFoodUseCase

    
    init() {
        let persistenceController = PersistenceController.shared
        let repository = CoreDataFoodRepository(context: persistenceController.container.viewContext)
        
        repository.syncWidgetData()
        
        self.persistenceController = persistenceController
        self.addFoodItemUseCase = AddFoodItemUseCase(repository: repository)
        self.viewFoodInventoryUseCase = ViewFoodInventoryUseCase(repository: repository)
        self.markFoodAsConsumedUseCase = MarkFoodAsConsumedUseCase(repository:repository)
        self.findExpiringFoodUseCase = FindExpiringFoodUseCase(repository: repository)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(addFoodItemUseCase: addFoodItemUseCase,
                        viewFoodInventoryUseCase:viewFoodInventoryUseCase,
                        markFoodAsConsumedUseCase:markFoodAsConsumedUseCase,
                        findExpiringFoodUseCase: findExpiringFoodUseCase
            )
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            
                .task{
                    await ExpiryNotificationManager.shared.requestPermission()
                }
        }
    }
}
