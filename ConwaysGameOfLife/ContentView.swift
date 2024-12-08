//
//  ContentView.swift
//  ConwaysGameOfLife
//
//  Created by James Vieyra on 2024/12/07.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel: GameOfLifeViewModel = .init()
    
    var body: some View {
        GameOfLifeView(viewModel: viewModel)
    }
}

#Preview {
    ContentView()
}
