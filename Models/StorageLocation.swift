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
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
