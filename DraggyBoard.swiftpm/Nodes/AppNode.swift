import Foundation

/**
 This is the root node for the tree. It takes care of adding the extra code needed around the view (for example, "import SwiftUI" etc...)
 */

class AppNode: Node {
    
    init(rootNode: ContainerNode) {
        super.init(nodeType: .app, subNodes: [rootNode])
    }

    var rootContainerNode: ContainerNode {
        subNodes![0] as! ContainerNode
    }

    override func asCode(indentLevel: Int = 0) -> String {
        let codeForThisNode = rootContainerNode.asCode(indentLevel: 2)
        let codeForTheView =
"""
import Charts
import SwiftUI
 
struct ContentView: View {
 
    var body: some View {
\(codeForThisNode)
    }
}
"""
        return codeForTheView
    }
}
