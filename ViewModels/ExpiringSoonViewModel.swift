//
//  ExpiringSoonViewModel.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//

import Foundation
import Combine

@MainActor
final class ExpiringSoonViewModel: ObservableObject{
    @Published var foodItems: [FoodItem] = []
    
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage: String?
    
    private let findExpiringFoodUseCase : FindExpiringFoodUseCase
    
    init( findExpiringFoodUseCase: FindExpiringFoodUseCase){
        self.findExpiringFoodUseCase = findExpiringFoodUseCase
    }
    
    func loadExpiringFood(){
        isLoading = true
        showingError = false
        errorMessage = nil
        
        defer{
            isLoading = false
        }
        
        do {
            foodItems = try findExpiringFoodUseCase.execute(withinDays: 3)
        }
        catch{
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "FreshTrack could not load expiring food."
            
            showingError = true
        }
    }
    
    func daysUntilExpiry( for foodItem: FoodItem) -> Int {
        let calender = Calendar.current
        
        let today = calender.startOfDay(for: Date())
        
        let expiry = calender.startOfDay(for: foodItem.expiryDate)
        
        return calender.dateComponents([.day], from: today, to: expiry).day ?? 0
    }
    
    func expiryMessage( for foodItem: FoodItem) -> String{
        let days = daysUntilExpiry(for: foodItem)
        
        switch days {
        case 0:
            return "Expires today"
            
        case 1:
            return "Expires tomorrow"
        default:
            return "Expires in \(days) days"
        }
        
    }
}
