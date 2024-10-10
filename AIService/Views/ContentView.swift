//
//  AppMenu.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//


import SwiftUI
import Atomics

struct ContentView: View {
    @ObservedObject var state : AppState
    @ObservedObject var urlState : URLState

    @State var currentTask : ManagedAtomic<Bool>? = nil
    @Binding var apiKey : String?

    var quit : () -> ();

    func syncAPIKey(){
        apiKey = getAPIKey()
        switch apiKey {
        case .none:
            ()
        case .some(let key):
            apiKey = key
        }
    }

    func ask(input: String, key: String) {
        let signal = ManagedAtomic(false)
        Task {
        if let task = currentTask {
            task.store(true, ordering: .relaxed)
        }
        currentTask = signal
        state.set(.Busy(input, ""))
        await APICall(state: state, stop: signal)
            .callAPI(apiKey: key, s: "Try to be brief.\n" + input, displayInput: input)
        }
    }

    func refine(input: String, key: String){
        state.set(.Busy(input, ""))
        Task {
            let signal = ManagedAtomic(false)
            if let task = currentTask {
                task.store(true, ordering: .relaxed)
            }
            currentTask = signal
            await APICall(state: state, stop: signal)
                .callAPI(apiKey: key, s: "Refine the following text and return only the result. " + input, displayInput: input)
        }
    }

    func handleURL(url: URL){
        guard url.scheme == "aiservice" else {
            return
        }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return
        }
        guard let query = components.queryItems?.first(where: { $0.name == "q" })?.value else {
            return
        }

        switch components.host {
        case .some("refine"):
            if let key = getAPIKey() {
                refine(input:query, key: key)
            } else {
            }
            return
        case .some("ask"):
            if let key = getAPIKey() {
                ask(input:query, key: key)
            } else {
            }
            return
        case _:
            ()

        }
    }

    var body: some View {
        VStack{
            if let url = urlState.url {
                let _ = DispatchQueue.main.async {
                    urlState.update(url: nil)
                    handleURL(url: url)
                }
                Text("Received deeplink")
            } else {
                switch (apiKey, state.v) {
                case (_, .Error(let s)):
                    ErrorPage(error: s)
                case (.none, _):
                    ReadAPIKey{ input in
                        if saveAPIKey(key: input) {
                            syncAPIKey()
                            state.set(.Ask)
                        } else {
                            syncAPIKey()
                            state.set(.Error("Failed to save API key to keychain."))
                        }
                    }
                case (.some(let key), .Ask):
                    AskPage{input in ask(input: input, key:key)}
                case (.some(let key), .Refine):
                    RefinePage{input in refine(input: input, key:key)}
                case (_, .Busy(let query, let answer)):
                    ResultPage(query: .constant(query), answer: .constant(answer))
                case (_, .Result(let query, let answer)):
                    ResultPage(query: .constant(query), answer: .constant(answer))
                }
            }
        }.frame(width: 400)
    }
}
