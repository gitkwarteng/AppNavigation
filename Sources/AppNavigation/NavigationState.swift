//
//  File.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI


import SwiftUI

public struct Absent {}

public struct Present<T> {
    public let value: T
    public init(_ value: T) { self.value = value }
}

public struct NavigationState<Value: Hashable, NamespaceState, ConfigState>: Hashable {
    public let value: Value
    public let namespace: NamespaceState
    public let config: ConfigState

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        if let ns = namespace as? Present<Namespace.ID> {
            hasher.combine(ns.value)
        }
    }

    public static func == (
        lhs: NavigationState<Value, NamespaceState, ConfigState>,
        rhs: NavigationState<Value, NamespaceState, ConfigState>
    ) -> Bool {
        lhs.value == rhs.value &&
        String(reflecting: lhs.namespace) == String(reflecting: rhs.namespace)
    }
}

extension NavigationState {
    /// Just value
    public static func value(_ value: Value) -> NavigationState<Value, Absent, Absent> {
        .init(value: value, namespace: Absent(), config: Absent())
    }

    /// Value + namespace
    public static func namespace(
        _ value: Value,
        namespace: Namespace.ID
    ) -> NavigationState<Value, Present<Namespace.ID>, Absent> {
        .init(value: value, namespace: Present(namespace), config: Absent())
    }

    /// Value + config
    public static func config<Config: ViewConfig>(
        _ value: Value,
        config: Binding<Config>
    ) -> NavigationState<Value, Absent, Present<Binding<Config>>> {
        .init(value: value, namespace: Absent(), config: Present(config))
    }

    /// Value + namespace + config
    public static func full<Config: ViewConfig>(
        _ value: Value,
        namespace: Namespace.ID,
        config: Binding<Config>
    ) -> NavigationState<Value, Present<Namespace.ID>, Present<Binding<Config>>> {
        .init(value: value, namespace: Present(namespace), config: Present(config))
    }
}
