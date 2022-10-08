//
//  FavoritesView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/7/22.
//


import SwiftUI

struct FavoritesView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                Spacer()
                ProgressView()
            } else {
                businessList
            }
            Spacer()
        }
        .onAppear {
            viewModel.viewDidAppear(self)
        }
        .onDisappear {
            viewModel.viewDidDisappear(self)
        }
    }
}


extension FavoritesView {
    
    var businessList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.favoriteBusinesses) { business in
                    BusinessListView(configuration: viewModel.createBusinessListConfiguration(business))
                }
            }
        }
    }
}

extension FavoritesView {
    class ViewModel: ObservableObject {
        @Published var isLoading = false
        @Published var favoriteBusinesses = [BusinessModel]()

        var dependencyContainer: DependencyContainer


        init(container: DependencyContainer) {
            self.dependencyContainer = container
        }

        func viewDidAppear(_ view: FavoritesView) {
            fetchFavoriteBusinesses()
        }

        func viewDidDisappear(_ view: FavoritesView) {
            saveFavoriteBusinesses()
        }
        
        func createBusinessListConfiguration(_ business: BusinessModel) -> BusinessListView.Configuration {
            return BusinessListView.Configuration(business: business, isFavorited: isBusinessFavorited(business), categories: business.categories, favoriteButtoncompletion: favoriteButtonCompletion)
        }
        
        private func favoriteButtonCompletion(_ business: BusinessModel) {
            if isBusinessFavorited(business), let index = favoriteBusinesses.firstIndex(of: business) {
                favoriteBusinesses.remove(at: index)
            } else {
                favoriteBusinesses.append(business)
            }
            saveFavoriteBusinesses()
        }
        
        private func isBusinessFavorited(_ business: BusinessModel) -> Bool {
            return favoriteBusinesses.contains(business)
        }
        
        private func fetchFavoriteBusinesses() {
            guard let favorites: [BusinessModel] = try? dependencyContainer.localStorageManager.insecurelyRetrieve(withKey: KEY_USER_FAVORITE_BUSINESSES) else {
                return
            }
            favoriteBusinesses = favorites
        }
        
        private func saveFavoriteBusinesses() {
            try? dependencyContainer.localStorageManager.insecurelyStore(encodable: favoriteBusinesses, forKey: KEY_USER_FAVORITE_BUSINESSES)
        }
    }
}
