//
//  GameModel.swift
//  RandomNumberList
//
//  Created by Jacob Lavenant on 6/30/23.
//

import Foundation


struct Game {
    enum gameMode: Int, CaseIterable {
        case easy = 5
        case medium = 10
        case hard = 20
    }
    
    var mode: gameMode
    var numbers: [Int?]
    var nextNumber: Int = 0
    var score = 0
    
    init(mode: gameMode) {
        self.mode = mode
        self.numbers = Array(repeating: nil, count: mode.rawValue)
        generateNextNumber()
    }
    
    mutating func generateNextNumber() {
        nextNumber = Int.random(in: 0...1000)
    }
    
    mutating func placeNumber(at index: Int) -> Bool {
        if isPlacementValid(at: index) {
            numbers[index] = nextNumber
            generateNextNumber()
            score += 1
            return true
        }
        return false
    }
    
    
    func isPlacementValid(at index: Int) -> Bool {
        let leftSlice = numbers[..<index].compactMap { $0 }
        let rightSlice = numbers[(index + 1)...].compactMap { $0 }
        
        if let maxLeft = leftSlice.max(), maxLeft > nextNumber {
            return false
        }
        
        if let minRight = rightSlice.min(), minRight < nextNumber {
            return false
        }
        
        return true
    }
    
    func hasValidMoves() -> Bool {
        for index in numbers.indices {
            if numbers[index] == nil && isPlacementValid(at: index) {
                return true
            }
        }
        return false
    }
    
    mutating func restartGame() {
        numbers = Array(repeating: nil, count: mode.rawValue)
        generateNextNumber()
        score = 0
    }
}
