//
//  AppMenuText.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-08.
//

import SwiftUI

struct AppMenuText : View {
    var text: String
    var body: some View {
        HStack {
            Text(text)
                .foregroundStyle(.black.opacity(0.5))
                .font(.caption)
                .bold()
                .padding(.leading, 8)
                .padding(4)
            Spacer()
        }
    }
}
