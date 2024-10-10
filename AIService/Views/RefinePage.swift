//
//  RefinePage.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-10.
//
import SwiftUI

struct RefinePage : View {
    @State var input = ""
    var refine : ((String) -> ())

    var body : some View {
        FloatTextArea("Text to refine", text: $input){ arg in refine(arg)}
    }
}
