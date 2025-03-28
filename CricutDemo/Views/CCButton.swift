//
//  CCTabView.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import SwiftUI

struct CCButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(title) {
            action()
        }
        .font(.system(size: 17))
        .foregroundColor(.blue)
    }
}
