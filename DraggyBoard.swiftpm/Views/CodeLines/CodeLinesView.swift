import SwiftUI

@available(iOS 16, *)
struct CodeLinesView: View {
    
    let nodes: [Node]
    let indentLevel: Int
    //import SwiftUI
//    
//    struct ContentView: View {
//        
//        var body: some View {
//            VStack {
//                Text("Hello World")
//                Text("Hello World")
//                HStack {
//                    Text("Hello World")
//                    Text("Hello World")
//                }
//            }
//        }
//    }
    var body: some View {
        ForEach(nodes) { node in
            switch node.nodeType {
            case .app:
                EmptyView()
            case .hStack, .vStack, .zStack, .picker, .list, .chart:
                ContainerNodeCodeLineView(containerNode: node as! ContainerNode,
                                          indentLevel: indentLevel)
                    .id(node.id)
            case .image:
                SystemImageCodeLineView(systemImageNode: node as! SystemImageNode,
                                        indentLevel: indentLevel)
                    .transition(.scale.combined(with: .opacity))
                    .id(node.id)
            case .text:
                TextCodeLineView(textNode: node as! TextNode,
                                 indentLevel: indentLevel)
                    .transition(.scale.combined(with: .opacity))
                    .id(node.id)
            case .spacer:
                SpacerCodeLineView(spacerNode: node as! SpacerNode,
                                   indentLevel: indentLevel)
                .id(node.id)
            case .button:
                ButtonCodeLineView(buttonNode: node as! ButtonNode,
                                   indentLevel: indentLevel)
            case .barMark:
                BarMarkCodeLineView(barMarkNode: node as! BarMarkNode, 
                                    indentLevel: indentLevel)
            case .divider:
                DividerCodeLineView(dividerNode: node as! DividerNode,
                                    indentLevel: indentLevel)
            }
        }
    }
}

@available(iOS 16, *)
struct CodeLinesView_Previews: PreviewProvider {
    static var previews: some View {
        CodeLinesView(nodes: [], indentLevel: 0)
    }
}
