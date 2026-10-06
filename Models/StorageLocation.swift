//
//  StorageLocation.swift
//  FreshTrack
//
//  Created by 是她 on 5/10/2026.
//



import Foundation

struct StorageLocation: Identifiable, Equatable, Hashable {
    
    let id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    //MARK: Default Locations
    static let fridge = StorageLocation(name: "Fridge")
    static let freezer = StorageLocation(name: "Freezer")
    static let pantry = StorageLocation(name: "Pantry")
    
    static let defaultlocations: [StorageLocation] = [fridge,freezer,pantry]
}
