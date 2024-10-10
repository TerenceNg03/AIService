//
//  ReadAPIKey.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-10.
//
import SwiftUI

struct ReadAPIKey : View {
    @State var input = ""
    @State var action : (String) -> ()

    var body : some View {
        FloatTextArea("Enter your DeepSeek api key", text: $input, action: action)
    }
}

