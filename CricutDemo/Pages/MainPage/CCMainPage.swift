//
//  ContentView.swift
//  CricutDemo
//
//  Created by BB Mete on 3/26/25.
//

import SwiftUI

// I used CC prefix naming for "CriCut"
struct CCMainPage: View {
    @State private var showError = false
    @ObservedObject var viewModel: CCShapeViewModel
    
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
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
                                else if item.draw_path == "triangle" {
                                    CCTriangle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(height: 100)
                                    
                                }
                                else if item.draw_path == "square" {
                                    RoundedRectangle(cornerRadius: 10)
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
                
                CCFooterButton(buttons: viewModel.buttons) { name, path in
                    viewModel.addShape(ShapeItem(type: name, draw_path: path))
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    CCButton(title: "Clear All") {
                        viewModel.deleteAllShape()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CCCircleEditPage(viewModel: viewModel)) {
                        Text("Edit Circles")
                            .font(.system(size: 17))
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Error", isPresented: $showError, presenting: viewModel.error) { _ in
                Button("OK", role: .cancel) {}
            } message: { error in
                Text(error.localizedDescription)
            }
        }
        .onChange(of: viewModel.error) { error, _ in
            showError = true
        }
        .task {
            await viewModel.fetchButtons()
        }
        
    }
}

#Preview {
    CCMainPage(viewModel: CCShapeViewModel())
}
