import Charts
import SwiftUI

/**
 This file takes in a root node for a tree, and returns a SwiftUI view with subviews for each node in the tree
 */

@available(iOS 16, *)
struct TreePreviewer {
    
    static var nodeTracker: NodeSelectionTracker?
    
    @ViewBuilder
    static func drawContainer(tree: Node) -> some View {
        if let containerNode = tree as? HStackNode {
            drawHStack(containing: containerNode.subNodes ?? [])
        } else if let containerNode = tree as? VStackNode {
            drawVStack(containing: containerNode.subNodes ?? [])
        } else if let containerNode = tree as? ZStackNode {
            drawZStack(containing: containerNode.subNodes ?? [])
        } else if let pickerNode = tree as? PickerNode {
            drawPicker(containing: pickerNode.subNodes ?? [], pickerNode: pickerNode)
        } else if let listNode = tree as? ListNode {
            drawList(containing: listNode.subNodes ?? [], listNode: listNode)
        } else if let buttonNode = tree as? ButtonNode {
            drawButton(containing: buttonNode.subNodes ?? [], buttonNode: buttonNode)
        }
    }
    
    private static func drawHStack(containing subNodes: [Node]) -> some View {
        HStack {
            ForEach(subNodes) { subNode in
                draw(tree: subNode)
            }
        }
    }
    
    private static func drawVStack(containing subNodes: [Node]) -> some View {
        VStack {
            ForEach(subNodes) { subNode in
                draw(tree: subNode)
            }
        }
    }
    
    private static func drawZStack(containing subNodes: [Node]) -> some View {
        ZStack {
            ForEach(subNodes) { subNode in
                draw(tree: subNode)
            }
        }
    }

    private static func drawPicker(containing subNodes: [Node], pickerNode: PickerNode) -> some View {
        Picker(selection: pickerNode.selectedIDBinding) {
            ForEach(subNodes) { subNode in
                draw(tree: subNode)
                    .tag(subNode.id)
            }
        } label: {
            
        }
        .pickerStyle(InlinePickerStyle())
    }
    
    private static func drawList(containing subNodes: [Node], listNode: ListNode) -> some View {
        List {
            ForEach(subNodes) { subNode in
                draw(tree: subNode)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private static func drawButton(containing subNodes: [Node], buttonNode: ButtonNode) -> some View {
        Button {
            if buttonNode.disableAction {
                return
            }

            // Allow the user to tap the button first so they can see it highlight, then select it
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                nodeTracker?.select(node: buttonNode)
            }
        } label: {
            // For now assume a button has a single subnode (i.e. an HStack or a VStack - these can contain additional nodes)
            draw(tree: subNodes.first!)
        }
    }
    
    private static func draw(tree: Node) -> some View {
        PreviewSubview(tree: tree)
            .id(UUID()) // This is needed to make the Chart redraw
    }
}
