//
//  AddFoodItemUseCase.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import Foundation

struct AddFoodItemUseCase {
    private let repository: FoodRepository
    
    init(repository: FoodRepository) {
        self.repository = repository
    }
    
    enum AddFoodItemError : LocalizedError, Equatable {
        
        case emptyName
        case invalidQuantity
        case invalidExpiryDate
        case missingStorageLocation
        case unableToSave
        
        var errorDescription: String?{
            switch self {
            case .emptyName:
                return "Please enter a food name."
            case .invalidQuantity:
                return "Quantity mush be greater than zero"
            case .invalidExpiryDate:
                return "Expiry date cannot be earlier than the pruchase date."
            case .missingStorageLocation:
                return "Please select where the food is stored"
            case .unableToSave:
                return "FreshTrack could not save this food item. Please try again."
            }
        }
    }
    
    func execute(_ foodItem: FoodItem) throws {
        let trimmedName = foodItem.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedName.isEmpty else {
            throw AddFoodItemError.emptyName
        }
        
        guard foodItem.quantity > 0 else {
            throw AddFoodItemError.invalidQuantity
        }
        
        guard foodItem.expiryDate >= foodItem.purchaseDate else {
            throw AddFoodItemError.invalidQuantity
        }
        
        let locationName = foodItem.storageLocation.name
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !locationName.isEmpty else {
            throw AddFoodItemError.missingStorageLocation
        }
        do {
            try repository.addFoodItem(foodItem)
        }
        catch {
            throw AddFoodItemError.unableToSave
        }
    }
}
