//
//  AddFoodViewModel.swift
//  FreshTrack
//
//  Created by 是她 on 6/10/2026.
//

import Foundation
import Combine

@MainActor
final class AddFoodViewModel: ObservableObject{
    
    //MARK: Form Feild
    
    @Published var foodName = ""
    @Published var quantity = 1
    @Published var purchaseDate = Date()
    @Published var expiryDate = Date()
    
    @Published var selectedStorageLocation: StorageLocation?
    
    //MARK: UI
    
    @Published var errorMessage: String?
    @Published var showingError = false
    @Published var didSaveFood = false
    
    private let addFoodItemUseCase: AddFoodItemUseCase
    
    init(addFoodItemUseCase : AddFoodItemUseCase){
        self.addFoodItemUseCase = addFoodItemUseCase
    }
    
    //MARK: Save Food
    func saveFood(){
        
        guard let storageLocation = selectedStorageLocation else {
            errorMessage = "Please select where the food is stored"
            showingError = true
            return
        }
        
        let foodItem = FoodItem(
            name: foodName,
            quantity: quantity,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: storageLocation
        )
        do {
            try addFoodItemUseCase.execute(foodItem)
            
            didSaveFood = true
            resetForm()
        }
        
        catch{
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "FreshTrack could not save this food item"
            
            showingError = true
        }
    }
    
    //MARK: Rest Form
    
    private func resetForm(){
        foodName = ""
        quantity = 1
        purchaseDate = Date()
        expiryDate = Date()
        selectedStorageLocation = nil
    }
}
