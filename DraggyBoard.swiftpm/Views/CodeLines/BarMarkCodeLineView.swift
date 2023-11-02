//
//  BarMarkCodeLineView.swift
//  
//
//  Created by Daniel on 2023-10-31.
//

import SwiftUI

/*
 Generates code that looks like this:
 
 BarMark(x: .value("Label", "Dogs"), y: .value("Value", 20))
     .foregroundStyle(.blue)
 */

@available(iOS 16, *)
struct BarMarkCodeLineView: View {
    
    @ObservedObject var barMarkNode: BarMarkNode
    let indentLevel: Int
    
    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    @State private var showTextName = false
    @State private var showTextLabel = false
    @State private var showTextValue = false
    @State private var showQuotes = false
    @State private var showForegroundColor = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: indentLevel * 4))
                    .fixedSize()
                if showTextName {
                    HStack(spacing: 0) {
                        Text("BarMark")
                            .foregroundColor(colorScheme.codeColors.typeName)
                        Text("(")
                    }
                    .transition(.scale.combined(with: .opacity))
                    .onTapGesture {
                        nodeTracker.toggleSelection(node: barMarkNode)
                        codeScroller.scroll(to: barMarkNode)
                    }
                }
                barMarkParameter(label: "x")
                quotationMark
                if showTextLabel {
                    Text(barMarkNode.label)
                        .foregroundColor(colorScheme.codeColors.string)
                        .transition(.scale.combined(with: .opacity))
                }
                quotationMark
                if showTextName {
                    Text("), ")
                        .transition(.scale.combined(with: .opacity))
                }
            }
            secondLineParameter
            if nodeTracker.isSelected(node: barMarkNode) {
                ExplanationView(explanation: barMarkNode.nodeType.explanation)
            }
            if showForegroundColor {
                BarMarkColorCodeLineView(barColorModification: barMarkNode.barColorModification,
                                         indentLevel: indentLevel)
            }
        }
        .blur(radius: nodeTracker.blur(for: barMarkNode))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    showTextName = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showTextValue = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation {
                    showQuotes = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation {
                    showTextLabel = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation {
                    showForegroundColor = true
                }
            }
        }
    }
    
    private var secondLineParameter: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: indentLevel * 4 + 8))
                .fixedSize()
            barMarkParameter(label: "y")
            if showTextValue {
                Text(String(barMarkNode.value))
                Text("))")
            }
        }
    }
    
    @ViewBuilder
    private func barMarkParameter(label: String) -> some View {
        if showTextValue {
            Text(label)
                .foregroundColor(colorScheme.codeColors.typeName)
            Text(": .")
            Text("value")
                .foregroundColor(colorScheme.codeColors.typeName)
            Text("(")
        }
        quotationMark
        if showTextValue {
            Text(label)
                .foregroundColor(colorScheme.codeColors.string)
                .transition(.scale.combined(with: .opacity))
        }
        quotationMark
        if showQuotes {
            Text(", ")
        }
    }
    
    @ViewBuilder
    private var quotationMark: some View {
        if showQuotes {
            Text("\"")
                .foregroundColor(colorScheme.codeColors.string)
                .transition(.scale.combined(with: .opacity))
        }
    }
}

@available(iOS 16, *)
private struct BarMarkColorCodeLineView: View {
    
    @ObservedObject var barColorModification: BarColorModification
    let indentLevel: Int
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        if barColorModification.barColor != .primary {
            modificationLine
                .transition(.scale.combined(with: .opacity))
        }
    }
    
    private var modificationLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                .fixedSize()
            Text(".foregroundStyle(")
            HStack(spacing: 0) {
                Text(".")
                Text(barColorModification.barColor.rawValue)
            }
            .fontWeight(.semibold)
            .foregroundColor(colorScheme.codeColors.propertyName)
            .id(UUID())
            .transition(.scale.combined(with: .opacity))
            Text(")")
        }
    }
}

@available(iOS 16.0, *)
#Preview {
    BarMarkCodeLineView(barMarkNode: BarMarkNode(), indentLevel: 1)
}
