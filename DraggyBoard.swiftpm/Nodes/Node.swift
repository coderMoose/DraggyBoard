import Foundation

/**
 This is the base class for all nodes in the tree. The key is that subNodes are marked as @Published.
 This means that when new nodes are added or removed, the preview (top right) and the code view (bottom right) will both automatically regenerate.
 */

class Node: ObservableObject, Identifiable {
    let id = UUID()
    let nodeType: NodeType
    @Published var subNodes: [Node]?
    var parentNode: Node?

    init(nodeType: NodeType, subNodes: [Node]?) {
        self.subNodes = subNodes
        self.nodeType = nodeType
    }
    
    var isMovable: Bool {
        (parentNode?.subNodes ?? []).count >= 2
    }
    
    var hasAtLeastTwoSubNodes: Bool {
        (subNodes ?? []).count >= 2
    }
    
    var isInsideButton: Bool {
        var currentNode: Node? = self
        while currentNode != nil {
            if currentNode is ButtonNode {
                return true
            }
            currentNode = currentNode?.parentNode
        }
        return false
    }
    
    func moveDown() {
        parentNode?.moveDownNode(matching: id)
    }
    
    func moveUp() {
        parentNode?.moveUpNode(matching: id)
    }
    
    func delete() {
        parentNode?.deleteSubNode(matching: id)
    }
    
    func asCode(indentLevel: Int = 0) -> String {
        guard let containerNode = self as? ContainerNode else {
            return "Must have a container node as the root"
        }
        let codeForThisNode = containerNode.asCode(indentLevel: 2)
        let codeForTheView =
"""
import SwiftUI

struct ContentView {

    var body: some View {
        \(codeForThisNode)
    }
}
"""
        return codeForTheView
    }
    
    func indentation(_ indentLevel: Int = 0) -> String {
        "\(String(repeating: " ", count: indentLevel * 4))"
    }
    
    func redrawEverything() {
        objectWillChange.send()
    }
    
    private func deleteSubNode(matching id: UUID) {
        subNodes?.removeAll { node in
            node.id == id
        }
    }
    
    private func moveDownNode(matching id: UUID) {
        guard let subNodes = subNodes else {
            return
        }
        guard let index = subNodes.firstIndex(where: { $0.id == id } ) else {
            return
        }
        // Need at least 2 nodes to do a move.
        // Also, if already at last index, then we can't move it down
        guard index < subNodes.count - 1, subNodes.count >= 2 else {
            return
        }
        self.subNodes?.swapAt(index, index + 1)
    }
    
    private func moveUpNode(matching id: UUID) {
        guard let subNodes = subNodes else {
            return
        }
        guard let index = subNodes.firstIndex(where: { $0.id == id } ) else {
            return
        }
        // Need at least 2 nodes to do a move.
        // Also, if already at index 0, then we can't move it up
        guard index >= 1, subNodes.count >= 2 else {
            return
        }
        self.subNodes?.swapAt(index, index - 1)
    }
}
