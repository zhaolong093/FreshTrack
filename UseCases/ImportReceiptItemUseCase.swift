//
//  ImportReceiptItemUseCase.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//


import Foundation

struct ImportReceiptItemUseCase {
    
    private let repository: FoodRepository
    
    init(repository: FoodRepository) {
        self.repository = repository
    }
    
    enum ImportReceiptItemError: LocalizedError, Equatable {
        
        case noItems
        case invalidItem
        case unableToImport
        
        var errorDescription: String?{
            switch self {
            case .noItems:
                return "No food items were found on the receipt."
            case .invalidItem:
                return "One or more receipt items need to be reviewed before they can be added"
            case .unableToImport:
                return "FreshTrack could not import the receipt items. Please try again!"
            }
        }
    }
    
    func execute (_ foodItems: [FoodItem]) throws {
        guard !foodItems.isEmpty else {
            throw ImportReceiptItemError.noItems
        }
        
        let addFoodUseCase = AddFoodItemUseCase(repository: repository)
        
        for foodItem in foodItems{
            do {
                try addFoodUseCase.execute(foodItem)
            }
            
            catch let error as AddFoodItemUseCase.AddFoodItemError{
                switch error {
                    case .emptyName,
                     .invalidQuantity,
                     .invalidExpiryDate,
                     .missingStorageLocation:
                        throw ImportReceiptItemError.invalidItem
                        
                case .unableToSave:
                    throw ImportReceiptItemError.unableToImport
                }
            }
            catch {
                throw ImportReceiptItemError.unableToImport
            }
        }
    }
}
