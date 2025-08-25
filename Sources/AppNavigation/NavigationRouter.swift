//
//  NavigationRouter.swift
//  AppNavigation
//
//  Created by Kwarteng on 25/08/2025.
//

import SwiftUI


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


public final class RouteCollection<RouteType: NavigationRoute, Destination: View> {
    let name: String

    internal var routes: [NavigationRouteKey.Value:AnyNavigationRoute] = [:]

    public init(name: String) {
        self.name = name
    }
    
    private func getKey(_ name:String, forDomain domain: String? = nil) -> NavigationRouteKey {
        return NavigationRouteKey(name: name, domain: domain)
    }

    public func add<D: NavigationRoute>(_ route: D) -> Self {
        let key = getKey(route.id, forDomain: self.name)
        routes[key.Key] = AnyNavigationRoute(route)
        return self
    }
    
    public func add<D: NavigationRoute>(_ routes: D...) -> Self {
        for route in routes {
            let _ = self.add(route)
        }
        return self
    }
    
    public func addAll(from _: RouteType.Type) where RouteType: CaseIterable {
        for route in RouteType.allCases {
            let _ = self.add(route)
        }
    }
    

    func destination(for route: some NavigationRoute, from:Namespace.ID) -> Destination? {
        let key = getKey(route.id, forDomain: self.name)
        guard let registeredRoute = self.routes[key.Key] else {
            return nil
        }
        return registeredRoute.destination(from: from) as? Destination
    }
    

    func get(_ key: NavigationRouteKey) -> AnyNavigationRoute? {
        return routes[key.Key]
    }
    
    func get(_ id: String, forDomain:String?) -> AnyNavigationRoute? {
        return routes[getKey(id, forDomain: forDomain).Key]
    }
}

public class AnyRouteCollection {
    var name: String { fatalError("Subclass must override") }
    
    func routes() -> [AnyNavigationRoute] { fatalError("Subclass must override") }
    
    func destination(for route: AnyNavigationRoute, from: Namespace.ID) -> AnyView? { fatalError("Subclass must override") }
}



final class NavigationRouterContainer<RouteType: NavigationRoute>: AnyRouteCollection {
    
    let router: RouteCollection<RouteType, AnyView>
    
    override var name: String { router.name }
    
    override func routes() -> [AnyNavigationRoute] { router.routes.values.map { $0 }}
    
    override func destination(for route: AnyNavigationRoute, from: Namespace.ID) -> AnyView? {
        router.destination(for: route, from: from)
    }
    
    
    init(_ router: RouteCollection<RouteType, AnyView>) { self.router = router }
}



public final class NavigationRouter {
    
    public init(){}
    
    public init(routers: [AnyRouteCollection]) throws {
        for router in routers {
            let name = router.name
            guard self.routers[name] == nil else {
                throw AppNavigationError.routerExists(name)
            }
            self.routers[name] = router
        }
    }
    
    internal var routers: [String: AnyRouteCollection] = [:]
    
    public func register<RouteType: NavigationRoute>(_ router: RouteCollection<RouteType, AnyView>) throws {
        guard routers[router.name] == nil else {
            throw AppNavigationError.routerExists(router.name)
        }
        routers[router.name] = NavigationRouterContainer(router)
    }
    
    public func register<RouteType: NavigationRoute>(_ routers: RouteCollection<RouteType, AnyView>...) throws {
        for router in routers {
            try self.register(router)
        }
    }
    
    public func allRoutes() -> [AnyNavigationRoute] {
        routers.values.flatMap { $0.routes() }
    }
    
    public func destination(for route: AnyNavigationRoute, from: Namespace.ID) -> AnyView? {
//        guard let router = routers[route.domain] else { return nil }
//        return router.destination(for: route, from: from)
        return AnyView(route.destination(from: from))
    }
}


