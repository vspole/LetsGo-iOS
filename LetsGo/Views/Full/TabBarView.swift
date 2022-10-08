//
//  TabBarView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/7/22.
//

import SwiftUI

struct TabBarView: View {
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            ExploreView(viewModel: .init(container: viewModel.container))
                .tabItem {
                    Label(Constants.exploreTab, systemImage: "magnifyingglass")
                }
                .tag(Constants.exploreTab)
            
            Text(Constants.favoriteTab)
                .tabItem {
                    Label(Constants.favoriteTab, systemImage: "heart")
                }
                .tag(Constants.favoriteTab)
        }
    }
}

extension TabBarView {
    class ViewModel: ObservableObject {
        @Published var selectedTab: String = Constants.exploreTab
        
        var container: DependencyContainer
        
        init(container: DependencyContainer) {
            self.container = container
        }
    }
    
    enum Constants {
        static let exploreTab = "Explore"
        static let favoriteTab = "Favorite"
    }
}
