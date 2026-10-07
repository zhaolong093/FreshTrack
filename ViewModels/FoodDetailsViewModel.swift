//
//  FoodDetailsViewModel.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//


import Foundation
import Combine

@MainActor
final class FoodDetailsViewModel: ObservableObject{
    
    @Published var foodItem: FoodItem
    
    @Published var errorMessage: String?
    @Published var showingError = false
    @Published var didMarkAsConsumed = false
    
    private let markFoodAsConsumedUseCase: MarkFoodAsConsumedUseCase
    
    init(foodItem: FoodItem,
         markFoodAsConsumedUseCase: MarkFoodAsConsumedUseCase) {
        self.foodItem = foodItem
        self.markFoodAsConsumedUseCase = markFoodAsConsumedUseCase
    }
    
    func markAsConsumed(){
        errorMessage = nil
        showingError = false
        
        do {
            try markFoodAsConsumedUseCase.execute(foodId: foodItem.id)
            
            ExpiryNotificationManager
                .shared
                .cancelExpiryNotification(for: foodItem.id)
            foodItem.isConsumed = true
            didMarkAsConsumed = true
        }
        catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "FreshTrack could not update this food item."
            
            showingError = true
        }
    }
}
