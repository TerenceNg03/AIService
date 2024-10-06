//
//  DeepSeek.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//
import Foundation
import SwiftUI
import EventSource
import Atomics

enum Either<L, R> {
    case left(L)
    case right(R)
}

struct ChatResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let delta: Delta
}

struct Delta: Codable {
    let content: String
}

struct DeepSeekAPIHandler {
    @ObservedObject var state : AppState
    var stop : ManagedAtomic<Bool>

    func toRequest(apiKey:String, s: String) -> URLRequest? {
        let url = URL(string: "https://api.deepseek.com/chat/completions")!
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let body: [String: Any] = [
            "model": "deepseek-chat",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": s]
            ],
            "stream": true
        ]
        do
        {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            return request
        }catch{
            return nil
        }
    }

    func callDeepSeekAPI(apiKey:String, s: String, displayInput: String) async {
        let eventSource = EventSource()
        guard let request = toRequest(apiKey: apiKey, s: s)else {
            return
        }

        let dataTask = eventSource.dataTask(for: request)
        var answer = ""

        for await event in dataTask.events() {
            if stop.load(ordering: .relaxed) {
                state.update(state: .Result(displayInput, answer))
                return
            }
            switch event {
            case .open:
                ()
            case .error(let error):
                state.update(state: .Error("\(error)"))
                return
            case .message(let message):
                if let data = message.data?.data(using: .utf8) {
                    do {
                        let data = try JSONDecoder().decode(ChatResponse.self, from: data)
                        let inc = data.choices.first?.delta.content ?? ""
                        answer.append(inc)
                        state.update(state: .Busy(displayInput, answer))
                    } catch {}
                }
            case .closed:
                state.update(state: .Result(displayInput, answer))
                return
            }
        }
        state.update(state: .Result(displayInput, answer))
    }
}
