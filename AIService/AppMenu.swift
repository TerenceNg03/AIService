//
//  AppMenu.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//


import SwiftUI

struct AppMenu: View {
    @ObservedObject var state : AppState
    
    @State var askInput = "Ask DeepSeek anything!"
    @State var refineInput = "Original Text"
    @State var apiKey : String? = getAPIKey()
    @State var keyIn = ""

    var quit : () -> ();
    func menuStyle(v: () -> some View) -> some View {
        return HStack {
            v().buttonStyle(.borderless)
                .padding([.leading, .trailing])
            Spacer()
        }
    }
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
        let homeButton = Button {() -> () in
            state.update(state: .Init)
        } label: {Image(systemName: "bubble.and.pencil")}

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
        case (_, .Init):
            VStack{
                Spacer()
                menuStyle{
                    Text("API Key")
                        .foregroundStyle(.black.opacity(0.5))
                        .bold()
                        .font(.footnote)
                }
                Spacer()
                menuStyle {
                    Button(
                        role: .destructive,
                        action: {() -> () in
                            if deleteAPIKey() {
                                syncAPIKey()
                                state.update(state: .Init)
                            }else{
                                syncAPIKey()
                                state.update(state: .Error("Failed to delete API Key from keychain"))
                            }
                        }, label: {Text("Delete API Key").foregroundStyle(.red)})
                }
                Divider()
                menuStyle{
                    Text("Function")
                        .foregroundStyle(.black.opacity(0.5))
                        .font(.footnote)
                        .bold()
                }
                Spacer()
                menuStyle {
                    Button(action: {() -> () in state.update(state: .Ask)},label: {Text("Ask AI")})
                }
                menuStyle {
                    Button(action: {() -> () in state.update(state: .Refine)},label: {Text("Refine Text")})
                }
                Divider()
                menuStyle {
                    quitButton
                }
                Spacer()
            }
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
        case (.some(let key), .Ask):
            Spacer()
            Text("Ask DeepSeek:")
            textArea(b: $askInput)
            Divider()
            HStack{
                homeButton
                Button(action: {() -> () in
                    state.update(state: .Busy)
                    DispatchQueue.main.async{
                        Task {
                            let res = await callDeepSeekAPI(apiKey: key,s: askInput)
                            switch res {
                            case .right(let l):
                                state.update(state: .Error(l))
                            case .left(let r):
                                state.update(state: .Result(askInput, r))
                            }
                        }
                    }
                }, label: {Text("Send")})
            }
            Spacer()
        case (.some(let key), .Refine):
            Spacer()
            Text("Text to refine")
            textArea(b: $refineInput)
            Divider()
            HStack{
                homeButton
                Button(action: {() -> () in
                    state.update(state: .Busy)
                    DispatchQueue.main.async{
                        Task {
                            let res = await callDeepSeekAPI(
                                apiKey: key,
                                s: "Refine the following text and return only the result. " + refineInput)
                            switch res {
                            case .right(let l):
                                state.update(state: .Error(l))
                            case .left(let r):
                                state.update(state: .Result(refineInput, r))
                            }
                        }
                    }
                }, label: {Text("Send")})
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
                homeButton
                Button(action: {() -> () in state.update(state: .Init)}, label: { Text("Ok") })
            }
            Spacer()
        case (_, .Result(let query, let answer)):
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Input")
            }
            textArea(b: .constant(query))
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Answer from AI:")
            }
            textArea(b: .constant(answer))
            Divider()
            HStack{
                homeButton
                Button(action: {() -> () in state.update(state: .Init)}, label: { Text("Ok") })
            }
            Spacer()
        }
    }
}
