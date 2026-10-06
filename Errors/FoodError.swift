//
//  FoodError.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import Foundation

enum FoodError: LocalizedError, Equatable{
    case emptyName
    case invalidQuantity
    case expiryBeforePurchaseDate
    case missingStorageLocation
    case foodNotFound
    case noReceiptItemsFound
    
    var errorDescription: String?{
        switch self {
        case .emptyName:
            return "Please enter food name."
        case .invalidQuantity:
            return "Quantity must be greater than zero."
        case .expiryBeforePurchaseDate:
            return "Expiry date cannot be earlier than the pruchase date."
        case .missingStorageLocation:
            return "Please select where the food is stored."
        case .foodNotFound:
            return "The food item could not be found."
        case .noReceiptItemsFound:
            return "No food items were found on the receipt."
        }
    }
}
