//
//  FoodListViewModel.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//


import Foundation
import Combine

@MainActor
final class FoodListViewModel: ObservableObject{
    @Published var foodItems: [FoodItem] = []
    
    @Published var errorMessage: String?
    @Published var showingError = false
    @Published var isLoading = false
    
    private let viewFoodInventoryUseCase: ViewFoodInventoryUseCase
    
    init(viewFoodInventoryUseCase: ViewFoodInventoryUseCase){
        self.viewFoodInventoryUseCase = viewFoodInventoryUseCase
    }
    
    func loadFoodItems(){
        
        isLoading = true
        errorMessage = nil
        showingError = false
        
        defer{
            isLoading = false
        }
        do{
            foodItems = try viewFoodInventoryUseCase.execute()
        }
        catch{
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "FreshTrack could not load your food"
            
            showingError = true
        }
    }
}
