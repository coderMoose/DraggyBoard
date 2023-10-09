import SwiftUI

/**
 This class gets attached to the view as an environment object. This means that any time a view gets selected or inserted, it's easy to scroll to that view.
 This class publishes a change, and the ScrollViewReader in RootCodeLinesView listens for it and scrolls to the correct view.
 */

class CodeScroller: ObservableObject {
    
    @Published var currentCodeNodeId: UUID?
    
    func scroll(to node: Node) {
        withAnimation {
            currentCodeNodeId = node.id
        }
    }
}
