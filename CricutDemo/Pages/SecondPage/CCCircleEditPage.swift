//
//  CCCircleEditPage.swift
//  CricutDemo
//
//  Created by BB Mete on 3/27/25.
//
import SwiftUI

// I used CC prefix naming for "CriCut"
struct CCCircleEditPage: View {
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @ObservedObject var viewModel: CCShapeViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                if !viewModel.shapes.isEmpty {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.shapes) { item in
                                if item.draw_path == "circle" {
                                    Circle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(height: 100)
                                }
                                
                            }
                        }
                        .padding()
                    }
                }
                else {
                    Spacer()
                }
                Spacer()
                
                CCFooterButton(buttons: viewModel.buttonsCirclePage) { name, path in
                    viewModel.handleOperation(ButtonData(name: name, draw_path: path))
                }
            }
            
        }        
    }
}

#Preview {
    CCMainPage(viewModel: CCShapeViewModel())
}
