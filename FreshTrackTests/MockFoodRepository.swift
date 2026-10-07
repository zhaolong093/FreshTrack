//
//  MockFoodRepository.swift
//  FreshTrack
//
//  Created by 是她 on 6/10/2026.
//


import Foundation
@testable import FreshTrack

final class MockFoodRepository: FoodRepository {
    var foodItems: [FoodItem] = []

    //Allows us to simulate a database failure
    var shouldThrowError = false

    //MARK: Tracking

    var addFoodItemCalled = false
    var fetchAllFoodItemsCalled = false
    var fetchExpiringFoodCalled = false
    var markFoodAsConsumedCalled = false

    var lastRequestedExpiryDays: Int?
    var lastMarkedConsumedID: UUID?

    //MARK:  Add Food

    func addFoodItem(
        _ foodItem: FoodItem
    ) throws {

        if shouldThrowError {
            throw MockRepositoryError.forcedFailure
        }

        addFoodItemCalled = true
        foodItems.append(foodItem)
    }

    //MARK:  Fetch All Food

    func fetchAllFoodItems() throws -> [FoodItem] {
        if shouldThrowError {
            throw MockRepositoryError.forcedFailure
        }
        fetchAllFoodItemsCalled = true

        
        return foodItems
    }

    //MARK:Fetch Expiring Food
    func fetchExpiringFood(
        withinDays days: Int
    ) throws -> [FoodItem] {

        if shouldThrowError {
            throw MockRepositoryError.forcedFailure
        }

        fetchExpiringFoodCalled = true
        lastRequestedExpiryDays = days

        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: Date())

        guard let endDate = calendar.date(
            byAdding: .day,
            value: days + 1,
            to: startDate
        ) else {
            return []
        }
        return foodItems.filter { foodItem in

            !foodItem.isConsumed &&
            foodItem.expiryDate >= startDate &&
            foodItem.expiryDate < endDate
        }
    }

    //MARK: Mark Food As Consumed

    func markFoodAsConsumed(
        id: UUID
    ) throws {

        if shouldThrowError {
            throw MockRepositoryError.forcedFailure
        }
        markFoodAsConsumedCalled = true
        lastMarkedConsumedID = id

        guard let index = foodItems.firstIndex(
            where: { $0.id == id }
        ) else {
            throw FoodError.foodNotFound
        }

        foodItems[index].isConsumed = true
    }
}

enum MockRepositoryError: Error {
    case forcedFailure
}
