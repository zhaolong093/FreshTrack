//
//  FreshTrackTests.swift
//  FreshTrackTests
//
//  Created by 是她 on 2/10/2026.
//

import Testing
@testable import FreshTrack
import Foundation

struct FreshTrackTests {
    
    private let fridge = StorageLocation(name: "Fridge")
    
    @Test func addingValidFoodSaveOnce() throws{
        let repository = MockFoodRepository()
        let useCase = AddFoodItemUseCase(repository: repository)
        let food = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate: Date(),
            expiryDate: Calendar.current.date(
                byAdding: .day, value: 2, to: Date())!,
            storageLocation: fridge
            )
        
        try useCase.execute(food)
        #expect(repository.addFoodItemCalled)
        
        #expect(repository.foodItems.count == 1)
        
        #expect(repository.foodItems.first?.name == "Milk")
    }
    @Test func addingFoodwithEmptyNameShowsNameError(){
        let repository = MockFoodRepository()
        
        let useCase = AddFoodItemUseCase(repository: repository)
        
        let food = FoodItem(
            name: " ",
            quantity: 1,
            purchaseDate: Date(),
            expiryDate: Date(),
            storageLocation: fridge
        )
        #expect(throws: AddFoodItemUseCase.AddFoodItemError.emptyName)
        {
            try useCase.execute(food)
        }
    }
    
    @Test func addingFoodWithZeroQtyShowQtyError(){
        let repository = MockFoodRepository()
        
        let useCase = AddFoodItemUseCase(repository: repository)
        
        let food = FoodItem(
            name: "Milk",
            quantity: 0,
            purchaseDate: Date(),
            expiryDate: Date(),
            storageLocation: fridge
        )
        #expect(throws: AddFoodItemUseCase.AddFoodItemError.invalidQuantity)
        {
            try useCase.execute(food)
        }
    }
    
    @Test func expiryBeforePurchaseDateShowExpiryError(){
        let repository = MockFoodRepository()
        
        let useCase = AddFoodItemUseCase(repository: repository)
        let purchaseDate = Date()
        let expiryDate =  Calendar.current.date(byAdding: .day, value: -1 ,to: purchaseDate)!
        
        let food = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: fridge
        )
        #expect(throws: AddFoodItemUseCase.AddFoodItemError.invalidExpiryDate)
        {
            try useCase.execute(food)
        }
    }
    
    @Test func sameCalenderDateIsAllowed() throws {
        let repository = MockFoodRepository()
        
        let useCase = AddFoodItemUseCase(repository: repository)
        let calender = Calendar.current
        
        let startOfToday = calender.startOfDay(for: Date())
        let purchaseDate = calender.date(byAdding: .hour, value: 20, to: startOfToday)!
        
        let expiryDate = calender.date(byAdding: .hour, value: 8, to: startOfToday)!
        
        
        let food = FoodItem(
            name: "Bread",
            quantity: 1,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: fridge
        )
        
        try  useCase.execute(food)
        
        #expect(repository.foodItems.count == 1)
      
    }
}
