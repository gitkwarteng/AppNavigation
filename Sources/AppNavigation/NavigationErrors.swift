//
//  Errors.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

public enum AppNavigationError: Error, Equatable {
    case routerExists(String)
    case routerNotFound(String)
    
    public static func == (lhs: AppNavigationError, rhs: AppNavigationError) -> Bool {
        lhs.id == rhs.id
    }
    
    public var id: String {
        switch self {
        case .routerExists(_):
            return "exists"
        case .routerNotFound(_):
            return "notFound"
        }
    }
    
    public var localizedDescription: String {
        switch self {
        case .routerExists(let domain):
            return "Router for '\(domain)' already exists."
        case .routerNotFound(let domain):
            return "Router for '\(domain)' not found."
        }
    }
    
}
