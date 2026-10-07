//
//  CoreDataFoodRepository.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import Foundation
import CoreData
import WidgetKit

final class CoreDataFoodRepository: FoodRepository{
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: Add FoodItems
    func addFoodItem(_ fooditem: FoodItem) throws {
        
        do{
            let entity = FoodItemEntity(context: context)
            
            entity.id = fooditem.id
            entity.name = fooditem.name
            entity.quantity = Int16(fooditem.quantity)
            entity.purchaseDate = fooditem.purchaseDate
            entity.expiryDate = fooditem.expiryDate
            entity.isConsumed = fooditem.isConsumed
            
            entity.storageLocation = try storageLocationEntity(
                for: fooditem.storageLocation
            )
            
            try context.save()
            
            //update Widget
            syncWidgetData()
        }
        catch {
            context.rollback()
            throw error
        }
    }
    
    func fetchAllFoodItems() throws -> [FoodItem] {
        let request = FoodItemEntity.fetchRequest()
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "expiryDate", ascending: true)
        ]
        
        let entities = try context.fetch(request)
        
        return entities.compactMap {
            makeFoodItem(from : $0)
        }
    }
    
    //MARK: Fetch Expiring Food
    
    func fetchExpiringFood(withinDays days: Int) throws -> [FoodItem] {
        let request = FoodItemEntity.fetchRequest()
        
        let calender = Calendar.current
        let startDate = calender.startOfDay(for: Date())
        
        guard let endDate = Calendar.current.date(byAdding: .day, value: days + 1, to: startDate)
                else{
            return []
        }
        request.predicate = NSPredicate(
            format: "isConsumed == NO AND expiryDate >= %@ AND expiryDate < %@",
            startDate as NSDate,
            endDate as NSDate
        )
        
        request.sortDescriptors = [
            NSSortDescriptor(key: "expiryDate", ascending: true)
        ]
        
        let entities = try context.fetch(request)
        return entities.compactMap{
            makeFoodItem(from : $0)
        }
    }
    
    //MARK: Mark Food Consumed
    
    func markFoodAsConsumed(id: UUID) throws {
        let request = FoodItemEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", id as NSUUID)
        
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else {
            throw FoodError.foodNotFound
        }
        entity.isConsumed = true
        do {
            try context.save()
            
            // Update Widget
            syncWidgetData()
        }
        catch {
            context.rollback()
            throw error
        }
    }
    
    // MARK: Storage Location
    
    private func storageLocationEntity(for location: StorageLocation) throws -> StorageLocationEntity{
        let request = StorageLocationEntity.fetchRequest()
        
        let cleanName = location.name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        request.predicate = NSPredicate(format: "name ==[c] %@", location.name)
        
        request.fetchLimit = 1
        
        if let existingLocation = try context.fetch(request).first{
            return existingLocation
        }
        
        let newLocation = StorageLocationEntity(context : context)
        
        newLocation.id = UUID()
        newLocation.name = cleanName
        
        return newLocation
    }
    
    private func makeFoodItem(from entity: FoodItemEntity) -> FoodItem? {
        guard
            let id = entity.id,
            let name = entity.name,
            let purchaseDate = entity.purchaseDate,
            let expiryDate = entity.expiryDate,
            let locationEntity = entity.storageLocation,
            let locationID = locationEntity.id,
            let locationName = locationEntity.name
        else {
            return nil
        }
        
        let location = StorageLocation(id: locationID, name: locationName)
        
        return FoodItem(
            id: id,
            name: name,
            quantity: Int(entity.quantity),
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            isConsumed: entity.isConsumed,
            storageLocation: location
        )
    }
    
    // MARK: Widget Sync

    func syncWidgetData() {
        do {
            let expiringFood = try fetchExpiringFood(withinDays: 3)

            let widgetItems = expiringFood.map {
                    WidgetFoodItem(
                        id: $0.id,
                        name: $0.name,
                        expiryDate: $0.expiryDate,
                        storageLocation:$0
                                .storageLocation
                                .name)
                }

            WidgetDataStore.save(widgetItems)

            WidgetCenter.shared.reloadTimelines(ofKind:"FreshTrackWidget")

        } catch {

            print("Failed to update FreshTrack widget: \(error)")
        }
    }
}
