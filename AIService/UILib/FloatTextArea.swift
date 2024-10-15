//
//  FloatTextArea.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-09.
//

import SwiftUI

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
        ScrollView(.vertical, showsIndicators: false){
            ZStack(alignment: .topLeading) {
                if input.wrappedValue.isEmpty {
                    Text(placeholder)
                        .font(.title3)
                        .background(.clear)
                        .foregroundColor(.primary.opacity(0.7))
                        .padding(.leading, 5)
                }
                TextEditor(text: input)
                    .scrollDisabled(true)
                    .font(.title3)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .onKeyPress{ press in
                        if (press.key == KeyEquivalent.return && !press.modifiers.contains(EventModifiers.shift)) {
                            action(input.wrappedValue)
                            return .handled
                        }
                        return .ignored
                    }
            }
        }
        .padding()
        .background(VisualEffectView())
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxHeight: 400)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview {
    FloatTextArea("Placeholder", text: .constant(""), action: {(_) in ()})
}
