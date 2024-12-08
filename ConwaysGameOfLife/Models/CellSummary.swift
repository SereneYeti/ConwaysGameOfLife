//
//  CellSummary.swift
//  ConwaysGameOfLife
//
//  Created by James Vieyra on 2024/12/08.
//

struct CellSummary {
    let x: Int
    let y: Int
    let alive: Bool
    var neighbors: CellNeighbors?
}

struct CellNeighbors {
    let topLeading: Bool
    let top: Bool
    let topTrailing: Bool
    
    let bottomLeading: Bool
    let bottom: Bool
    let bottomTrailing: Bool
    
    let leading: Bool
    let trailing: Bool
    
    var count: Int {
        var count: Int = 0
        
        if topLeading { count += 1 }
        if top { count += 1 }
        if topTrailing { count += 1 }
        
        if bottomLeading { count += 1 }
        if bottom { count += 1 }
        if bottomTrailing { count += 1 }
        
        if leading { count += 1 }
        if trailing { count += 1 }
        
        return count
    }
}
