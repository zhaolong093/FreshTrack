//
//  DashboardViewModel.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//


import Foundation
import Combine

@MainActor
final class DashboardViewModel: ObservableObject{
    @Published var expiringFood: [FoodItem] = []
    @Published var allFood: [FoodItem] = []
    
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage: String?
    
    private let findExpiringFoodUseCase: FindExpiringFoodUseCase
    private let viewFoodInventoryUseCase: ViewFoodInventoryUseCase
    
    init(
        findExpiringFoodUseCase: FindExpiringFoodUseCase,
        viewFoodInventoryUseCase: ViewFoodInventoryUseCase
        
    ){
        self.findExpiringFoodUseCase = findExpiringFoodUseCase
        self.viewFoodInventoryUseCase = viewFoodInventoryUseCase
    }
    
    func loadDashbaord(){
        isLoading = true
        showingError = false
        errorMessage = nil
        defer{
            isLoading = false
        }
        
        do {
            allFood = try viewFoodInventoryUseCase.execute()
            
            expiringFood = try findExpiringFoodUseCase.execute(withinDays: 3)
        }
        catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "FreshTrack could not load the dashboard."
            
            showingError = true
        }
    }
    
    var totalFoodCount: Int{allFood.count}
    
    var expiringFoodCount: Int {
        expiringFood.count
    }
    
    var mostUrgentFood: FoodItem? {
        expiringFood.first
    }
    
    func expiryMessage( for foodItem: FoodItem) -> String{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let expiry = calendar.startOfDay(for: foodItem.expiryDate)
        
        let days = calendar.dateComponents([.day], from: today, to: expiry).day ?? 0
        
        switch days{
        case 0:
            return "Expires today."
        case 1:
            return "Expires tomorrow"

        default:
            return "Expires in \(days) days"
            
        }
    }
}
