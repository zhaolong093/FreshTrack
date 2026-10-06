//
//  CoreDataFoodRepository.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import Foundation
import CoreData

final class CoreDataFoodRepository: FoodRepository{
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    //MARK: Add FoodItems
    func addFoodItem(_ fooditem: FoodItem) throws {
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
        let today = Date()
        
        guard let endDate = Calendar.current.date(byAdding: .day, value: days, to: today)
                else{
            return []
        }
        request.predicate = NSPredicate(
            format: "isConsumed == NO AND expiryDate >= %@ AND expiryDate <= %@",
            today as NSDate,
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
        try context.save()
    }
    
    // MARK: Storage Location
    
    private func storageLocationEntity(for location: StorageLocation) throws -> StorageLocationEntity{
        let request = StorageLocationEntity.fetchRequest()
        
        request.predicate = NSPredicate(format: "id == %@", location.id as NSUUID)
        
        request.fetchLimit = 1
        
        if let existingLocation = try context.fetch(request).first{
            return existingLocation
        }
        
        let newLocation = StorageLocationEntity(context : context)
        
        newLocation.id = location.id
        newLocation.name = location.name
        
        return newLocation
    }
    
    private func makeFoodItem(from entity: FoodItemEntity) -> FoodItem? {
        guard
            let id = entity.id,
            let name = entity.name,
            let purchaseDate = entity.purchaseDate,
            let expiryDate = entity.expiryDate,
            let locationEntity = entity.storageLocation,
            let locationID = entity.id,
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
}
