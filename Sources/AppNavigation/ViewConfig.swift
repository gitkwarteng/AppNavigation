//
//  ViewConfig.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import Foundation


public protocol ViewConfig: Hashable {
    
    var id: String { get }
    
    mutating func update<T>(property: WritableKeyPath<Self, T>, to value: T)
    
}


extension ViewConfig {
    
    // Generic method to update property using key path
    mutating func update<T>(property: WritableKeyPath<Self, T>, to value: T) {
        self[keyPath: property] = value
    }
}

extension ViewConfig {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var id: String {
        UUID().uuidString
    }
    
}
