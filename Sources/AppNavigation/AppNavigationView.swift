//
//  SwiftUIView.swift
//  AppNavigation
//
//  Created by Kwarteng on 24/08/2025.
//

import SwiftUI

struct AppNavigationView<Content: View>: View {
    
    @State private var viewModel: NavigationViewModelProtocol
    
    @Namespace var animation
    
    var routing: NavigationRouting
    
    var content:Content
    
    init(routing:some NavigationRouting,  @ViewBuilder content: () -> Content) {
        self.content = content()
        self.routing = routing
        self._viewModel = State(wrappedValue: NavigationViewModelFactory.create())
        
    }
    
    var body: some View {
        NavigationStack(path:$viewModel.path) {
            
            content
                .navigationDestination(for: AnyNavigationRoute.self) { route in
                    Group {
                        if let destination = routing.destination(for: route){
                            destination
                        } else {
                            EmptyView()
                        }
                    }
                    .environment(\.navigateTo, viewModel.navigateTo)
                    .environment(\.goBack, viewModel.goBack)
                    
                }
                .environment(\.navigateTo, viewModel.navigateTo)
                .environment(\.goBack, viewModel.goBack)
        }
    }
}
