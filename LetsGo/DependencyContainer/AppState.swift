//
//  AppState.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/12/22.
//

import Combine

/// Redux-like centralized AppState as the single source of truth
struct AppState: Equatable {
    var isLoggedIn: Bool { !userData.token.isEmpty }
    var userData = UserData()
}

// MARK: - User Data
extension AppState {
    /// Source of truth for application data related to the current user
    struct UserData: Equatable {
        var token: String = ""
        var phoneNumber: String = ""
        var userName: String = ""
    }
}
