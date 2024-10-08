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

    @State var askInput = "Ask DeepSeek anything!"
    @State var currentTask : ManagedAtomic<Bool>? = nil
    @State var refineInput = "Original Text"
    @State var output = ""
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
    func textArea(_ b: Binding<String>) -> some View{
        TextEditor(text: b)
            .font(.title3)
            .frame(maxHeight: 400)
            .padding(5)
            .cornerRadius(4)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.black.opacity(0.6), lineWidth: 2)
            )
            .padding([.leading, .trailing])
            .fixedSize(horizontal: false, vertical: true)
    }

    func deleteAPIKeyAction(){
        if deleteAPIKey() {
            syncAPIKey()
            state.update(state: .Init)
        }else{
            syncAPIKey()
            state.update(state: .Error("Failed to delete API Key from keychain"))
        }
    }

    func homeButton() -> some View {
        Button {() -> () in
            state.update(state: .Init)
        } label: {Image(systemName: "bubble.and.pencil")}
    }

    func errorPage(s: String) -> some View{
        VStack{
            Spacer()
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                Text("An error occured")
            }
            textArea(.constant(s))
            Divider()
            homeButton()
            Spacer()
        }
    }

    func readAPIKeyPage() -> some View {
        VStack{
            Spacer()
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Setup DeepSeek api key:")
            }
            textArea($keyIn)
            Button{
                if saveAPIKey(key: keyIn) {
                    syncAPIKey()
                    state.update(state: .Init)
                } else {
                    syncAPIKey()
                    state.update(state: .Error("Failed to save API key to keychain."))
                }
            }label: { Text("Enter") }
            Spacer()
        }
    }

    func ask(key: String) {
        let signal = ManagedAtomic(false)
        if let task = currentTask {
            task.store(true, ordering: .relaxed)
        }
        currentTask = signal
        DispatchQueue.main.async{
            Task {
                state.update(state: .Busy(askInput, ""))
                await APICall(state: state, stop: signal)
                    .callAPI(apiKey: key, s: "Try to be brief.\n"+askInput, displayInput: askInput)
            }
        }
    }

    func refine(key: String){
        state.update(state: .Busy(refineInput, ""))
        DispatchQueue.main.async{
            Task {
                let signal = ManagedAtomic(false)
                if let task = currentTask {
                    task.store(true, ordering: .relaxed)
                }
                currentTask = signal
                await APICall(state: state, stop: signal)
                    .callAPI(apiKey: key, s: "Refine the following text and return only the result. " + refineInput, displayInput: refineInput)
            }
        }
    }

    func askPage(key: String) -> some View {
        VStack{
            Spacer()
            Text("Ask DeepSeek:")
            textArea($askInput)
            Divider()
            HStack{
                homeButton()
                Button(action: {() -> () in
                    ask(key: key)
                }, label: {Text("Send")})
            }
            Spacer()
        }
    }

    func refinePage(key: String) -> some View {
        VStack{
            Spacer()
            Text("Text to refine")
            textArea($refineInput)
            Divider()
            HStack{
                homeButton()
                Button(action: {() -> () in
                    refine(key: key)
                }, label: {Text("Send")})
            }
            Spacer()
        }
    }

    func busyPage(query:String, answer: String) -> some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Input posted")
            }
            textArea(.constant(query))
            HStack {
                Image(systemName: "circle.fill")
                    .symbolEffect(.bounce, options:.repeating)
                    .font(.footnote)
                Text("Answer generating")
            }
            textArea(.constant(answer))
            Divider()
            Button{
                if let signal = currentTask {
                    signal.store(true, ordering: .relaxed)
                } else {
                    state.update(state: .Init)
                }
            } label: {
                Image(systemName: "stop.circle")
            }
            Spacer()
        }
    }

    func resultPage(query:String, answer: String) -> some View {
        VStack {
            Spacer().frame(maxHeight: 10)
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Input posted")
            }
            textArea(.constant(query))
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Answer generated")
            }
            textArea(.constant(answer))
            Divider()
            homeButton()
            Spacer().frame(maxHeight: 10)
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
            refineInput = query
            if let key = getAPIKey() {
                refine(key: key)
            } else {
            }
            return
        case .some("ask"):
            askInput = query
            if let key = getAPIKey() {
                ask(key: key)
            } else {
            }
            return
        case _:
            ()

        }
    }

    var body: some View {
        let width: CGFloat = switch state.state {
        case .Init:
            200
        case _:
            400
        }
        VStack{
            if let url = urlState.url {
                let _ = DispatchQueue.main.async {
                    urlState.update(url: nil)
                    handleURL(url: url)
                }
                Text("Received deeplink")
            } else {
                switch (apiKey, state.state) {
                case (_, .Error(let s)):
                    errorPage(s: s)
                case (_, .Init):
                    AppMenu(state: state, deleteAPIKeyAction: deleteAPIKeyAction, quit: quit)
                case (.none, _):
                    readAPIKeyPage()
                case (.some(let key), .Ask):
                    askPage(key: key)
                case (.some(let key), .Refine):
                    refinePage(key: key)
                case (_, .Busy(let query, let answer)):
                    busyPage(query: query, answer: answer)
                case (_, .Result(let query, let answer)):
                    resultPage(query: query, answer: answer)
                }
            }
        }.frame(width: width)
    }
}
