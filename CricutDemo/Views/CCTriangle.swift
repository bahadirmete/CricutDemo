//
//  CCTriangle.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import SwiftUI

struct CCTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var trianglePath = Path()
        trianglePath.move(to: CGPoint(x: rect.midX, y: rect.minY))
        trianglePath.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        trianglePath.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        trianglePath.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return trianglePath
    }
}

#Preview {
    CCTriangle()
}
