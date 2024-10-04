//
//  AppMenu.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//


import SwiftUICore
import SwiftUI

struct AppMenu: View {
    @ObservedObject var state : AppState
    @State var input = "Ask DeepSeek anything!"
    @State var apiKey : String? = getAPIKey()
    @State var keyIn = ""

    var quit : () -> ();
    func syncAPIKey(){
        apiKey = getAPIKey()
        switch apiKey {
        case .none:
            keyIn = "Paste your key here"
        case _:
            ()
        }
    }
    func textArea(b: Binding<String>) -> some View{
        TextEditor(text: b)
            .frame(maxHeight: 400)
            .font(.title3)
            .padding(5)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.6), lineWidth: 2)
            )
            .padding([.leading, .trailing])
            .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View {
        let quitButton = Button(action: quit, label: { Text("Quit") })

        switch (apiKey, state.state) {
        case (_, .Error(let s)):
            Spacer()
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                Text("An error occured")
            }
            textArea(b: .constant(s))
            Divider()
            HStack{
                Button(action: {() -> () in state.update(state: .Init)}, label: {Text("Ok")})
                quitButton
            }
            Spacer()
        case (.none, _):
            Spacer()
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Setup DeepSeek api key:")
            }
            textArea(b: $keyIn)
            HStack{
                quitButton
                Button(action: {() -> () in
                    if saveAPIKey(key: keyIn) {
                        syncAPIKey()
                        state.update(state: .Init)
                    } else {
                        syncAPIKey()
                        state.update(state: .Error("Failed to save API key to keychain."))
                    }
                }, label: { Text("Enter") })
            }
            Spacer()
        case (.some(let key), .Init):
            Spacer()
            textArea(b: $input)
            Button(action: {() -> () in
                state.update(state: .Busy)
                DispatchQueue.main.async{
                    Task {
                        let res = await callDeepSeekAPI(apiKey: key,s: input)
                        switch res {
                        case .right(let l):
                            state.update(state: .Error(l))
                        case .left(let r):
                            state.update(state: .Result(input, r))
                        }
                    }
                }
            }, label: {Text("Ask DeepSeek")})
            Divider()
            HStack{
                Button(action: {() -> () in
                    if deleteAPIKey() {
                        syncAPIKey()
                        state.update(state: .Init)
                    }else{
                        syncAPIKey()
                        state.update(state: .Error("Failed to delete API Key from keychain"))
                    }
                }, label: {Text("Delete API Key")})
                quitButton
            }
            Spacer()
        case (_, .Busy):
            Spacer()
            HStack {
                Image(systemName: "circle.fill")
                    .symbolEffect(.bounce, options:.repeating)
                    .font(.footnote)
                Text("Waiting for Answer")
            }
            Divider()
            HStack{
                quitButton
                Button(action: {() -> () in state.update(state: .Init)}, label: { Text("Ok") })
            }
            Spacer()
        case (_, .Result(let query, let answer)):
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Quetion posted:")
            }
            textArea(b: .constant(query))
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Answer from AI:")
            }
            textArea(b: .constant(answer))
            Divider()
            HStack{
                quitButton
                Button(action: {() -> () in state.update(state: .Init)}, label: { Text("Ok") })
            }
            Spacer()
        }
    }
}
