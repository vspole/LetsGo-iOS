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
            switch viewModel.activeView {
            case .loginView:
                PhoneLoginView(viewModel: .init(container: viewModel.container, mainViewModel: viewModel))
            default:
                TabBarView(viewModel: .init(container: viewModel.container))
            }
        }
        .onAppear {
            viewModel.viewDidAppear(self)
        }
    }
}

extension MainView {
    class ViewModel: ObservableObject {
        @Published var activeView: Views = .loginView

        var container: DependencyContainer
        
        init(container: DependencyContainer) {
            self.container = container
        }
        
        func viewDidAppear(_ view: MainView) {
            if container.firebaseAuthService.isUserSignedIn() {
                activeView = .tabBarView
            }
        }
    }
}

extension MainView {
    enum Views {
        case loginView
        case tabBarView
        case upgradeView
    }
}
