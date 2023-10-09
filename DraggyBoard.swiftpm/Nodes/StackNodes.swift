import Foundation

class HStackNode: ContainerNode {
    
    init(subNodes: [Node]?) {
        super.init(nodeType: .hStack, subNodes: subNodes)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))HStack {
\(innerCode)
\(indentation(indentLevel))}
"""
        return result
    }
}

class VStackNode: ContainerNode {
    
    init(subNodes: [Node]?) {
        super.init(nodeType: .vStack, subNodes: subNodes)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))VStack {
\(innerCode)
\(indentation(indentLevel))}
"""
        return result
    }
}

class ZStackNode: ContainerNode {
    
    init(subNodes: [Node]?) {
        super.init(nodeType: .zStack, subNodes: subNodes)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))ZStack {
\(innerCode)
\(indentation(indentLevel))}
"""
        return result
    }
}
