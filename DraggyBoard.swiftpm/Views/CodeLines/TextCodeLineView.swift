import SwiftUI

@available(iOS 16, *)
struct TextCodeLineView: View {

    @ObservedObject var textNode: TextNode
    let indentLevel: Int
    
    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @State private var showTextName = false
    @State private var showTextValue = false
    @State private var showQuotes = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: indentLevel * 4))
                    .fixedSize()
                if showTextName {
                    HStack(spacing: 0) {
                        Text("Text")
                            .foregroundColor(colorScheme.codeColors.typeName)
                        Text("(")
                    }
                    .transition(.scale.combined(with: .opacity))
                    .onTapGesture {
                        nodeTracker.toggleSelection(node: textNode)
                        codeScroller.scroll(to: textNode)
                    }
                }
                if showQuotes {
                    Text("\"")
                        .foregroundColor(colorScheme.codeColors.string)
                        .transition(.scale.combined(with: .opacity))
                }
                if showTextValue {
                    Text(textNode.displayText)
                        .foregroundColor(colorScheme.codeColors.string)
                        .transition(.scale.combined(with: .opacity))
                }
                if showQuotes {
                    Text("\"")
                        .foregroundColor(colorScheme.codeColors.string)
                        .transition(.scale.combined(with: .opacity))
                }
                if showTextName {
                    Text(")")
                        .transition(.scale.combined(with: .opacity))
                }
            }
            if nodeTracker.isSelected(node: textNode) {
                ExplanationView(explanation: textNode.nodeType.explanation)
            }
            TextSizeCodeLineView(textSizeModification: textNode.textSizeModification,
                                 indentLevel: indentLevel)
            TextBoldCodeLineView(textBoldModification: textNode.textBoldModification,
                                 indentLevel: indentLevel)
            TextColorCodeLineView(textColorModification: textNode.textColorModification,
                                  indentLevel: indentLevel)
        }
        .blur(radius: nodeTracker.blur(for: textNode))
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                withAnimation {
                    showQuotes = true
                }
            }
        }
    }
}

@available(iOS 16, *)
private struct TextSizeCodeLineView: View {

    @ObservedObject var textSizeModification: TextSizeModification
    let indentLevel: Int

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var body: some View {
        if textSizeModification.selectedTextSize != .body {
            modificationLine
                .transition(.scale.combined(with: .opacity))
        }
    }

    private var modificationLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                .fixedSize()
            Text(".font(")
            HStack(spacing: 0) {
                Text(".")
                Text(textSizeModification.selectedTextSize.name)
            }
            .fontWeight(.semibold)
            .foregroundColor(colorScheme.codeColors.propertyName)
            .id(UUID())
            .transition(.scale.combined(with: .opacity))
            Text(")")
        }
    }
}

@available(iOS 16, *)
private struct TextBoldCodeLineView: View {

    @ObservedObject var textBoldModification: TextBoldModification
    let indentLevel: Int
    
    var body: some View {
        if textBoldModification.isBold {
            modificationLine
                .transition(.scale.combined(with: .opacity))
        }
    }

    private var modificationLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                .fixedSize()
            Text(".bold()")
                .transition(.scale.combined(with: .opacity))
        }
    }
}

@available(iOS 16, *)
private struct TextColorCodeLineView: View {

    @ObservedObject var textColorModification: TextColorModification
    let indentLevel: Int
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        if textColorModification.textColor != .primary {
            modificationLine
                .transition(.scale.combined(with: .opacity))
        }
    }

    private var modificationLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                .fixedSize()
            Text(".foregroundColor(")
            HStack(spacing: 0) {
                Text(".")
                Text(textColorModification.textColor.rawValue)
            }
            .fontWeight(.semibold)
            .foregroundColor(colorScheme.codeColors.propertyName)
            .id(UUID())
            .transition(.scale.combined(with: .opacity))
            Text(")")
        }
    }
}

@available(iOS 16, *)
struct TextCodeLineView_Previews: PreviewProvider {
    static var previews: some View {
        TextCodeLineView(textNode: TextNode(displayText: "123"), indentLevel: 0)
    }
}
