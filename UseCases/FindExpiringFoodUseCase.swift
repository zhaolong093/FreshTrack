//
//  FindExpiringFoodUseCase.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//


import Foundation

struct FindExpiringFoodUseCase {
    
    private let repository: FoodRepository
    
    init(repository: FoodRepository) {
        self.repository = repository
    }
    
    enum FindExpiringFoodError: LocalizedError, Equatable{
        
        case invalidNumberOfDays
        case unableToLoad
        
        var errorDescription: String? {
            switch self {
            case .invalidNumberOfDays:
                return "The expiry period must be at least one day."
            case .unableToLoad:
                return "FreshTrack could not load your expiry food"
            }
        }
    }
    
    func execute(withinDays days: Int = 3) throws -> [FoodItem]{
        guard days > 0 else {
            throw FindExpiringFoodError.invalidNumberOfDays
        }
        
        do{
            return try repository.fetchExpiringFood(withinDays: days)
        }
        catch {
            throw FindExpiringFoodError.unableToLoad
        }
    }
}
