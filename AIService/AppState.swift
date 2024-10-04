//
//  AppState.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//


import SwiftUI

class AppState: ObservableObject {
    enum AppState {
        case Init
        case Busy
        case Result(String, String)
        case Error(String)
    }


    @Published var state: AppState = .Init;

    func update(state: AppState) {
        self.state = state
    }
}
