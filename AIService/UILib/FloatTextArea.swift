//
//  FloatTextArea.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-09.
//

import SwiftUI
import TextEditorPlus

struct FloatTextArea: View{
    var placeholder : String
    var input : Binding<String>
    var action: ((String) -> ())

    init(_ placeholder: String, text: Binding<String>, action: @escaping ((String) -> ())){
        self.placeholder = placeholder
        self.input = text
        self.action = action
    }

    var body : some View {
        ZStack(alignment: .topLeading) {
            if input.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.title3)
                    .background(.clear)
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.leading, 5)
            }
            TextEditor(text: input)
                .font(.title3)
                .onKeyPress{ press in
                    if (press.key == KeyEquivalent.return && !press.modifiers.contains(EventModifiers.shift)) {
                        action(input.wrappedValue)
                        return .handled
                    }
                    return .ignored
                }
                .scrollContentBackground(.hidden)
        }
        .padding()
        .background(VisualEffectView())
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .frame(maxHeight: 800)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    FloatTextArea("", text: .constant("Text"), action: {(_) in ()})
}
