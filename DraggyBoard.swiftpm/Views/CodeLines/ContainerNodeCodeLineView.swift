import SwiftUI

@available(iOS 16, *)
struct ContainerNodeCodeLineView: View {
    
    @ObservedObject var containerNode: ContainerNode
    let indentLevel: Int

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker

    @State private var showStackNameView = false
    @State private var showBraces = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                if showStackNameView {
                    StackNameView(name: containerNode.nodeType.capitalizedName,
                                  indentLevel: indentLevel,
                                  node: containerNode)
                        .transition(.scale.animation(.easeInOut))
                }
                if showBraces {
                    Text(" {")
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .blur(radius: nodeTracker.blur(for: containerNode))
            if nodeTracker.isSelected(node: containerNode) {
                ExplanationView(explanation: containerNode.nodeType.explanation)
            }
            CodeLinesView(nodes: containerNode.subNodes ?? [], indentLevel: indentLevel + 1)
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: indentLevel * 4))
                if showBraces {
                    Text("}")
                        .transition(.scale.combined(with: .opacity))
                        .blur(radius: nodeTracker.blur(for: containerNode))
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
struct ContainerNodeCodeLineView_Previews: PreviewProvider {
    static var previews: some View {
        ContainerNodeCodeLineView(containerNode: VStackNode(subNodes: []), indentLevel: 0)
    }
}
