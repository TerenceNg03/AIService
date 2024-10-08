//
//  AppMenu.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-08.
//

import SwiftUI

struct AppMenu: View{

    @ObservedObject var state : AppState

    var deleteAPIKeyAction: () -> ();
    var quit : () -> ();

    var body: some View {
        VStack(spacing: 0){
            AppMenuText(text: "API Key")
            AppMenuButton(label: "Delete API Key", action: deleteAPIKeyAction)
            Divider().padding([.top, .bottom], 5)
                .padding([.trailing, .leading], 8)
            AppMenuText(text: "Function")
            AppMenuButton(label: "Ask AI") {
                state.update(state: .Ask)
            }
            AppMenuButton(label: "Refine Text"){
                state.update(state: .Refine)
            }
            Divider().padding([.top, .bottom], 5)
                .padding([.trailing, .leading], 8)
            AppMenuButton(label: "Quit"){
                quit()
            }
        }.padding(5)
    }
}

#Preview {
    AppMenu(state: AppState(), deleteAPIKeyAction: {() -> () in ()}, quit: {() -> () in ()})
}
