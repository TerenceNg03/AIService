//
//  ErrorPage.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-10.
//
import SwiftUI

struct ErrorPage : View {
    var error: String
    var body: some View {
        FloatWrapper{
            HStack{
                Image(systemName: "exclamationmark.triangle.fill")
                Text("An error occured")
            }
        }
        FloatTextArea("", text: .constant(error)){_ in ()}
        Spacer()
    }
}

#Preview {
    ErrorPage(error: "Some Error")
}
