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
    @StateObject var urlState = URLState()
    @Environment(\.dismissWindow) private var dismissWindow

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
            ContentView(state: state, urlState: urlState, quit: quit)
        }.menuBarExtraStyle(.window)

        Window("key", id: "key") {
            EmptyView()
                .onOpenURL{ url in
                    urlState.update(url: url)
                    DispatchQueue.main.async {
                        dismissWindow(id: "key")
                    }
                }
        }.windowLevel(.floating)
    }
}
