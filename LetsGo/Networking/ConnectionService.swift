//
//  ConnectionService.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/30/22.
//

import Foundation

protocol ConnectionServiceProtocol {
    func setup() async -> MainView.Views
}

class ConnectionService: DependencyContainer.Component, ConnectionServiceProtocol {
    func setup() async -> MainView.Views {
        do {
            await refreshTokenIfNeeded()
            let config = try await fetchConfig()
            if isForceUpgradeRequired(config: config) {
                return .upgradeView
            } else if isUserLoggedIn() {
                return .tabBarView
            }
        } catch {
            // TODO: Error View Here
            return .errorView
        }
        return .errorView
    }

    private func isUserLoggedIn() -> Bool {
        return entity.firebaseAuthService.isUserSignedIn()
    }

    private func refreshTokenIfNeeded() async {
        guard entity.appState.value.isLoggedIn else { return }
        await withCheckedContinuation { continuation in
            entity.firebaseAuthService.getUserIDToken { [weak self] userToken in
                guard let token = userToken else {
                    // TODO: Error Handling
                    return
                }
                self?.entity.appState[\.userData.token] = token
                continuation.resume()
            }

        }
    }

    private func fetchConfig() async throws -> ConfigReturnModel {
        let result = await withCheckedContinuation { continuation in
            entity.configNetworkingService.fetchConfig { response in
                continuation.resume(returning: response)
            }
        }
        switch result.result {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }

    private func isForceUpgradeRequired(config: ConfigReturnModel) -> Bool {
        guard let appVersion = entity.versionProvider.shortAppVersion else {
            return true
        }
        return appVersion.compare(config.minSupportedVersion, options: .numeric) == .orderedAscending
    }
}
