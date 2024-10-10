//
//  VisualEffectView.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-09.
//


import SwiftUI

struct VisualEffectView: NSViewRepresentable
{
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
    }
}
