//
//  WidgetFoodItem.swift
//  FreshTrack
//
//  Created by 是她 on 7/10/2026.
//

import Foundation

struct WidgetFoodItem: Codable, Identifiable {

    let id: UUID
    let name: String
    let expiryDate: Date
    let storageLocation: String
}
