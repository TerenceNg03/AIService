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
    @State var input = "Say something here"
    var quit : () -> ();

    var body: some View {
        switch state.state {
        case .Init:
            TextEditor(text: $input)
                .font(.title3)
                .padding(5)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding()
                .shadow(radius: 5)
            Button(action: {() -> () in
                state.update(state: .Busy)
                DispatchQueue.main.async{
                    Task {
                        let res = await callDeepSeekAPI(s: input)
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
            Button(action: quit, label: { Text("Quit") })
            Spacer()
        case .Busy:
            Spacer()
            HStack {
                Image(systemName: "circle.fill")
                    .symbolEffect(.bounce, options:.repeating)
                    .font(.footnote)
                Text("Waiting for Answer")
            }
            Divider()
            Button(action: {() -> () in state.update(state: .Init)}, label: { Text("Ok") })
            Spacer()
        case.Result(_, let result):
            Spacer()
            HStack {
                Image(systemName: "checkmark.circle")
                Text("Answer from AI:")
            }
            TextEditor(text: .constant(result))
                .textSelection(.enabled)
                .font(.title3)
                .padding(5)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding()
                .shadow(radius: 5)
            Divider()
            Button(action: {() -> () in state.update(state: .Init)}, label: { Text("Ok") })
            Spacer()
        case .Error(let s):
            Spacer()
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                Text("An error occured")
            }
            TextEditor(text: .constant(s))
                .textSelection(.enabled)
                .font(.title3)
                .padding(5)
                .cornerRadius(4)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.gray, lineWidth: 2)
                )
                .padding()
                .shadow(radius: 5)
            Divider()
            Button(action: quit, label: { Text("Quit") })
            Spacer()
        }
    }
}
