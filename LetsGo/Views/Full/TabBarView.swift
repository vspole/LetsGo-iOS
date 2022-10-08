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
        VStack {
            logo
            
            TabView(selection: $viewModel.selectedTab) {
                ExploreView(viewModel: .init(container: viewModel.container))
                    .tabItem {
                        Label(Constants.exploreTab, systemImage: "magnifyingglass")
                    }
                    .tag(Constants.exploreTab)
                
                FavoritesView(viewModel: .init(container: viewModel.container))
                    .tabItem {
                        Label(Constants.favoriteTab, systemImage: "heart")
                    }
                    .tag(Constants.favoriteTab)
            }
        }
    }
}

extension TabBarView {
    var logo: some View {
        Image("MainLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 75)
            .padding(.horizontal, 100)
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
