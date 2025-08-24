//
//  NavigationRoutingTests.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//
import SwiftUI
import Testing
@testable import AppNavigation


@Suite("Navigation routing tests")
@MainActor
struct Test {
    
    var routing = NavigationRouting()
    
    var router = NavigationRouter<TestNavigationRoute, AnyView>(name: "testing")

    @Test("Initial routing is empty")
    func testInitialRoutersIsEmpty() async throws {
        #expect(routing.routers.isEmpty)
    }
    
    @Test("Initial router is empty")
    func testInitialRouterRoutersIsEmpty() async throws {
        #expect(router.routes.isEmpty)
    }
    
    @Test("Test registering router on routing works")
    func testRegisteringRouterToRoutingWork() async throws {
        try routing.register(router)
        #expect(!routing.routers.isEmpty)
        #expect(routing.routers.count == 1)
    }
    
    @Test("Test registering existing router raises error")
    func testRegisteringExistingRouterToRoutingThrows() async throws {
        try routing.register(router)
        #expect(throws: AppNavigationError.routerExists(router.name)) {
            try routing.register(router)
        }
    }
    

    @Test("Adding all routes to router works.")
    func testAddingRoutesToRouter() async throws {
        router.addAll(from: TestNavigationRoute.self)
        #expect(!router.routes.isEmpty)
        try routing.register(router)
        #expect(!routing.routers.isEmpty)
    }

    @Test("Adding routes to router with builder pattern works.")
    func testAddingRoutesToRouterByBuilderPattern() async throws {
        let router = router
            .add(TestNavigationRoute.settings)
            .add(TestNavigationRoute.profile)
        
        #expect(!router.routes.isEmpty)
        #expect(router.routes.count == 2)
        try routing.register(router)
        #expect(!routing.allRoutes().isEmpty)
        #expect(routing.allRoutes().count == 2)
    }
    
    
    @Test("Getting destination for route works.")
    func testGettingDestinationForRouteWorks() async throws {
        router.addAll(from: TestNavigationRoute.self)
        try routing.register(router)
        let destination = routing.destination(for: AnyNavigationRoute(TestNavigationRoute.profile, domain: router.name))
        #expect(destination != nil)
    }


}
