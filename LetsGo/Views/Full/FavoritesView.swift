//
//  FavoritesView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/7/22.
//


import SwiftUI
import Foundation

struct FavoritesView: View {
    @StateObject var viewModel: ViewModel

    var body: some View {
        VStack {
            searchBar
                .onReceive(viewModel.$searchText) { (searchText) in
                    viewModel.searchBusinesses()
                }
            Spacer()
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
    var searchBar: some View {
        HStack {
            TextField("Search ...", text: $viewModel.searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal, 10)
                .onTapGesture {
                    viewModel.isEditing = true
                }
                .onSubmit {
                    viewModel.isEditing = false
                    viewModel.searchBusinesses()
                }

            if viewModel.isEditing {
                Button(action: {
                    viewModel.searchText = ""
                    viewModel.isEditing = false
                    UIApplication.shared.endEditing()
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default, value: 5)
            }
        }
    }
    
    var businessList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.showFiltered ? viewModel.filteredBusinesses : viewModel.favoriteBusinesses) { business in
                    BusinessListView(configuration: viewModel.createBusinessListConfiguration(business))
                }
            }
        }
    }
}

extension FavoritesView {
    class ViewModel: ObservableObject {
        @Published var searchText = ""
        @Published var isEditing = false
        @Published var isLoading = false
        @Published var favoriteBusinesses = [BusinessModel]()
        @Published var filteredBusinesses = [BusinessModel]()

        var showFiltered: Bool {
            !searchText.isEmpty
        }
        
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
        
        func searchBusinesses() {
            filteredBusinesses = favoriteBusinesses.filter{ $0.name.contains(searchText) || $0.categories[0].title.contains(searchText)}
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
