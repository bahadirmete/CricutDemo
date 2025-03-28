//
//  CCShapeDataStore.swift
//  CricutDemo
//
//  Created by BB Mete on 3/28/25.
//
import Foundation

protocol CCShapeStoreProtocol: AnyObject {
    func getShapes() async -> [ShapeItem]
    func addShape(_ shape: ShapeItem) async
    func deleteAll() async
    func deleteAllShapes(ofType type: String) async
    func deleteItem(ofType type: String) async
}

// To avoid race condition problems, I used an actor for a thread-safe approach.
// I could have used other methods like NSLock, a concurrent queue with a barrier, etc.
actor CCShapeDataStore: CCShapeStoreProtocol {
    private(set) var shapes: [ShapeItem] = []
    
    func addShape(_ shape: ShapeItem) {
        shapes.append(shape)
    }
    
    func getShapes() -> [ShapeItem] {
        return shapes
    }
    
    func deleteAll() {
        shapes.removeAll()
    }
    
    func deleteItem(ofType type: String) {
        if let index = shapes.lastIndex(where: { $0.type == type }) {
            shapes.remove(at: index)
        }
    }
    
    func deleteAllShapes(ofType type: String) {
        shapes.removeAll { $0.type == type }
    }
}
