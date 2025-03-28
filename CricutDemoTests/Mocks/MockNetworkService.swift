//
//  MockNetworkService.swift
//  CricutDemo
//
//  Created by BB Mete on 3/28/25.
//

import XCTest
@testable import CricutDemo

class MockNetwork: CCNetworkProtocol {
    var shouldReturnError = false
    var buttons: [ButtonData] = []
    
    func request<T>(from endpoint: any CricutDemo.CCEndpoint) async throws -> T where T : Decodable {
        if shouldReturnError {
            throw CCNetworkError.invalidResponse
        }
        let response = APIResponse(buttons: buttons)
        return response as! T
    }
}

class MockShapeStore: CCShapeStoreProtocol {
    var shapes: [ShapeItem] = []
    
    func getShapes() async -> [ShapeItem] {
        return shapes
    }
    
    func addShape(_ shape: ShapeItem) async {
        shapes.append(shape)
    }
    
    func deleteAll() async {
        shapes.removeAll()
    }
    
    func deleteAllShapes(ofType type: String) async {
        shapes.removeAll { $0.type == type }
    }
    
    func deleteItem(ofType type: String) async {
        if let index = shapes.firstIndex(where: { $0.type == type }) {
            shapes.remove(at: index)
        }
    }
}
