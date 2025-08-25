//
//  NavigationResult.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI



public protocol NavigationDataValueProtocol {
    
    associatedtype Value

    var value: Value { get }
}


public protocol NavigationDataWithConfigProtocol {
    
    associatedtype Config

    var config: Binding<Config> { get }
}


public protocol NavigationDataWithNamespaceProtocol {

    var namespace: Namespace.ID { get }
}


public struct NavigationDataValue<Value: Hashable>: NavigationDataValueProtocol {
    public let value: Value
    
    public init(value: Value) {
        self.value = value
    }
}


public struct NavigationDataWithConfig<Value: Hashable, Config>: NavigationDataValueProtocol, NavigationDataWithConfigProtocol {
    public let value: Value
    public let config: Binding<Config>
    
    public init(value: Value, config: Binding<Config>) {
        self.value = value
        self.config = config
    }
}


public struct NavigationDataWithNamespace<Value: Hashable>: NavigationDataValueProtocol, NavigationDataWithNamespaceProtocol {
    public let value: Value
    public let namespace: Namespace.ID
    
    public init(value: Value, namespace: Namespace.ID) {
        self.value = value
        self.namespace = namespace
    }
}

public struct NavigationData<Value: Hashable, Config: ViewConfig>: NavigationDataValueProtocol, NavigationDataWithConfigProtocol, NavigationDataWithNamespaceProtocol {
    public let value: Value
    public let config: Binding<Config>
    public let namespace: Namespace.ID
    
    public init(
        _ value: Value,
        config: Binding<Config>,
        namespace: Namespace.ID
    ) {
        self.value = value
        self.config = config
        self.namespace = namespace
    }
}


extension NavigationData {
    
    public static func value(_ value: Value) -> NavigationDataValue<Value> {
        .init(value: value)
    }
    
    public static func config(
        _ value: Value,
        config: Binding<Config>
    ) -> NavigationDataWithConfig<Value, Config> {
        .init(value: value, config: config)
    }
    
    public static func namespace(_ value: Value, namespace: Namespace.ID) -> NavigationDataWithNamespace<Value> {
        .init(value: value, namespace: namespace)
    }

}
