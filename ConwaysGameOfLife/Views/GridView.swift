//
//  GridView.swift
//  ConwaysGameOfLife
//
//  Created by James Vieyra on 2024/12/08.
//
import SwiftUI

struct GridView: View {
    @ObservedObject var viewModel: GameOfLifeViewModel
    
    var body: some View {
        ScrollView([.horizontal,.vertical]) {
            LazyVStack {
                
                ForEach(viewModel.grid.indices, id: \.self) { row in
                    gridRow(row: row)
                }
                
            }
        }
    }
    
    private func gridRow(row: Int) -> some View {
        HStack {
            ForEach(viewModel.grid[row].indices, id: \.self) { column in
                if !viewModel.started {
                    gridButton(row: row, column: column)

                } else {
                    viewModel.getCell(row: row, column: column) ? Color.black : Color.secondary.opacity(0.5)
                }
            }
        }
    }
    
    private func gridButton(row: Int,column: Int) -> some View {
        Button {
            viewModel.tapGridButton(row: row, column: column)
        } label: {
            viewModel.getCell(row: row, column: column) ? Color.black : Color.secondary.opacity(0.5)
        }
        .buttonStyle(.bordered)
    }
}
