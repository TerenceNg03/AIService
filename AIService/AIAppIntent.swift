//
//  RefineAppIntent.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-05.
//

import AppIntents
import SwiftUI

struct AIIntent: AppIntent {
    static var title: LocalizedStringResource = "Ask DeepSeek"

    @Parameter(title: "Enter prompt below")
    var prompt: String

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let apiKey = getAPIKey()
        guard let apiKey = apiKey else {
            return .result(value: "", dialog: "API key has not been setup!")
        }
        let result = await callDeepSeekAPI(apiKey: apiKey, s: prompt)
        switch result {
        case .left(let l):
            return .result(value: l, dialog: "\(l)")
        case .right(let r):
            return .result(value: "", dialog: "\(r)")
        }
    }
}

struct AIShortcuts: AppShortcutsProvider {
    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AIIntent(),
            phrases: [
                "Ask DeepSeek"
            ],
            shortTitle: "Ask DeepSeek",
            systemImageName: "bubble.and.pencil"
        )
    }
}
