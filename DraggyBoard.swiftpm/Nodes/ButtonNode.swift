import Foundation

class ButtonNode: ContainerNode {
    
    let disableAction: Bool
    
    init(subNodes: [Node]?, disableAction: Bool = false) {
        self.disableAction = disableAction
        super.init(nodeType: .button, subNodes: subNodes)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))Button {
\(indentation(indentLevel))    // Write Swift code here to run when tapped
\(indentation(indentLevel))} label: {
\(innerCode)
\(indentation(indentLevel))}
"""
        return result
    }
}
