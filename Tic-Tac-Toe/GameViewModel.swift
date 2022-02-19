//
//  GameViewModel.swift
//  Tic-Tac-Toe
//
//  Created by Louis Qian on 2/18/22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible())]
    
    // Optional (nil at no move items)
    // Empty game board
    @Published var moves : [Move?] = Array(repeating: nil, count: 9)
    // Handel user double tap while waiting for that 0.5 sec delay
    @Published var isGameboardDisabled = false
    @Published var alertItem: AlertItem?
    
    func processPlayerMove(for position: Int) {
        
        // If square is taken, return and don't do anything
        if isSquareOccupied(in: moves, forIndex: position) { return }
        moves[position] = Move(player: .human, boardIndex: position)
        
        // Check for win condition
        if checkWinCondition(for: .human, in: moves) {
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkDrawCondition(in: moves) {
            alertItem = AlertContext.draw
            return
        }
        
        isGameboardDisabled = true;
        
        
        // 0.5 s delay to make the machine move more natural
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 0.2 ..< 1)) { [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            
            if checkWinCondition(for: .computer, in: moves) {
                alertItem = AlertContext.computerWin
                return
            }
            
            if checkDrawCondition(in: moves) {
                alertItem = AlertContext.draw
                return
            }
        }
        isGameboardDisabled = false;
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        // Pass in a moves array, for each ($0) in the arrray, if that move's index == current index,
        // then this square is taken
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    // If AI can win, go and win
    // If AI can't win, block
    // If AI can't block, take middle
    // If AI can't take middle, take a random square
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        
        // If can win, win
        // Check 2 out of 3 in the set
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let computerMoves = moves.compactMap { $0 }.filter {$0.player == .computer}
        let comptuerPositions = Set(computerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            // For each pattern, subtracting com position -> get index left.
            let winPositions = pattern.subtracting(comptuerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If can't win, block
        let humanMoves = moves.compactMap { $0 }.filter {$0.player == .human}
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            // For each pattern, subtracting com position -> get index left.
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        // If can't block, middle (To make this more interesting, I'll give it 50% to take middle)
        let centerSquare = 4
        if (!isSquareOccupied(in: moves, forIndex: centerSquare) && Double.random(in: 0.0...1.0) < 0.5) {
            return centerSquare
        }
        
        // Random position
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        // Series of board index that makes a win
        let winPatterns: Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        let playerMoves = moves.compactMap { $0 }.filter {$0.player == player} // get rid of all the nils, filter out human moves
        let playerPositions = Set(playerMoves.map { $0.boardIndex }) // give all the move positions (set of integers)
        
        // Iteration win patters, whenever there's a match, return true or false if no wins
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkDrawCondition(in moves: [Move?]) -> Bool {
        // Run compact map to remove all the nils, then if the count is 9 -> board filled, no winner -> draw
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
    }
}

