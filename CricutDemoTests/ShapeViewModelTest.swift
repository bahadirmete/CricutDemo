//
//  ShapeViewModelTest.swift
//  CricutDemo
//
//  Created by BB Mete on 3/28/25.
//

import XCTest
@testable import CricutDemo

@MainActor
final class CCShapeViewModelTests: XCTestCase {
    var mockNetwork: MockNetwork!
    var mockShapeStore: MockShapeStore!
    var viewModel: CCShapeViewModel!
    
    override func setUp() async throws {
        mockNetwork = MockNetwork()
        mockShapeStore = MockShapeStore()
        viewModel = CCShapeViewModel(network: mockNetwork, shapeStore: mockShapeStore)
        
    }
    
    override func tearDown() async throws {
        viewModel = nil
        mockNetwork = nil
        mockShapeStore = nil
    }
    
    // MARK: - Buttons
    
    func testFetchButtonsSuccess() async {
        let testButtons = [ButtonData(name: "Add", draw_path: "addCircle")]
        mockNetwork.buttons = testButtons
        
        await viewModel.fetchButtons()
        
        let buttons = await MainActor.run { viewModel.buttons }
        
        XCTAssertEqual(buttons.count, 1)
        XCTAssertEqual(buttons.first?.draw_path, "addCircle")
    }
    
    func testFetchButtonsFailure() async {
        mockNetwork.shouldReturnError = true
        
        await viewModel.fetchButtons()
        
        let buttons = await MainActor.run { viewModel.buttons }
        let error = await MainActor.run { viewModel.error }
        
        XCTAssertEqual(buttons.count, 0)
        XCTAssertEqual(error, CCNetworkError.invalidResponse)
    }
    
    // MARK: - Shapes
    
    func testAddShape() async {
        let shape = ShapeItem(type: "Circle", draw_path: "circle")
        
        viewModel.addShape(shape)
        
        let shapes = await MainActor.run { viewModel.shapes }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(shapes.count, 1)
            XCTAssertEqual(shapes.first?.type, "Circle")
        }
    }
    
    func testDeleteAllShape() async {
        mockShapeStore.shapes = [
            ShapeItem(type: "Circle", draw_path: "circle"),
            ShapeItem(type: "Square", draw_path: "square")
        ]
        
        viewModel.deleteAllShape()
        
        let shapes = await MainActor.run { viewModel.shapes }
        
        XCTAssertTrue(shapes.isEmpty)
    }
    
    func testDeleteAllCircle() async {
        mockShapeStore.shapes = [
            ShapeItem(type: "Circle", draw_path: "circle"),
            ShapeItem(type: "Circle", draw_path: "circle2"),
            ShapeItem(type: "Square", draw_path: "square")
        ]
        
        viewModel.deleteAllCircle()
        
        let shapes = await MainActor.run { viewModel.shapes }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(shapes.count, 1)
            XCTAssertEqual(shapes.first?.type, "Square")
        }
    }
    
    func testDeleteCircle() async {
        mockShapeStore.shapes = [
            ShapeItem(type: "Circle", draw_path: "circle"),
            ShapeItem(type: "Square", draw_path: "square")
        ]
        
        viewModel.deleteCircle()
        
        let shapes = await MainActor.run { viewModel.shapes }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(shapes.count, 1)
            XCTAssertEqual(shapes.first?.type, "Square")
        }
    }
    
    // MARK: - Button Actions
    
    func testHandleAddCircleButton() async {
        let button = ButtonData(name: "Add", draw_path: "addCircle")
        
        viewModel.handleOperation(button)
        
        let shapes = await MainActor.run { viewModel.shapes }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(shapes.count, 1)
            XCTAssertEqual(shapes.first?.type, "Circle")
        }
    }
    
    func testHandleDeleteAllCircleButton() async {
        mockShapeStore.shapes = [
            ShapeItem(type: "Circle", draw_path: "circle"),
            ShapeItem(type: "Square", draw_path: "square")
        ]
        
        let button = ButtonData(name: "Delete All", draw_path: "deleteAllCircle")
        
        viewModel.handleOperation(button)
        
        let shapes = await MainActor.run { viewModel.shapes }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(shapes.count, 1)
            XCTAssertEqual(shapes.first?.type, "Square")
        }
    }
    
    func testHandleRemoveCircleButton() async {
        mockShapeStore.shapes = [
            ShapeItem(type: "Circle", draw_path: "circle"),
            ShapeItem(type: "Circle", draw_path: "circle2"),
            ShapeItem(type: "Square", draw_path: "square")
        ]
        
        let button = ButtonData(name: "Remove", draw_path: "removeCircle")
        
        viewModel.handleOperation(button)
        
        let shapes = await MainActor.run { viewModel.shapes }
        let circleCount = shapes.filter { $0.type == "Circle" }.count
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertEqual(shapes.count, 2)
            XCTAssertEqual(circleCount, 1)
        }
    }
}
