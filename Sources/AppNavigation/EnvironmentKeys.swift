//
//  File.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI


struct NavigationFunctionEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: (AnyNavigationRoute) -> Void = { _ in }
}

extension EnvironmentValues {
    var navigateTo: (AnyNavigationRoute) -> Void {
        get { self[NavigationFunctionEnvironmentKey.self] }
        set { self[NavigationFunctionEnvironmentKey.self] = newValue }
    }
}


struct GoBackEnvironmentKey: EnvironmentKey {
    nonisolated(unsafe) static let defaultValue: () -> Void = {  }
}

extension EnvironmentValues {
    var goBack: () -> Void {
        get { self[GoBackEnvironmentKey.self] }
        set { self[GoBackEnvironmentKey.self] = newValue }
    }
}
