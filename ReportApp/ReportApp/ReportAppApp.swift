//
//  ReportAppApp.swift
//  ReportApp
//
//  Created by 葉家均 on 2022/12/8.
//

import SwiftUI

@main
struct ReportAppApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !UserDefaults.standard.bool(forKey: "isLogin") {
                    ContentView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
