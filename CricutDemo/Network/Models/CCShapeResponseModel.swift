//
//  CCShapeResponseModel.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import Foundation

struct APIResponse: Codable {
    let buttons: [ButtonData]
}

struct ButtonData: Codable {
    let name: String
    let draw_path: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case draw_path
    }
}
