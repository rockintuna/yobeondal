//
//  yobeondalApp.swift
//  yobeondal
//
//  Created by 이정인 on 3/10/25.
//

import SwiftUI

@main
struct yobeondalApp: App {
    @State private var isLoading = true // 로딩 상태
    
    var body: some Scene {
        WindowGroup {
            if isLoading {
                LoadingView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            isLoading = false
                        }
                    }
            } else {
                MonthSelectView()
            }
        }
    }
}
