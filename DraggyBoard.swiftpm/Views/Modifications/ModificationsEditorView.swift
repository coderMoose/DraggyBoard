import SwiftUI

@available(iOS 16, *)
struct ModificationsEditorView: View {
    
    @ObservedObject var node: Node
    @Binding var modificationsEditorHasAppeared: Bool
    let redrawEverything: () -> Void

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    
    var body: some View {
        Divider()
        VStack {
            if let textNode = node as? TextNode {
                textModifications(textNode: textNode)
                Divider()
            } else if let systemImageNode = node as? SystemImageNode {
                imageModifications(imageNode: systemImageNode)
                Divider()
            } else if let chartNode = node as? ChartNode {
                if chartNode.isEmpty {
                    Text("This chart is empty - try tapping 'Add BarMark' to add some data.")
                        .padding(.bottom)
                }
            } else if let containerNode = node as? ContainerNode {
                if containerNode.isEmpty {
                    Text("This container is empty - try dragging a Text or Image view here.")
                        .padding(.bottom)
                }
            } else if let barMarkNode = node as? BarMarkNode {
                barMarkModifications(barMarkNode: barMarkNode)
                Divider()
            }
            
            buttons
                .font(.title)
        }
        .padding(.bottom)
        .onAppear {
            withAnimation {
                modificationsEditorHasAppeared = true
            }
        }
    }
    
    @ViewBuilder
    private func textModifications(textNode: TextNode) -> some View {
        TextSizeModificationEditorView(textSizeModification: textNode.textSizeModification,
                                       redrawEverything: redrawEverything)
        TextBoldModificationEditorView(textBoldModification: textNode.textBoldModification,
                                       redrawEverything: redrawEverything)
        TextColorModificationEditorView(textColorModification: textNode.textColorModification,
                                        redrawEverything: redrawEverything)
    }
    
    @ViewBuilder
    private func imageModifications(imageNode: SystemImageNode) -> some View {
        ImageNameModificationEditorView(imageNode: imageNode, redrawEverything: redrawEverything)
        ImageColorModificationEditorView(imageColorModification: imageNode.imageColorModification,
                                        redrawEverything: redrawEverything)
        ImageSizeModificationEditorView(imageSizeModification: imageNode.imageSizeModification,
                                        redrawEverything: redrawEverything)
    }
    
    @ViewBuilder
    private func barMarkModifications(barMarkNode: BarMarkNode) -> some View {
        BarColorModificationEditorView(barColorModification: barMarkNode.barColorModification, redrawEverything: redrawEverything)
    }

    private var buttons: some View {
        VStack(alignment: .leading, spacing: 10) {
            if node.nodeType == .chart {
                button(name: "Add BarMark", imageName: "chart.bar.xaxis", action: addBarMark)
            }
            if node.nodeType.isContainer && node.hasAtLeastTwoSubNodes {
                button(name: "Reverse Items", imageName: "arrow.left.arrow.right", action: reverseItems)
            }
            if node.isMovable {
                button(name: "Move Up", imageName: "arrow.up", action: moveUp)
                button(name: "Move Down", imageName: "arrow.down", action: moveDown)
            }
            button(name: "Delete", imageName: "trash", color: .red, action: deleteMe)
        }
        .font(.title3)
    }
    
    private func addBarMark() {
        withAnimation {
            (node as? ChartNode)?.addBarMark()
            redrawEverything()
        }
    }
    
    private func reverseItems() {
        withAnimation {
            (node as? ContainerNode)?.reverseItems()
            redrawEverything()
        }
    }
    
    private func moveUp() {
        withAnimation {
            node.moveUp()
            redrawEverything()
        }
    }
    
    private func moveDown() {
        withAnimation {
            node.moveDown()
            redrawEverything()
        }
    }
    
    private func deleteMe() {
        withAnimation {
            node.delete()
            if let firstSubNode = node.parentNode?.subNodes?.first {
                nodeTracker.select(node: firstSubNode)
            } else {
                nodeTracker.selectedNodeId = nil
            }
            redrawEverything()
        }
    }
    
    private func button(name: String, imageName: String, color: Color = .blue, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                Text(name)
                    .font(.title2)
                Spacer()
                Image(systemName: imageName)
            }
        }
        // Found the solution to allowing a button to be tapped inside a list using this website:
        // https://www.hackingwithswift.com/forums/swiftui/is-it-possible-to-have-a-button-action-in-a-list-foreach-view/1153
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(color)
    }
}

@available(iOS 16, *)
struct ModificationsEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ModificationsEditorView(node: TextNode(displayText: "123"), modificationsEditorHasAppeared: .constant(false)) {
            
        }
    }
}
