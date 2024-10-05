//
//  AIServiceApp.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//

import SwiftUI

@main
struct AIServiceApp: App {
    @StateObject var state = AppState()

    func quit() {
        NSApplication.shared.terminate(self)
    }

    func icon(state: AppState) -> String {
        switch state.state {
        case .Busy:
            "ellipsis.bubble"
        case .Error(_):
            "exclamationmark.bubble"
        case .Result(_, _):
            "checkmark.bubble"
        case _:
            "bubble.and.pencil"
        }
    }

    var body: some Scene {
        MenuBarExtra(
            "AIService",
            systemImage: icon(state: state))
        {
            AppMenu(state: state, quit: quit)
        }.menuBarExtraStyle(.window)
    }
}
