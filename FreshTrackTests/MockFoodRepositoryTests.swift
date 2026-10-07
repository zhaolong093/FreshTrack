//
//  MockFoodRepositoryTest.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//

import Foundation
import Testing
@testable import FreshTrack

struct MockFoodRepositoryTests {

    private let fridge = StorageLocation(name: "Fridge")

    private func date( daysFromToday days: Int) -> Date {

        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return calendar.date(
            byAdding: .day,
            value: days,
            to: today
        )!
    }

    @Test
    func repositoryMarksMatchingFoodAsConsumed()
    throws {

        let repository = MockFoodRepository()

        let food = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate:
                date(daysFromToday: 0),
            expiryDate:
                date(daysFromToday: 2),
            storageLocation: fridge
        )

        repository.foodItems = [ food]

        try repository.markFoodAsConsumed(id: food.id)

        #expect(repository.foodItems.first? .isConsumed == true)

        #expect(repository.lastMarkedConsumedID == food.id)
    }

    @Test
    func repositoryFiltersExpiringFoodCorrectly()
    throws {

        let repository = MockFoodRepository()

        repository.foodItems = [

            FoodItem(
                name: "Milk",
                quantity: 1,
                purchaseDate:
                    date(daysFromToday: 0),
                expiryDate:
                    date(daysFromToday: 1),
                storageLocation: fridge
            ),

            FoodItem(
                name: "Rice",
                quantity: 1,
                purchaseDate:
                    date(daysFromToday: 0),
                expiryDate:
                    date(daysFromToday: 20),
                storageLocation:
                    StorageLocation(
                        name: "Pantry"
                    )
            )
        ]

        let result = try repository.fetchExpiringFood(withinDays: 3)

        #expect(result.count == 1)

        #expect( result.first?.name == "Milk")

        #expect(repository.fetchExpiringFoodCalled)

        #expect( repository.lastRequestedExpiryDays == 3)
    }
}
