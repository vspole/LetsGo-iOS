//
//  ContentView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        NavigationStack {
            if viewModel.isUserLoggedIn {
                TabBarView(viewModel: .init(container: viewModel.container))
            } else {
                PhoneLoginView(viewModel: .init(container: viewModel.container, mainViewModel: viewModel))
            }
        }
        .onAppear {
            viewModel.viewDidAppear(self)
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
        
        func viewDidAppear(_ view: MainView) {
            isUserLoggedIn = container.appState.value.isLoggedIn
        }
    }
}
