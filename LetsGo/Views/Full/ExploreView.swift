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
            if colorScheme == .dark {
                logoInvert
            } else {
                logo
            }
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

    var logo: some View {
        Image("MainLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 75)
            .padding(.horizontal, 100)
    }

    var logoInvert: some View {
        Image("MainLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 75)
            .padding(.horizontal, 100)
            .colorInvert()
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
                    BusinessListView(configuration: business)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.orange, lineWidth: 2)
                        )
                }
            }
        }
        .padding(.horizontal, 10)
    }

    func tabItemView(tab: TabItems) -> some View {
       return ZStack {
            RoundedRectangle(cornerRadius: 10)
               .stroke(Color.orange, lineWidth: 2)
               .background(RoundedRectangle(cornerRadius: 10).fill(viewModel.selectedTabItem == tab ? .gray : Color(UIColor.systemBackground)))
               .frame(height: 20)
           Text(tab.rawValue)
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
            dependencyContainer.locationService.start()
        }

        func viewDidDisappear(_ view: ExploreView) {
            dependencyContainer.locationService.stop()
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
