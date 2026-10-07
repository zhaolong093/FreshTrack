//
//  WidgetDataStore.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//

import Foundation

struct WidgetDataStore {

    static let appGroupIdentifier = "group.au.edu.uts.FreshTrack"

    private static let foodKey = "widgetExpiringFood"

    static func save(_ foodItems: [WidgetFoodItem])
    {
        guard let defaults = UserDefaults(
                suiteName: appGroupIdentifier)
        else {
            return
        }

        do {

            let data = try JSONEncoder().encode(foodItems)
            defaults.set(data,forKey: foodKey)
        } catch {

            print("Failed to save widget data: \(error)")
        }
    }
    static func load() -> [WidgetFoodItem] {

        guard let defaults = UserDefaults( suiteName: appGroupIdentifier),

            let data = defaults.data(forKey: foodKey)
        else {
            return []
        }

        do {

            return try JSONDecoder().decode([WidgetFoodItem].self,from: data)

        } catch {

            print("Failed to load widget data: \(error)")

            return []
        }
    }
}
