//
//  ContentView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.isUserLoggedIn {
            ExploreView(viewModel: .init(container: viewModel.container))
        } else {
            PhoneLoginView(viewModel: .init(container: viewModel.container, mainViewModel: viewModel))
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        @Published var isUserLoggedIn = false
        
        var container: DependencyContainer
        
        init(container: DependencyContainer) {
            self.container = container
        }
    }
}
