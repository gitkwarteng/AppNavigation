//
//  File.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI



public protocol NavigationRoute: Hashable {
    associatedtype Destination: View
    var id: String { get }
    var destination: Destination { get }
}


// Type-erased navigation route
struct AnyNavigationRoute: NavigationRoute {
    
    
    private let _id: String
    private let _hashValue: Int
    // private let _isEqual: (AnyNavigationRoute) -> Bool
    private let _underlying: Any
    
    private let _destination: () -> any View
    
    private let _domain: String?
    
    init<D: NavigationRoute>(_ route: D, domain: String) {
        self._id = route.id
        self._hashValue = route.hashValue
        self._underlying = route
        self._destination = { route.destination }
        self._domain = domain
        
//        self._isEqual = { other in
//            guard let otherRoute = other._underlying as? D else { return false }
//            return route.id == otherRoute.id && self.domain == other.domain
//        }
        
    }
    
    private func _isEqual(_ other: AnyNavigationRoute) -> Bool {
        guard let otherRoute = other._underlying as? any NavigationRoute else { return false }
        return self.id == otherRoute.id && self.domain == other.domain
    }
    
    var id: String { _id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_hashValue)
    }
    
    static func == (lhs: AnyNavigationRoute, rhs: AnyNavigationRoute) -> Bool {
        return lhs._isEqual(rhs)
    }
    
    var destination: some View {
        AnyView(_destination())
    }
    
    var domain:String { _domain ?? "" }
}

struct NavigationRouteKey: Hashable {
    var name:String
    var domain:String?
    
    typealias Value = String
    
    var Key:Value {
        if let domain = self.domain {
            return "\(domain).\(name)"
        }
        return name
    }
    
    
    
}


final class NavigationRouter<RouteType: NavigationRoute, Destination: View> {
    let name: String

    internal var routes: [NavigationRouteKey.Value:AnyNavigationRoute] = [:]

    init(name: String) {
        self.name = name
    }
    
    private func getKey(_ name:String, forDomain domain: String? = nil) -> NavigationRouteKey {
        return NavigationRouteKey(name: name, domain: domain)
    }

    func add<D: NavigationRoute>(_ route: D) -> Self {
        let key = getKey(route.id, forDomain: self.name)
        routes[key.Key] = AnyNavigationRoute(route, domain: self.name)
        return self
    }
    
    func addAll(from _: RouteType.Type) where RouteType: CaseIterable {
        for route in RouteType.allCases {
            let _ = self.add(route)
        }
    }
    

    func destination(for route: some NavigationRoute) -> Destination? {
        let key = getKey(route.id, forDomain: self.name)
        guard let registeredRoute = self.routes[key.Key] else {
            return nil
        }
        return registeredRoute.destination as? Destination
    }
    

    func get(_ key: NavigationRouteKey) -> AnyNavigationRoute? {
        return routes[key.Key]
    }
    
    func get(_ id: String, forDomain:String?) -> AnyNavigationRoute? {
        return routes[getKey(id, forDomain: forDomain).Key]
    }
}

class AnyNavigationRouter {
    var name: String { fatalError("Subclass must override") }
    
    func routes() -> [AnyNavigationRoute] { fatalError("Subclass must override") }
    
    func destination(for route: AnyNavigationRoute) -> AnyView? { fatalError("Subclass must override") }
}



final class NavigationRouterContainer<RouteType: NavigationRoute>: AnyNavigationRouter {
    
    let router: NavigationRouter<RouteType, AnyView>
    
    override var name: String { router.name }
    
    override func routes() -> [AnyNavigationRoute] { router.routes.values.map { $0 }}
    
    override func destination(for route: AnyNavigationRoute) -> AnyView? {
        router.destination(for: route)
    }
    
    
    init(_ router: NavigationRouter<RouteType, AnyView>) { self.router = router }
}



final class NavigationRouting {
    
    internal var routers: [String: AnyNavigationRouter] = [:]
    
    func register<RouteType: NavigationRoute>(_ router: NavigationRouter<RouteType, AnyView>) throws {
        guard routers[router.name] == nil else {
            throw AppNavigationError.routerExists(router.name)
        }
        routers[router.name] = NavigationRouterContainer(router)
    }
    
    func allRoutes() -> [AnyNavigationRoute] {
        routers.values.flatMap { $0.routes() }
    }
    
    func destination(for route: AnyNavigationRoute) -> AnyView? {
        guard let router = routers[route.domain] else { return nil }
        return router.destination(for: route)
    }
}

