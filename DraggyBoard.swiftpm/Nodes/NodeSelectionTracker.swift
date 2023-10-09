import SwiftUI

class NodeSelectionTracker: ObservableObject {

    @Published var selectedNodeId: UUID?

    func select(node: Node) {
        withAnimation {
            selectedNodeId = node.id
        }
    }
    
    func deselectAnthingThatIsSelected() {
        withAnimation {
            selectedNodeId = nil
        }
        hideKeyboard()
    }
    
    func hideKeyboard() {
        // Hide the keyboard - this is a combination of code from these two websites:
        // https://www.swiftanytime.com/blog/how-to-dismiss-keyboard-in-swiftui
        // https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.endEditing(true)
    }
    
    func isSelected(node: Node) -> Bool {
        selectedNodeId == node.id
    }
    
    func toggleSelection(node: Node) {
        withAnimation {
            if isSelected(node: node) {
                deselectAnthingThatIsSelected()
            } else {
                select(node: node)
            }
        }
    }
    
    func blur(for node: Node) -> Double {
        if selectedNodeId == node.id {
            return 0
        }
        return blurForNonNode()
    }
    
    func blurForNonNode() -> Double {
        if selectedNodeId == nil {
            return 0
        }
        return 6.0
    }
    
    func opacityForNonNode() -> Double {
        if selectedNodeId == nil {
            return 1.0
        }
        return 0.3
    }
}
