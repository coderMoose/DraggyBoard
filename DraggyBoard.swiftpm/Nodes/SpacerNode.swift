import Foundation

class SpacerNode: Node {
    
    init() {
        super.init(nodeType: .spacer, subNodes: nil)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        "\(indentation(indentLevel))Spacer()\")"
    }
}
