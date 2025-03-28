//
//  ShapeViewModel.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//

import SwiftUI
import Foundation

// I used this viewModel for both pages (first and second).
// I could use @EnvironmentObject to share it everywhere, but since there are only two pages, I think it's not needed.
// If three or more pages needed this viewModel, then I would choose @EnvironmentObject.
@MainActor
class CCShapeViewModel: ObservableObject {
    private let network: CCNetworkProtocol
    private let shapeStore: CCShapeStoreProtocol
    
    @Published private(set) var shapes: [ShapeItem] = []
    @Published private(set) var buttons: [ButtonData] = []
    @Published private(set) var buttonsCirclePage: [ButtonData] = []
    @Published private(set) var error: CCNetworkError?
    
    init(network: CCNetworkProtocol = CCNetworkManager.shared,
         shapeStore: CCShapeStoreProtocol = CCShapeDataStore()) {
        self.network = network
        self.shapeStore = shapeStore
        setStaticButtonForCirclePage()
    }
    
    // MARK: Private Functions
    private func setButtonsFeature(buttonList: [ButtonData]) {
        self.buttons = buttonList
    }
    
    private func setStaticButtonForCirclePage() {
        buttonsCirclePage = [ButtonData(name: "Delete All", draw_path: "deleteAllCircle"),
                             ButtonData(name: "Add", draw_path: "addCircle"),
                             ButtonData(name: "Remove", draw_path: "removeCircle")]
    }
    
    private func refreshShapes() async {
        Task {
            self.shapes = await shapeStore.getShapes()
        }
    }
    
    
    // MARK: Request for button
    func fetchButtons() async {
        do {
            let response: APIResponse = try await network.request(from: CCAPIEndpoint.getButtonsShape)
            setButtonsFeature(buttonList: response.buttons)
        } catch let error as CCNetworkError {
            print(error)
            self.error = error
        } catch {
            print(error)
            self.error = .unknown
        }
    }
    
    // MARK: Functions
    
    func addShape(_ shape: ShapeItem) {
        Task {
            await shapeStore.addShape(shape)
            await refreshShapes()
        }
    }
    
    func deleteAllShape() {
        Task {
            await shapeStore.deleteAll()
            await refreshShapes()
        }
    }
    
    func deleteAllCircle() {
        Task {
            await shapeStore.deleteAllShapes(ofType: "Circle")
            await refreshShapes()
        }
    }
    
    func deleteCircle() {
        Task {
            await shapeStore.deleteItem(ofType: "Circle")
            await refreshShapes()
        }
    }
    
    func handleOperation(_ button: ButtonData) {
        if button.draw_path == "addCircle" {
            self.addShape(ShapeItem(type: "Circle", draw_path: "circle"))
        }
        
        else if button.draw_path == "removeCircle" {
            self.deleteCircle()
        }
        
        else if button.draw_path == "deleteAllCircle" {
            self.deleteAllCircle()
        }
    }
}
