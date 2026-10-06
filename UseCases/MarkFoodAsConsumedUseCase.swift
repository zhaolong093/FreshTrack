//
//  MarkFoodAsConsumedUseCase.swift
//  FreshTrack
//
//  Created by 是她 on 6/10/2026.
//


import Foundation
struct MarkFoodAsConsumedUseCase {
    private let repository: FoodRepository
    
    init(repository: FoodRepository) {
        self.repository = repository
    }
    
    enum MarkFoodConsumedError: LocalizedError, Equatable{
        case foodNotFound
        case unableToUpdate
        
        
        var errorDescription: String?{
            switch self {
            case .foodNotFound:
                return "This food item could not be found"
            case .unableToUpdate:
                return "FreshTrack could not update this food item. Please try again!"
            }
        }
    }
    
    func execute(foodId: UUID) throws {
        do {
            try repository.markFoodAsConsumed(id: foodId)
        }
        catch FoodError.foodNotFound {
            throw MarkFoodConsumedError.foodNotFound
        }
        catch {
            throw MarkFoodConsumedError.unableToUpdate
        }
    }
}
