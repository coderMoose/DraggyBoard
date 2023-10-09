import SwiftUI

class PickerNode: ContainerNode {
    
    lazy var selectedIDBinding = Binding<UUID>(
        get: {
            return self.selectedID ?? UUID()
        },
        set: { newValue in
            self.selectedID = newValue
        }
    )

    private var selectedID: UUID?
    
    init(subNodes: [Node]?) {
        super.init(nodeType: .picker, subNodes: subNodes)
    }
    
    // In the future I'd love to have the app support @State variables too, but this was the best I could do in 3 weeks!
    override func asCode(indentLevel: Int = 0) -> String {
        let innerCode = innerCode(indentLevel: indentLevel)
        let result =
"""
\(indentation(indentLevel))Picker(selection: $addAn_@State_VariableAbove) {
\(innerCode)
\(indentation(indentLevel))} label: {

\(indentation(indentLevel))}
"""
        return result
    }
}
