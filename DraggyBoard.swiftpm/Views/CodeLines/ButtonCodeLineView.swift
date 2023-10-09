import SwiftUI

@available(iOS 16, *)
struct ButtonCodeLineView: View {
    
    @ObservedObject var buttonNode: ButtonNode
    let indentLevel: Int

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @State private var showStackNameView = false
    @State private var showBraces = false
    @State private var showComment = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                if showStackNameView {
                    StackNameView(name: buttonNode.nodeType.capitalizedName,
                                  indentLevel: indentLevel,
                                  node: buttonNode)
                        .transition(.scale.animation(.easeInOut))
                }
                if showBraces {
                    Text(" {")
                        .transition(.scale.combined(with: .opacity))
                }
            }
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                if showComment {
                    Text("// Write Swift code here")
                        .foregroundColor(colorScheme.codeColors.commentColor)
                        .transition(.scale.combined(with: .opacity))
                        .blur(radius: nodeTracker.blur(for: buttonNode))
                }
            }
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: indentLevel * 4))
                if showBraces {
                    Text("} label: {")
                        .transition(.scale.combined(with: .opacity))
                        .blur(radius: nodeTracker.blur(for: buttonNode))
                }
            }
            .blur(radius: nodeTracker.blur(for: buttonNode))
            if nodeTracker.isSelected(node: buttonNode) {
                ExplanationView(explanation: buttonNode.nodeType.explanation)
            }
            CodeLinesView(nodes: buttonNode.subNodes ?? [], indentLevel: indentLevel + 1)
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: indentLevel * 4))
                if showBraces {
                    Text("}")
                        .transition(.scale.combined(with: .opacity))
                        .blur(radius: nodeTracker.blur(for: buttonNode))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    showStackNameView = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showBraces = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                withAnimation {
                    showComment = true
                }
            }
        }
    }
}

@available(iOS 16, *)
private struct StackNameView: View {
    
    let name: String
    let indentLevel: Int
    let node: ContainerNode
    
    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var body: some View {
        Text(String(repeating: " ", count: indentLevel * 4))
        Text("\(name)")
            .foregroundColor(colorScheme.codeColors.typeName)
            .onTapGesture {
                nodeTracker.toggleSelection(node: node)
                codeScroller.scroll(to: node)
            }
    }
}

@available(iOS 16, *)
struct ButtonCodeLineView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonCodeLineView(buttonNode: ButtonNode(subNodes: []), indentLevel: 0)
    }
}
