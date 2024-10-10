//
//  FloatWrapper.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-10.
//
import SwiftUI

func FloatWrapper(_ v: () -> some View) -> some View {
    v()
        .frame(maxWidth: .infinity)
        .padding()
        .background(VisualEffectView())
        .clipShape(RoundedRectangle(cornerRadius: 15))
}
