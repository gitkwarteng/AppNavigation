//
//  NavigationRoute.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI



public protocol NavigationRoute: Hashable {
    associatedtype Destination: View
    
    var id: String { get }
    
    @ViewBuilder func destination(from:Namespace.ID)-> Destination
    
}

public extension NavigationRoute {
    public var hashValue: Int { id.hashValue }
    public static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
}


// Type-erased navigation route
public struct AnyNavigationRoute: NavigationRoute {
    
    
    private let _id: String
    private let _hashValue: Int
    // private let _isEqual: (AnyNavigationRoute) -> Bool
    private let _underlying: Any
    
    private let _destination: (Namespace.ID) -> any View
    
    public init<D: NavigationRoute>(_ route: D, domain: String) {
        self._id = route.id
        self._hashValue = route.hashValue
        self._underlying = route
        self._destination = { route.destination(from:$0) }
        
    }
    
    public init<D: NavigationRoute>(_ route: D) {
        self._id = route.id
        self._hashValue = route.hashValue
        self._underlying = route
        self._destination = { route.destination(from:$0) }
        
    }
    
    private func _isEqual(_ other: AnyNavigationRoute) -> Bool {
        guard let otherRoute = other._underlying as? any NavigationRoute else { return false }
        return self.id == otherRoute.id
    }
    
    public var id: String { _id }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue)
    }
    
    public static func == (lhs: AnyNavigationRoute, rhs: AnyNavigationRoute) -> Bool {
        return lhs._isEqual(rhs)
    }
    
    public func destination(from:Namespace.ID) -> some View {
        AnyView(_destination(from))
    }
    
}
