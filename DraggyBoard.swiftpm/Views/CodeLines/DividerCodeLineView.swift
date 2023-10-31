//
//  DividerCodeLineView.swift
//
//
//  Created by Daniel on 2023-10-30.
//

import SwiftUI

@available(iOS 16, *)
struct DividerCodeLineView: View {

    @ObservedObject var dividerNode: DividerNode
    let indentLevel: Int

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @State private var spacerOpacity = 0.0
    @State private var showBraces = false
    @State private var spacerSpacing: CGFloat = 90

    var body: some View {
        VStack(alignment: .leading) {
            mainCodeLine
            if nodeTracker.isSelected(node: dividerNode) {
                ExplanationView(explanation: dividerNode.nodeType.explanation)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 1)) {
                    spacerOpacity = 1.0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    spacerSpacing = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showBraces = true
                }
            }
        }
    }

    private var mainCodeLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: indentLevel * 4))
                .fixedSize()
            HStack(spacing: spacerSpacing) {
                Text("Div")
                if showBraces {
                    Text("i")
                        .transition(.scale.combined(with: .opacity))
                } else {
                    Text("|")
                        .fontWeight(.semibold)
                        .transition(.scale.combined(with: .opacity))
                }
                Text("der")
            }
            .foregroundColor(colorScheme.codeColors.typeName)
            .opacity(spacerOpacity)
            .onTapGesture {
                nodeTracker.toggleSelection(node: dividerNode)
                codeScroller.scroll(to: dividerNode)
            }
            if showBraces {
                Text("()")
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .blur(radius: nodeTracker.blur(for: dividerNode))
    }
}

@available(iOS 16.0, *)
#Preview {
    DividerCodeLineView(dividerNode: DividerNode(), indentLevel: 0)
}
