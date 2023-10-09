import SwiftUI

class ListNode: ContainerNode {
    
    init(subNodes: [Node]?) {
        super.init(nodeType: .list, subNodes: subNodes)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))List {
\(innerCode)
\(indentation(indentLevel))}
"""
        return result
    }
}
