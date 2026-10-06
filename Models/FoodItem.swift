//
//  FoodItem.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import Foundation

struct FoodItem: Identifiable, Equatable {
    
    let id: UUID
    var name: String
    var quantity: Int
    var purchaseDate: Date
    var expiryDate: Date
    var isConsumed: Bool
    var storageLocation: StorageLocation
    
    init(id: UUID = UUID(),
         name: String,
         quantity: Int,
         purchaseDate: Date,
         expiryDate: Date,
         isConsumed: Bool = false,
         storageLocation: StorageLocation)
    {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.purchaseDate = purchaseDate
        self.expiryDate = expiryDate
        self.isConsumed = isConsumed
        self.storageLocation = storageLocation
    }
}
