//
//  SplashView.swift
//  LetsGo
//
//  Created by Vishal Polepalli on 10/30/22.
//

import SwiftUI

struct SplashView: View {

    var body: some View {
        ZStack {
            Color.white
            Image("MainLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .ignoresSafeArea()
    }
}
