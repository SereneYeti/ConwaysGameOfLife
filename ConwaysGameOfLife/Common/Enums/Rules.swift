//
//  Rules.swift
//  ConwaysGameOfLife
//
//  Created by James Vieyra on 2024/12/07.
//

enum Rules {
    
    /// <summary>
    /// Any live cell with fewer than two live neighbours dies, as if by underpopulation.
    /// </summary>
    case lessThanTwo
    
    /// <summary>
    /// Any live cell with two or three live neighbours lives on to the next generation..
    /// </summary>
    case twoOrThree
    
    /// <summary>
    /// Any live cell with more than three live neighbours dies, as if by overpopulation..
    /// </summary>
    case moreThanThree
    
    /// <summary>
    /// Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
    /// </summary>
    case exactlyThree
    
}

extension Rules {
    static func evalutate(cell: CellSummary) -> Rules? {
        
        if cell.alive && (cell.neighbors?.count ?? 0) < 2 {
            return .lessThanTwo
        } else if cell.alive && cell.neighbors?.count == 2 || cell.neighbors?.count == 3 {
            return .twoOrThree
        } else if cell.alive && (cell.neighbors?.count ?? 0) > 3 {
            return .moreThanThree
        } else if !cell.alive && cell.neighbors?.count == 3 {
            return .moreThanThree
        }
        
        return nil
    }
    
    func asBool() -> Bool {
        switch self {
        case .lessThanTwo: return false
        case .twoOrThree: return true
        case .moreThanThree: return false
        case .exactlyThree: return true
        }
    }
}
