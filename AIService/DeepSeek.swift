//
//  DeepSeek.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//
import Foundation

enum Either<L, R> {
    case left(L)
    case right(R)
}

struct ChatResponse: Codable {
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
}

struct Message: Codable {
    let content: String
}


func callDeepSeekAPI(apiKey:String, s: String) async -> Either<String, String>{

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
        "stream": false
    ]

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
            let json = try JSONDecoder().decode(ChatResponse.self, from: data)
            guard let answer = json.choices.first?.message.content else { return .right("Invalid API Response:\n\(json)") }
            return .left(answer)
        } else {
            return .right("Invalid API Response:\n\(response)\n\(data)")
        }
    }catch {
        return .right("\(error)")
    }
}
