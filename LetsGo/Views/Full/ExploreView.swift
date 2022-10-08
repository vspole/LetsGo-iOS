//
//  ExploreView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            searchBar
            tabSelectView
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


extension ExploreView {

    var tabSelectView: some View {
        HStack {
            ForEach(TabItems.allCases, id: \.rawValue) { tabItem in
                tabItemView(tab: tabItem)
                    .onTapGesture {
                        viewModel.searchText = ""
                        viewModel.selectedTabItem = tabItem
                        viewModel.fetchBusinesses()
                        viewModel.isEditing = false
                        UIApplication.shared.endEditing()
                     }
            }
        }
        .padding(.horizontal, MARGIN_SCREEN_LEFT_RIGHT)
    }
    
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
                    viewModel.selectedTabItem = nil
                }
                .onSubmit {
                    viewModel.isEditing = false
                    viewModel.fetchBusinesses()
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
                ForEach(viewModel.businesses) { business in
                    BusinessListView(configuration: viewModel.createBusinessListConfiguration(business))
                }
            }
        }
        //.padding(.horizontal, 10)
    }

    func tabItemView(tab: TabItems) -> some View {
       return ZStack {
           RoundedRectangle(cornerRadius: 10).fill(Color.accentColor)
               .frame(height: 30)
           Text(tab.rawValue)
               .scaledFont(type: viewModel.selectedTabItem == tab ? .quickSandSemiBold : .quickSandLight, size: 17, color: .white)
        }
    }
}

extension ExploreView {
    class ViewModel: ObservableObject {
        @Published var searchText = ""
        @Published var isEditing = false
        @Published var isLoading = false
        @Published var screenWidth = 0.0
        @Published var businesses = [BusinessModel]()
        @Published var favoriteBusinesses = [BusinessModel]()
        @Published var selectedTabItem: TabItems? = TabItems.attractions

        var dependencyContainer: DependencyContainer

        var latitude: String {
            "\(dependencyContainer.locationService.latitude)"
        }

        var longitude: String {
            "\(dependencyContainer.locationService.longitude)"
        }

        init(container: DependencyContainer) {
            self.dependencyContainer = container
        }

        func viewDidAppear(_ view: ExploreView) {
            fetchBusinesses()
            fetchFavoriteBusinesses()
            dependencyContainer.locationService.start()
        }

        func viewDidDisappear(_ view: ExploreView) {
            dependencyContainer.locationService.stop()
            saveFavoriteBusinesses()
        }

        func fetchBusinesses() {
            if !dependencyContainer.locationService.permissionStatus {
                //Alert View Controller need location
                return
            }

            isLoading = true
            var searchTerm: String?
            if searchText.isEmpty {
                searchTerm = selectedTabItem?.rawValue
            } else {
                searchTerm = searchText
            }
            dependencyContainer.yelpNetworkingService.fetchBusinesses(type: searchTerm ?? "", latitude: latitude, longitude: longitude) { [weak self] (response) in
                switch response.result {
                case .success(let value):
                    self?.businesses = value.businesses
                case .failure(let error):
                    //Error handling here
                    print("Error: ", error)
                }
                self?.isLoading = false
            }
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

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

enum TabItems: String, CaseIterable {
    case bars = "Bars"
    case restaurants = "Restaurants"
    case attractions = "Attractions"
}
