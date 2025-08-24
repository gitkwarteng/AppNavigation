//
//  File.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI
import Combine

import SwiftUI
import Combine

protocol NavigationViewModelProtocol {
    var path: NavigationPath { get set }
    
    init()
    
    @MainActor func restoreSession()
    @MainActor func saveSession()
    @MainActor func navigateTo(_ route: AnyNavigationRoute)
    @MainActor func goBack()
}


extension NavigationViewModelProtocol {
    
    mutating func restoreSession() {
        if let data = Self.readSerializedData() {
            do {
                let representation = try JSONDecoder().decode(
                    NavigationPath.CodableRepresentation.self,
                    from: data)
                self.path = NavigationPath(representation)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }
    
    static func readSerializedData() -> Data? {
        // Read data representing the path from app's persistent storage.
        return nil
    }
    
    static func writeSerializedData(_ data: Data) {
        // Write data representing the path to app's persistent storage.
    }
    
    func saveSession() {
        guard let representation = path.codable else { return }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(representation)
            Self.writeSerializedData(data)
        } catch {
            // Handle error.
        }
    }
    
    mutating func navigateTo(_ route: AnyNavigationRoute) {
        path.append(route)
    }
    
    mutating func goBack() {
        if path.isEmpty { return }
        path.removeLast(1)
    }
}


// Protocol for @Observable support (iOS 17+)
@available(iOS 17.0, macOS 14.0, *)
protocol ObservableNavigationViewModelProtocol: NavigationViewModelProtocol, Observable {}


// Protocol for ObservableObject support (iOS 13+)
protocol ObservableObjectNavigationViewModelProtocol: NavigationViewModelProtocol, ObservableObject {}



// For iOS 17+ using @Observable
@available(iOS 17.0, macOS 14.0, *)
@Observable
public class ModernNavigationViewModel: ObservableNavigationViewModelProtocol {
    var path: NavigationPath = NavigationPath()
    
    required init() {
        self.path = NavigationPath()
    }
    
    func restoreSession() {
        if let data = Self.readSerializedData() {
            do {
                let representation = try JSONDecoder().decode(
                    NavigationPath.CodableRepresentation.self,
                    from: data)
                self.path = NavigationPath(representation)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }
    
    static func readSerializedData() -> Data? {
        // Read data representing the path from app's persistent storage.
        return nil
    }
    
    static func writeSerializedData(_ data: Data) {
        // Write data representing the path to app's persistent storage.
    }
    
    func saveSession() {
        guard let representation = path.codable else { return }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(representation)
            Self.writeSerializedData(data)
        } catch {
            // Handle error.
        }
    }
    
    func navigateTo(_ route: AnyNavigationRoute) {
        self.path.append(route)
    }
    
    func goBack() {
        if path.isEmpty { return }
        self.path.removeLast(1)
    }
}

// For iOS 13+ using ObservableObject
public class LegacyNavigationViewModel: ObservableObjectNavigationViewModelProtocol {
    @Published var path: NavigationPath = NavigationPath()
    
    required init() {
        self.path = NavigationPath()
    }
    
    func restoreSession() {
        if let data = Self.readSerializedData() {
            do {
                let representation = try JSONDecoder().decode(
                    NavigationPath.CodableRepresentation.self,
                    from: data)
                self.path = NavigationPath(representation)
            } catch {
                self.path = NavigationPath()
            }
        } else {
            self.path = NavigationPath()
        }
    }
    
    static func readSerializedData() -> Data? {
        // Read data representing the path from app's persistent storage.
        return nil
    }
    
    static func writeSerializedData(_ data: Data) {
        // Write data representing the path to app's persistent storage.
    }
    
    func saveSession() {
        guard let representation = path.codable else { return }
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(representation)
            Self.writeSerializedData(data)
        } catch {
            // Handle error.
        }
    }
    
    @MainActor
    func navigateTo(_ route: AnyNavigationRoute) {
        self.path.append(route)
    }
    
    @MainActor
    func goBack() {
        if path.isEmpty { return }
        self.path.removeLast(1)
    }
}

// MARK: - Type Alias for Convenience

@available(iOS 17.0, macOS 14.0, *)
typealias NavigationViewModel = ModernNavigationViewModel

// Fallback for older versions
@available(iOS, deprecated: 17.0, message: "Use ModernNavigationViewModel on iOS 17+")
typealias NavigationViewModelLegacy = LegacyNavigationViewModel

// MARK: - Factory Pattern (Optional)

struct NavigationViewModelFactory {
    static func create() -> any NavigationViewModelProtocol {
        if #available(iOS 17.0, macOS 14.0, *) {
            return ModernNavigationViewModel()
        } else {
            return LegacyNavigationViewModel()
        }
    }
}


