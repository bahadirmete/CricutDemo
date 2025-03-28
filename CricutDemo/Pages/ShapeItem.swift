//
//  ShapeItem.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import Foundation

// I might use an enum for draw_path, but there are only three values.
// I would use an enum if there were more.
struct ShapeItem: Identifiable {
    let id = UUID()
    let type: String
    let draw_path: String
}
