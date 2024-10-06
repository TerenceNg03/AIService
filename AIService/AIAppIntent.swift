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
            return .result(value: "", dialog: "Unsupported for now.")
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
