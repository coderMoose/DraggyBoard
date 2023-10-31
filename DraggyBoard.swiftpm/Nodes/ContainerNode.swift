import Foundation

/**
 Some SwiftUI Views can contain other views (for example, HStack/VStack/ZStack/List etc).
 This base class provides a bunch of helpers for working with subviews.
 */

class ContainerNode: Node {
    
    var isEmpty: Bool {
        (subNodes ?? []).isEmpty
    }
    
    var textNodes: [TextNode] {
        (subNodes?.filter {
            $0 is TextNode
        }) as? [TextNode] ?? []
    }
    
    var hStackNodes: [HStackNode] {
        (subNodes?.filter {
            $0 is HStackNode
        }) as? [HStackNode] ?? []
    }
    
    var spacerNodes: [SpacerNode] {
        (subNodes?.filter {
            $0 is SpacerNode
        }) as? [SpacerNode] ?? []
    }

    var imageNodes: [SystemImageNode] {
        (subNodes?.filter {
            $0 is SystemImageNode
        }) as? [SystemImageNode] ?? []
    }
    
    var buttonNodes: [ButtonNode] {
        (subNodes?.filter {
            $0 is ButtonNode
        }) as? [ButtonNode] ?? []
    }
    
    var listNodes: [ListNode] {
        (subNodes?.filter {
            $0 is ListNode
        }) as? [ListNode] ?? []
    }
    
    var chartNodes: [ChartNode] {
        (subNodes?.filter {
            $0 is ChartNode
        }) as? [ChartNode] ?? []
    }
    
    func addNewNode(ofType nodeType: NodeType) -> UUID {
        ensureSubNodesNotNil()
        let newNode: Node
        switch nodeType {
        case .app:
            fatalError("This can only be a root node")
        case .text:
            newNode = TextNode(displayText: "Hello World")
        case .image:
            newNode = SystemImageNode(systemImageName: "bicycle")
        case .button:
            newNode = makeButton()
        case .hStack:
            newNode = HStackNode(subNodes: nil)
        case .vStack:
            newNode = VStackNode(subNodes: nil)
        case .zStack:
            newNode = ZStackNode(subNodes: nil)
        case .spacer:
            newNode = SpacerNode()
        case .picker:
            newNode = makePicker()
        case .list:
            newNode = Self.makeList()
        case .divider:
            newNode = DividerNode()
        case .chart:
            newNode = ChartNode(subNodes: nil)
        case .barMark:
            newNode = BarMarkNode()
        }
        appendAndSetParent(node: newNode)
        return newNode.id
    }

    func reverseItems() {
        subNodes = subNodes?.reversed()
    }

    func innerCode(indentLevel: Int) -> String {
        var innerCode = ""
        let nodes = subNodes ?? []
        for subNode in nodes {
            innerCode += subNode.asCode(indentLevel: indentLevel + 1) + "\n"
        }
        if nodes.count > 0 {
            innerCode = String(innerCode.dropLast(1)) // Remove the extra \n
        } else {
            innerCode = " \n" // without the space the \n doesn't seem to draw
        }
        return innerCode
    }
    
    private func makeButton() -> ButtonNode {
        let starterNodes = [
            SystemImageNode(systemImageName: "checkmark.circle", imageColor: .blue),
            TextNode(displayText: "OK", textColor: .blue)
        ]
        let hStackNode = HStackNode(subNodes: starterNodes)
        let buttonNode = ButtonNode(subNodes: [hStackNode])
        for node in starterNodes {
            node.parentNode = hStackNode
        }
        hStackNode.parentNode = buttonNode
        return buttonNode
    }
    
    private func makePicker() -> PickerNode {
        let starterNodes = [
            TextNode(displayText: "Apple"),
            TextNode(displayText: "Banana"),
            TextNode(displayText: "Orange"),
            TextNode(displayText: "Peach"),
        ]
        let pickerNode = PickerNode(subNodes: starterNodes)
        for node in starterNodes {
            node.parentNode = pickerNode
        }
        return pickerNode
    }
    
    static func makeList() -> ListNode {
        let starterNodes = [
            TextNode(displayText: "Apple"),
            TextNode(displayText: "Banana"),
            TextNode(displayText: "Orange"),
            TextNode(displayText: "Peach"),
        ]
        let listNode = ListNode(subNodes: starterNodes)
        for node in starterNodes {
            node.parentNode = listNode
        }
        return listNode
    }
    
    private func appendAndSetParent(node: Node) {
        node.parentNode = self
        subNodes?.append(node)
    }
    
    private func ensureSubNodesNotNil() {
        if subNodes == nil {
            subNodes = []
        }
    }
}
