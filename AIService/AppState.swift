//
//  AppState.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//


import SwiftUI

enum AppStateD {
    case Init
    case Ask
    case Refine
    case Busy(String, String)
    case Result(String, String)
    case Error(String)
}

@MainActor
class AppState: ObservableObject {

    @Published var state: AppStateD = .Init;

    func update(state: AppStateD) {
        DispatchQueue.main.async{
            self.state = state
        }
    }
}

