//
//  FoodRepository.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//

import Foundation

protocol FoodRepository{
    
    func addFoodItem(_ fooditem: FoodItem) throws
    
    func fetchAllFoodItems() throws -> [FoodItem]
    
    func fetchExpiringFood( withinDays days: Int) throws -> [FoodItem]
    
    func markFoodAsConsumed(id:UUID) throws
}
