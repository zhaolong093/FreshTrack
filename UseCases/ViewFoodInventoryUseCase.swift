//
//  ViewFoodInventoryUseCase.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//


import Foundation

struct ViewFoodInventoryUseCase{
    
    private let repository: FoodRepository
    
    init(repository: FoodRepository) {
        self.repository = repository
    }
    
    enum ViewFoodInventoryError: LocalizedError, Equatable{
        
        case unableToLoad
        
        var errorDescription: String? {
            switch self{
            case.unableToLoad:
                return "FreshTrack could not load your food inventory"
            }
        }
    }
    
    func execute() throws -> [FoodItem]{
        do {
            let foodItems = try repository.fetchAllFoodItems()
            
            //Rule:
            //My food only shows food that has not been consumed.
            
            return foodItems
                .filter{!$0.isConsumed}
                .sorted{ $0.expiryDate < $1.expiryDate}
        }
        catch{
            throw ViewFoodInventoryError.unableToLoad
        }
    }
}
