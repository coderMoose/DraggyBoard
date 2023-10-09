import SwiftUI

struct TreeItemView: View {
    
    @ObservedObject var node: Node
    let redrawEverything: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: node.nodeType.systemImageName)
                .imageScale(.small)
            nodeDescription
        }
    }
    
    @ViewBuilder
    private var nodeDescription: some View {
        switch node.nodeType {
        case .app, .image, .button, .hStack, .vStack, .zStack, .spacer, .picker, .list:
            Text(node.nodeType.capitalizedName)
        case .text:
            TextFieldView(textNode: node as! TextNode, redrawEverything: redrawEverything)
        }
    }
}

private struct TextFieldView: View {
    @ObservedObject var textNode: TextNode
    let redrawEverything: () -> Void
    
    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    
    var body: some View {
        TextField("test", text: $textNode.displayText.animation()) { receivedFocus in
            if receivedFocus {
                nodeTracker.select(node: textNode)
            }
        }
        .onChange(of: textNode.displayText) { newValue in
            redrawEverything()
        }
    }
}

struct TreeItemView_Previews: PreviewProvider {
    static var previews: some View {
        TreeItemView(node: TextNode(displayText: "123"), redrawEverything: { })
    }
}
