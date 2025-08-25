//
//  EnvironmentKeys.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI


struct NavigationFunctionEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: (AnyNavigationRoute) -> Void = { _ in }
}

extension EnvironmentValues {
    public var navigateTo: (AnyNavigationRoute) -> Void {
        get { self[NavigationFunctionEnvironmentKey.self] }
        set { self[NavigationFunctionEnvironmentKey.self] = newValue }
    }
}


struct GoBackEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: () -> Void = {  }
}

extension EnvironmentValues {
    public var goBack: () -> Void {
        get { self[GoBackEnvironmentKey.self] }
        set { self[GoBackEnvironmentKey.self] = newValue }
    }
}


struct RouterEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: NavigationRouter? = nil
}

extension EnvironmentValues {
    public var router: NavigationRouter? {
        get { self[RouterEnvironmentKey.self] }
        set { self[RouterEnvironmentKey.self] = newValue }
    }
}
