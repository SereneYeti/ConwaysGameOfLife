//
//  GameOfLifeViewModel.swift
//  ConwaysGameOfLife
//
//  Created by James Vieyra on 2024/12/07.
//

import Foundation
import SwiftUI

@MainActor protocol GameOfLifeViewModelProtocol: ObservableObject {
    typealias GameOfLifeGrid = [[Bool]]
    
    var MAPWIDTH: Int { get }
    var MAPHEIGHT: Int { get }
    var MOVEDELAY: Int { get }
    
    func seed(grid: GameOfLifeGrid)
    func getCell(row: Int, column: Int) -> Bool
    func computeSummary(row: Int, column: Int) -> CellSummary
    func computeGeneration() -> GameOfLifeGrid
    func play() async
}

class GameOfLifeViewModel: GameOfLifeViewModelProtocol {
      
    let MAPWIDTH: Int = 100
    let MAPHEIGHT: Int = 100
    let MOVEDELAY: Int = 1
    
    @Published var grid: GameOfLifeGrid
    
    @Published var started: Bool = false
    @Published var paused: Bool = true
    @Published var playing: Bool = false
    
    @Published var generation: Int = 0
    @Published var population: Int = 0
    
    init() {
        self.grid = [[]]
        self.generateEmptySeedGrid()
    }
    
    func seed(grid: [[Bool]]) {
        self.grid = grid
    }
    
    func getCell(row: Int, column: Int) -> Bool {
        return grid[row][column]
    }
    
    func computeGeneration() -> GameOfLifeGrid {
        var newGrid: GameOfLifeGrid = grid
        self.population = 0
        
        for row in 0..<MAPHEIGHT {
            for column in 0..<MAPWIDTH {
                let summary = computeSummary(row: row, column: column)
                
                let evaluation = Rules.evalutate(cell: summary)
                newGrid[row][column] = evaluation?.asBool() ?? false
                
                if evaluation?.asBool() ?? false {
                    self.population += 1
                }
            }
        }
        
        self.generation += 1
        return newGrid
    }
    
    func computeSummary(row: Int, column: Int) -> CellSummary {
        var cellSummary = CellSummary(
            x: row,
            y: column,
            alive: getCell(row: row, column: column)
        )
          
        let topNeighbor = (row - 1 >= 0) ? getCell(row: row - 1, column: column) : false
        let bottomNeighbor = (row + 1 < MAPHEIGHT) ? getCell(row: row + 1, column: column) : false
        
        let leadingNeighbor = (column - 1 >= 0) ? getCell(row: row, column: column - 1) : false
        let trailingNeighbor = (column + 1 < MAPWIDTH) ? getCell(row: row, column: column + 1) : false
        
        let topLeadingNeighbor = (row - 1 >= 0) && (column - 1 >= 0) ? getCell(row: row - 1, column: column - 1) : false
        let topTrailingNeighbor = (row - 1 >= 0) && (column + 1 < MAPWIDTH) ? getCell(row: row - 1, column: column + 1) : false
        
        let bottomLeadingNeighbor = (row + 1 < MAPHEIGHT) && (column - 1 >= 0) ? getCell(row: row + 1, column: column - 1) : false
        let bottomTrailingNeighbor = (row + 1 < MAPHEIGHT) && (column + 1 < MAPWIDTH) ? getCell(row: row + 1, column: column + 1) : false
        
        cellSummary.neighbors = CellNeighbors(
            topLeading: topLeadingNeighbor,
            top: topNeighbor,
            topTrailing: topTrailingNeighbor,
            bottomLeading: bottomLeadingNeighbor,
            bottom: bottomNeighbor,
            bottomTrailing: bottomTrailingNeighbor,
            leading: leadingNeighbor,
            trailing: trailingNeighbor
        )
        
        
        return cellSummary
    }
    
    func beginSimulation() {
        self.started = true
        self.generation = 0
        self.grid = self.computeGeneration()
    }
    
    func generateEmptySeedGrid() {
        started = false
        self.generation = 0
        self.population = 0
        self.grid = [[]]
        
        for row in 0..<MAPHEIGHT {
            for case _ in 0..<MAPWIDTH {
                self.grid[row].append(false)
            }
            
            self.grid.append([])
        }
        
    }
    
    public func tapGridButton(row: Int, column: Int) {
        grid[row][column].toggle()
        if grid[row][column] {
            self.population += 1
        } else {
            self.population -= 1
        }
    }
    
    func play() async {
        self.playing = true
        self.paused = false
        while started && !paused {
            do {
                try await Task.sleep(for: .seconds(1))
                self.grid = self.computeGeneration()
                self.generation += 1
            } catch {
                debugPrint("Error: \(error)")
                started = false
            }
        }
    }
}
