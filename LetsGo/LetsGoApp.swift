//
//  LetsGoApp.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/2/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct LetsGoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var container = DependencyContainer.create()
    var body: some Scene {
        WindowGroup {
            ExploreView(viewModel: .init(container: container))
                .preferredColorScheme(.light)
        }
    }
}
