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
            FloatTextArea("", text: .constant(answer), action: {(_) in ()})
        }.background(.clear)
    }
}

#Preview {
    ResultPage(query: .constant("Hello"), answer: .constant("Hello2"))
}
