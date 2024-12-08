//
//  GameOfLifeView.swift
//  ConwaysGameOfLife
//
//  Created by James Vieyra on 2024/12/07.
//

import Foundation
import SwiftUI

struct GameOfLifeView: View {
    @ObservedObject var viewModel: GameOfLifeViewModel
    
    init(viewModel: GameOfLifeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            Spacer()
           
            gridView
            
            Spacer()
            
            HStack(alignment: .center) {
                if viewModel.started {
                    resetButton
                }
                
                topButton
                
                if viewModel.started {
                    nextButton
                }
            }
            .padding(12)
            .background(
                Color.secondary
                    .opacity(0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            )
        }
        .overlay(alignment: .topLeading) {
            leadingOverlay
        }
        .overlay(alignment: .topTrailing) {
            trailingOverlay
        }
    }
    
    @ViewBuilder private var gridView: some View {
        ScrollView([.horizontal,.vertical]) {
            Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                
                ForEach(viewModel.grid.indices, id: \.self) { row in
                    GridRow {
                        ForEach(viewModel.grid[row].indices, id: \.self) { column in
                            if !viewModel.started {
                                Button {
                                    viewModel.grid[row][column].toggle()
                                    if viewModel.grid[row][column] {
                                        self.viewModel.population += 1
                                    } else {
                                        self.viewModel.population -= 1
                                    }
                                } label: {
                                    viewModel.getCell(row: row, column: column) ? Color.black : Color.secondary.opacity(0.5)
                                }
                                .buttonStyle(.bordered)

                            } else {
                                viewModel.getCell(row: row, column: column) ? Color.black : Color.secondary.opacity(0.5)
                            }
                        }
                    }
                }
                
            }
            .padding(.init(top: 20, leading: 12, bottom: 20, trailing: 12))
        }
        
    }
    
    @ViewBuilder private var topButton: some View {
        ZStack {
            if viewModel.started {
                
                Button {
                    
                    if !viewModel.playing {
                        Task {
                            await viewModel.play()
                        }
                    } else {
                        viewModel.playing = false
                        viewModel.paused = true
                    }
                    
                } label: {
                   
                    if viewModel.playing {
                        Text(!viewModel.playing ? "Play" : "Pause")
                        Image(systemName: !viewModel.playing ? "play.fill" : "pause.fill" )
                    }
                    
                    if viewModel.paused {
                        Text("Play")
                        Image(systemName: "play.fill")
                    }
                }
                .buttonStyle(.borderedProminent)
                
            } else {
                
                Button {
                    viewModel.beginSimulation()
                } label: {
                    Text("Begin simulation")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
    
    private var resetButton: some View {
        Button {
            viewModel.generateEmptySeedGrid()
        } label: {
            Image(systemName: "arrow.counterclockwise")
            Text("Reset")
        }
        .buttonStyle(.borderedProminent)
        
    }
    
    private var nextButton: some View {
        Button {
            viewModel.grid = viewModel.computeGeneration()
        } label: {
            Text("Next")
            Image(systemName: "arrow.right")
        }
        .buttonStyle(.borderedProminent)
    }
    
    @ViewBuilder private var leadingOverlay: some View {
        VStack {
            if (!viewModel.started) {
                Button {
                    viewModel.generateEmptySeedGrid()
                } label: {
                    Text("Reset")
                }
                .buttonStyle(.bordered)
            }
            Text("Generation: \(viewModel.generation)")
            Text("Population: \(viewModel.population)")
        }
        .padding(10)
    }
    
    private var trailingOverlay: some View {
        Button {
            viewModel.seed(grid: seedGrid)
        } label: {
            Text("Seed")
        }
        .buttonStyle(.bordered)
        .padding(10)
    }
}

#Preview {
    GameOfLifeView(viewModel: GameOfLifeViewModel())
}
