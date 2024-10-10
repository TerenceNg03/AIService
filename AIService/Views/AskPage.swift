//
//  AskPage.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-10.
//

import SwiftUI
import AppKit
import Atomics

struct AskPage : View {
    @State var input = ""
    var ask : ((String) -> ())

    var body : some View {
        FloatTextArea("Ask DeepSeek anything", text: $input){ arg in ask(arg)}
    }
}

#Preview {
    AskPage(ask: {_ in ()})
}
