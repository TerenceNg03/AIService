//
//  Markdown.swift
//  AIService
//
//  Created by Terence Ng on 2024-10-08.
//

import SwiftUI
import Foundation

func markdown(_ text: String) -> AttributedString{
    do {
        var output =  try AttributedString(
            markdown: text,
            options: .init(
                allowsExtendedAttributes: false,
                interpretedSyntax: .full,
                failurePolicy: .returnPartiallyParsedIfPossible
            )
        )
        for (intentBlock, intentRange) in output.runs[AttributeScopes.FoundationAttributes.PresentationIntentAttribute.self].reversed() {
            guard let intentBlock = intentBlock else { continue }
            for intent in intentBlock.components {
                switch intent.kind {
                case .header(level: let level):
                    switch level {
                    case 1:
                        output[intentRange].font = .system(.title).bold()
                    case _:
                        output[intentRange].font = .system(.title2).bold()
                    }
                case .unorderedList:
                    output.characters.insert(contentsOf: "    • ", at: intentRange.lowerBound)
                case .codeBlock(_):
                    output[intentRange].font =
                        .monospaced(.system(.body))()
                    output.characters.insert(contentsOf: "\n", at: intentRange.lowerBound)
                default:
                    break
                }
            }

            if intentRange.lowerBound != output.startIndex {
                output.characters.insert(contentsOf: "\n", at: intentRange.lowerBound)
            }
        }
        return output

    } catch {
        return AttributedString(text)
    }
}

func Markdown(_ text: String) -> some View {
    let attrS = markdown(text)
    return ScrollView(.vertical, showsIndicators: false){
            Text(attrS)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.title3)
                .background(.clear)
    }
    .textSelection(.enabled)
    .padding(.leading, 5)
    .padding()
    .background(VisualEffectView())
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .frame(maxHeight: 700)
    .fixedSize(horizontal: false, vertical: true)
}

#Preview{
    let text = """
      **Bold**
      This will render "Node A" in bold.
      # Title 1
      ## Title 2
      ### Summary
      - Use the `label` attribute to specify the name of a node.  
      - If no `label` is provided, the node name will be used as the label. loooooooooooooooog loo oo o ooo ooog
      - You can use HTML-like labels for more complex formatting. [abc](abc.com)
      
      ```bash
      $ ls -a
      Application Folder2
      ```
      asdsa
      """
    Markdown(text)
        .frame(maxWidth: 400)
}
