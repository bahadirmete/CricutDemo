//
//  CricutDemoApp.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import SwiftUI

@main
struct CricutDemoApp: App {
    var body: some Scene {
        WindowGroup {
            CCMainPage(viewModel: CCShapeViewModel())
        }
    }
}
