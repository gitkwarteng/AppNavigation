//
//  NavigationResult.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI


import SwiftUI



public protocol NavigationRouteDataProtocol {
    
    associatedtype Value
    
    associatedtype Config

    var value: Value? { get }

    var config: Binding<Config>? { get }

    var namespace: Namespace.ID? { get }
}




public struct NavigationData<Value: Hashable, Config: ViewConfig>: NavigationRouteDataProtocol {
    
    public init(
        value: Value?,
        namespace: Namespace.ID? = nil,
        config: Binding<Config>? = nil
    ) {
        self.value = value
        self.namespace = namespace
        self.config = config
    }
    
    public static func == (lhs: NavigationData<Value, Config>, rhs: NavigationData<Value, Config>) -> Bool {
        lhs.value == rhs.value && lhs.namespace == rhs.namespace
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(namespace)
    }
    
    public let value: Value?
    public var namespace: Namespace.ID?
    public var config: Binding<Config>?
}



// Type-erased wrapper
public struct AnyNavigationData: Hashable {
    public let value: AnyHashable?
    public var namespace: Namespace.ID?
    public var config: Any?  // Type-erased config binding
    
    private let _hashInto: (inout Hasher) -> Void
//    private let _equals: (Any) -> Bool
    
    public init<Value: Hashable, Config: ViewConfig>(_ data: NavigationData<Value, Config>) {
        self.value = data.value.map(AnyHashable.init)
        self.namespace = data.namespace
        self.config = data.config
        
        // Store hash implementation
        self._hashInto = { hasher in
            hasher.combine(data.value)
            hasher.combine(data.namespace)
        }
        
        // Store equality implementation
//        self._equals = { other in
//            guard let otherData = other as? AnyNavigationData else { return false }
//            return value == otherData.value && namespace == otherData.namespace
//        }
    }
    
    private func _equal(other: AnyNavigationData) -> Bool {
        guard let otherData = other as? AnyNavigationData else { return false }
        return value == otherData.value && namespace == otherData.namespace
    }
    
    // Convenience initializer for creating from values directly
    public init<Value: Hashable, Config: ViewConfig>(
        value: Value?,
        namespace: Namespace.ID? = nil,
        config: Binding<Config>? = nil
    ) {
        let data = NavigationData<Value, Config>(
            value: value,
            namespace: namespace,
            config: config
        )
        self.init(data)
    }
    
    public func hash(into hasher: inout Hasher) {
        _hashInto(&hasher)
    }
    
    public static func == (lhs: AnyNavigationData, rhs: AnyNavigationData) -> Bool {
        lhs.value == rhs.value && lhs.namespace == rhs.namespace
    }
    
    // Helper method to extract typed data (optional)
    public func extract<Value: Hashable, Config: ViewConfig>() -> NavigationData<Value, Config>? {
        guard let value = value?.base as? Value else { return nil }
        return NavigationData<Value, Config>(
            value: value,
            namespace: namespace,
            config: config as? Binding<Config>
        )
    }
}


