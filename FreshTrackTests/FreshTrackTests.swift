//
//  FreshTrackTests.swift
//  FreshTrackTests
//
//  Created by 是她 on 2/10/2026.
//

import Foundation
import Testing

@testable import FreshTrack

struct FreshTrackTests {

    // MARK:  Helpers
    private let fridge = StorageLocation(name: "Fridge")

    private func date(
        daysFromToday days: Int
    ) -> Date {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())

        return calendar.date(
            byAdding: .day,
            value: days,
            to: today
        )!
    }

    //MARK: AddFoodItemUseCase

    @Test
    func addingValidFoodSavesSuccessfully() throws {
        let repository = MockFoodRepository()
        let useCase = AddFoodItemUseCase(repository: repository)

        let food = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 2
            ),
            storageLocation: fridge
        )
        try useCase.execute(food)
        #expect(
            repository.addFoodItemCalled)

        #expect(repository.foodItems.count == 1)

        #expect(repository.foodItems.first?.name == "Milk")
    }

    @Test
    func addingFoodWithEmptyNameIsRejected() {

        let repository = MockFoodRepository()

        let useCase = AddFoodItemUseCase(repository: repository)

        let food = FoodItem(
            name: "   ",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 1
            ),
            storageLocation: fridge
        )

        #expect(
            throws:
                AddFoodItemUseCase
                    .AddFoodItemError
                    .emptyName
        ) {
            try useCase.execute(food)
        }
    }

    @Test
    func addingFoodWithZeroQuantityIsRejected() {
        let repository = MockFoodRepository()
        let useCase = AddFoodItemUseCase(repository: repository)

        let food = FoodItem(
            name: "Milk",
            quantity: 0,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 1
            ),
            storageLocation: fridge
        )

        #expect(
            throws:
                AddFoodItemUseCase
                    .AddFoodItemError
                    .invalidQuantity
        ) {

            try useCase.execute(food)
        }
    }

    @Test
    func expiryBeforePurchaseDateIsRejected() {

        let repository = MockFoodRepository()

        let useCase = AddFoodItemUseCase(repository: repository)
        let food = FoodItem(
            name: "Chicken",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 2
            ),
            expiryDate: date(
                daysFromToday: 1
            ),
            storageLocation: fridge
        )

        #expect(
            throws:
                AddFoodItemUseCase
                    .AddFoodItemError
                    .invalidExpiryDate
        ) {

            try useCase.execute(food)
        }
    }

    @Test
    func sameCalendarDateIsAllowed() throws {

        let repository = MockFoodRepository()

        let useCase = AddFoodItemUseCase(repository: repository)

        let calendar = Calendar.current

        let today = calendar.startOfDay(
            for: Date()
        )

        let purchaseDate = calendar.date(
            byAdding: .hour,
            value: 20,
            to: today
        )!

        let expiryDate = calendar.date(
            byAdding: .hour,
            value: 8,
            to: today
        )!

        let food = FoodItem(
            name: "Bread",
            quantity: 1,
            purchaseDate: purchaseDate,
            expiryDate: expiryDate,
            storageLocation: fridge
        )

        try useCase.execute(food)

        #expect(repository.foodItems.count == 1)
    }

    @Test
    func databaseFailureWhileAddingFoodShowsSaveError() {

        let repository = MockFoodRepository()

        repository.shouldThrowError = true

        let useCase = AddFoodItemUseCase(repository: repository)
        let food = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 2
            ),
            storageLocation: fridge
        )
        #expect(
            throws:
                AddFoodItemUseCase
                    .AddFoodItemError
                    .unableToSave
        ) {
            try useCase.execute(food)
        }
    }

    //MARK: FindExpiringFoodUseCase

    @Test
    func findingExpiringFoodReturnsOnlyRelevantItems()
    throws {

        let repository = MockFoodRepository()

        repository.foodItems = [

            FoodItem(
                name: "Milk",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: 0
                ),
                expiryDate: date(
                    daysFromToday: 1
                ),
                storageLocation: fridge
            ),

            FoodItem(
                name: "Chicken",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: 0
                ),
                expiryDate: date(
                    daysFromToday: 3
                ),
                storageLocation: fridge
            ),

            FoodItem(
                name: "Rice",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: 0
                ),
                expiryDate: date(
                    daysFromToday: 20
                ),
                storageLocation:
                    StorageLocation(
                        name: "Pantry"
                    )
            ),

            FoodItem(
                name: "Yoghurt",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: 0
                ),
                expiryDate: date(
                    daysFromToday: 1
                ),
                isConsumed: true,
                storageLocation: fridge
            )
        ]
        let useCase =
            FindExpiringFoodUseCase(repository: repository)

        let result = try useCase.execute(withinDays: 3)
        #expect(result.count == 2)

        #expect(
            result.contains {
                $0.name == "Milk"
            }
        )

        
        #expect(
            result.contains {
                $0.name == "Chicken"
            }
        )
        
        

        #expect(
            !result.contains {
                $0.name == "Rice"
            }
        )

        #expect(
            !result.contains {
                $0.name == "Yoghurt"
            }
        )
    }

    @Test
    func zeroDayExpiryPeriodIsRejected() {
        let repository = MockFoodRepository()

        let useCase = FindExpiringFoodUseCase(repository: repository)
        #expect(
            throws:
                FindExpiringFoodUseCase
                    .FindExpiringFoodError
                    .invalidNumberOfDays
        ) {

            try useCase.execute(
                withinDays: 0
            )
        }
    }

    // MARK: MarkFoodAsConsumedUseCase

    @Test
    func markingExistingFoodAsConsumedSucceeds()
    throws {

        let repository = MockFoodRepository()

        let food = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 1
            ),
            storageLocation: fridge
        )

        repository.foodItems = [food]
        let useCase = MarkFoodAsConsumedUseCase(repository: repository)

        try useCase.execute(foodId: food.id)
        #expect(repository.markFoodAsConsumedCalled)
        #expect(repository.foodItems.first?.isConsumed == true
        )
    }

    @Test
    func markingUnknownFoodAsConsumedShowsNotFoundError() {

        let repository = MockFoodRepository()

        let useCase =
            MarkFoodAsConsumedUseCase(
                repository: repository
            )

        #expect(
            throws:
                MarkFoodAsConsumedUseCase
                    .MarkFoodConsumedError
                    .foodNotFound
        ) {
            try useCase.execute(foodId: UUID())
            
            
        }
    }

    // MARK:ViewFoodInventoryUseCase

    @Test
    func inventoryHidesConsumedFoodAndSortsByExpiry()
    throws { let repository = MockFoodRepository()
        repository.foodItems = [

            
            FoodItem(
                name: "Rice",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: 0
                ),
                expiryDate: date(
                    daysFromToday: 20
                ),
                storageLocation:
                    StorageLocation(
                        name: "Pantry"
                    )
            ),

            FoodItem(
                name: "Milk",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: 0
                ),
                expiryDate: date(
                    daysFromToday: 1
                ),
                storageLocation: fridge
            ),

            FoodItem(
                name: "Old Bread",
                quantity: 1,
                purchaseDate: date(
                    daysFromToday: -3
                ),
                expiryDate: date(
                    daysFromToday: 1
                ),
                isConsumed: true,
                storageLocation:
                    StorageLocation(
                        name: "Pantry"
                    )
            )
        ]

        let useCase = ViewFoodInventoryUseCase(repository: repository)

        let result = try useCase.execute()

        #expect(result.count == 2)

        #expect(result[0].name == "Milk")

        #expect(result[1].name == "Rice")

        #expect(!result.contains {$0.name == "Old Bread"}
        )
    }

    // MARK: ImportReceiptItemUseCase

    @Test
    func importingEmptyReceiptIsRejected() {

        let repository = MockFoodRepository()

        let useCase = ImportReceiptItemUseCase( repository: repository)

        #expect(
            throws:
                ImportReceiptItemUseCase
                    .ImportReceiptItemError
                    .noItems
        ) {

            
            try useCase.execute([])
        }
    }

    @Test
    func importingValidReceiptItemsAddsAllFood()
    throws {

        let repository = MockFoodRepository()

        let useCase = ImportReceiptItemUseCase(repository: repository)

        let milk = FoodItem(
            name: "Milk",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 3
            ),
            storageLocation: fridge
        )

        let bread = FoodItem(
            name: "Bread",
            quantity: 1,
            purchaseDate: date(
                daysFromToday: 0
            ),
            expiryDate: date(
                daysFromToday: 4
            ),
            storageLocation:
                StorageLocation(
                    name: "Pantry"
                )
        )

        try useCase.execute([milk, bread])

        #expect(repository.foodItems.count == 2)

        #expect(repository.foodItems.contains {
                $0.name == "Milk"
            })

        #expect(repository.foodItems.contains {
            $0.name == "Bread"
            })
    }
}
