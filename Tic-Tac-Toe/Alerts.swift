//
//  Alerts.swift
//  Tic-Tac-Toe
//
//  Created by Louis Qian on 2/18/22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win!"),
                                    message: Text("You beat AI!"),
                                    buttonTitle: Text("Yeahh"))
    static let computerWin = AlertItem(title: Text("You lost!"),
                                       message: Text("My fantastic AI beat you!"),
                                       buttonTitle: Text("Yesss"))
    static let draw = AlertItem(title: Text("Draw!"),
                                message: Text("My AI is just as smart as you"),
                                buttonTitle: Text("Rematch!?"))
}
