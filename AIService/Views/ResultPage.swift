//
//  ResultPage.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-10.
//
import SwiftUI

struct ResultPage : View {
    @Binding var query : String
    @Binding var answer : String

    var body : some View {
        VStack{
            FloatTextArea("", text: .constant(query), action: {(_) in ()})
            Markdown(answer)
        }.background(.clear)
    }
}

#Preview {
    ResultPage(query: .constant("Hello"), answer: .constant("Strange things tend to happen when people are the most unprepared."))
        .frame(maxWidth: 400)
}
