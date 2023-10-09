import SwiftUI

@available(iOS 16, *)
struct SpacerCodeLineView: View {

    @ObservedObject var spacerNode: SpacerNode
    let indentLevel: Int
    
    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @State private var spacerOpacity = 0.0
    @State private var showBraces = false
    @State private var spacerSpacing: CGFloat = 60

    var body: some View {
        VStack(alignment: .leading) {
            mainCodeLine
            if nodeTracker.isSelected(node: spacerNode) {
                ExplanationView(explanation: spacerNode.nodeType.explanation)
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
                Text("S")
                Text("p")
                Text("a")
                Text("c")
                Text("e")
                Text("r")
            }
            .foregroundColor(colorScheme.codeColors.typeName)
            .opacity(spacerOpacity)
            .onTapGesture {
                nodeTracker.toggleSelection(node: spacerNode)
                codeScroller.scroll(to: spacerNode)
            }
            if showBraces {
                Text("()")
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .blur(radius: nodeTracker.blur(for: spacerNode))
    }
}

@available(iOS 16, *)
struct SpacerCodeLineView_Previews: PreviewProvider {
    static var previews: some View {
        SpacerCodeLineView(spacerNode: SpacerNode(),
                           indentLevel: 0)
    }
}
