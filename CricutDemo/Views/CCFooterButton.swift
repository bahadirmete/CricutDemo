//
//  CCFooterButton.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import SwiftUI

struct CCFooterButton: View {
    let buttons: [ButtonData]
    var onItemAdded: (String, String) -> Void
    var body: some View {
        HStack {
            ForEach(Array(buttons.enumerated()), id: \.element.name) { index, button in
                if index > 0 {
                    Spacer()
                }
                
                CCButton(title: button.name) {
                    print("\(button.name) tapped, path: \(button.draw_path)")
                    onItemAdded(button.name, button.draw_path)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 20)
        
    }
}
