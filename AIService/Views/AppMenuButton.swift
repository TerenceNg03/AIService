//
//  AppMenuButton.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-08.
//


import SwiftUI

struct AppMenuButton : View {
    var label: String
    var action : () -> ()
    @State var hovered: Bool = false;
    var body : some View {
        Button{
            action()
        } label: {
            Text(label)
                .padding(.leading, 9)
                .padding(.all, 3)
                .contentMargins(0)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(MenuButtonStyle(hovered: $hovered))
            .onHover{ b in hovered = b}
    }
}

struct MenuButtonStyle: ButtonStyle {
    typealias Body = Button
    @Binding var hovered : Bool

    func makeBody(configuration: Self.Configuration)
    -> some View {
        if hovered {
            return configuration
                .label
                .background(.blue.opacity(0.8))
                .foregroundColor(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        } else {
            return configuration
                .label
                .background(.clear)
                .foregroundColor(.black)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
}

#Preview {
    VStack(spacing: 0){
        Spacer()
        AppMenuButton(label: "Click me"){
            ()
        }
        AppMenuButton(label: "Click me"){
            ()
        }
        Spacer()
    }
}
