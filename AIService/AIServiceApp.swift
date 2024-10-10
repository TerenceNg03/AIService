//
//  AIServiceApp.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//

import SwiftUI
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    // **NOTE**: It is not recommended to set a default keyboard shortcut. Instead opt to show a setup on first app-launch to let the user define a shortcut
    static let showFloatingPanel = Self("showFloatingPanel", default: .init(.space, modifiers: [.option]))
}


@main
struct AIServiceApp: App {
    @StateObject var state : AppState = AppState()
    @StateObject var urlState = URLState()
    @State var apiKey : String? = getAPIKey()
    @Environment(\.dismissWindow) private var dismissWindow
    
    @State var panel: NSPanel = FloatingPanel(
        contentRect: NSRect(),
        backing: .buffered,
        defer: false
    )
    @State var panelOpen = false
    @State var windowCreated = false

    func quit() {
        NSApplication.shared.terminate(self)
    }

    func icon() -> String {
        switch state.v {
        case .Busy:
            "ellipsis.bubble"
        case .Error:
            "exclamationmark.bubble"
        case .Result:
            "checkmark.bubble"
        case _:
            "bubble.and.pencil"
        }
    }

    func initPanel(){
        if !windowCreated {
            panel.contentView = NSHostingView(
                rootView:
                    ContentView(
                        state: state,
                        urlState: urlState,
                        apiKey: $apiKey,
                        quit: quit)
                    .background(.clear)
            )
            windowCreated = true
        }
        panel.setFrameOrigin(
            NSPoint(x: (panel.screen?.frame.width ?? 0) - panel.frame.width - 50,
                    y: (panel.screen?.frame.height ?? 0) - panel.frame.height - 50))
    }

    func openPanel(){
        initPanel()
        panel.makeKeyAndOrderFront(nil)
        panelOpen = true
    }

    func closePanel(){
        panel.orderOut(nil)
        panelOpen = false
    }

    func togglePanel(){
        initPanel()
        if panelOpen {
            closePanel()
        } else {
            openPanel()
        }
    }

    var body: some Scene {
        let _ = KeyboardShortcuts.onKeyUp(for: .showFloatingPanel, action: {
            togglePanel()
        })
        MenuBarExtra(
            "AIService",
            systemImage: icon())
        {
            AppMenu(state: state,
                    apiKey: $apiKey,
                    quit: quit,
                    togglePanel: togglePanel)
        }

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

