//
//  GameSetting.swift
//  Tic-Tac-Toe
//
//  Created by Louis Qian on 2/18/22.
//

import SwiftUI

enum Player {
    case human, computer
}

struct Move {
    let player:Player
    //Position on board
    let boardIndex: Int
    //Indicator for move
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
