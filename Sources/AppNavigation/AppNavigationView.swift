//
//  SwiftUIView.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI

public struct AppNavigationView<Content: View>: View {
    
    @State private var viewModel: NavigationViewModelProtocol
    
    @Namespace var animation
    
    var router: NavigationRouter?
    
    var content:Content
    
    public init(router:NavigationRouter? = nil,  @ViewBuilder content: () -> Content) {
        self.content = content()
        self.router = router
        self._viewModel = State(wrappedValue: NavigationViewModelFactory.create())
        
    }
    
    public var body: some View {
        NavigationStack(path:$viewModel.path) {
            
            content
                .navigationDestination(for: AnyNavigationRoute.self) { route in
                    
                    route.destination(from: animation)
                        .environment(\.navigateTo, viewModel.navigateTo)
                        .environment(\.goBack, viewModel.goBack)
                        .environment(\.router, router)
                    
                }
                .environment(\.navigateTo, viewModel.navigateTo)
                .environment(\.goBack, viewModel.goBack)
                .environment(\.router, router)
        }
    }
}
