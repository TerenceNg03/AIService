//
//  AppState.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-04.
//


import SwiftUI

enum AppStateD {
    case Ask
    case Refine
    case Busy(String, String)
    case Result(String, String)
    case Error(String)
}

@MainActor
class AppState : ObservableObject {
    @Published var v : AppStateD = .Ask

    func set(_ v: AppStateD){
        DispatchQueue.main.async{
            self.v = v
        }
    }
}

@MainActor
class URLState: ObservableObject {

    @Published var url : URL? = nil;

    func update(url: URL?) {
        DispatchQueue.main.async{
            self.url = url
        }
    }
}
