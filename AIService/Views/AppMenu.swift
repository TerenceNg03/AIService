//
//  AppMenu.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-08.
//

import SwiftUI

struct AppMenu: View{
    
    @ObservedObject var state : AppState
    @Binding var apiKey : String?

    var quit : () -> ();
    var togglePanel: () -> ();
    var openPanel: () -> ();

    func deleteAPIKeyAction(){
        if deleteAPIKey() {
            syncAPIKey()
            state.set(.Ask)
        }else{
            syncAPIKey()
            state.set(.Error("Failed to delete API Key from keychain"))
        }
    }

    func syncAPIKey(){
        apiKey = getAPIKey()
        switch apiKey {
        case .none:
            ()
        case .some(let key):
            apiKey = key
        }
    }
    
    var body: some View {
        Section("API Key"){
            Button(role:.destructive, action: deleteAPIKeyAction, label: {Text("Delete API Key")})
        }
        
        Section("Floating Panel"){
            Button {
                togglePanel()
            }label: {Text("Toggle Panel")}
                .keyboardShortcut("p", modifiers: .command)
        }
        Section("Function"){
            Button {
                state.set(.Ask)
                openPanel()
            }label: {Text("Ask AI")}
                .keyboardShortcut("1", modifiers: .command)
            Button{
                state.set(.Refine)
                openPanel()
            }label: {Text("Refine Text")}
                .keyboardShortcut("2", modifiers: .command)
        }

        Button{
            quit()
        }label: {Text("Quit")}
            .keyboardShortcut("q", modifiers: .command)
    }
}
