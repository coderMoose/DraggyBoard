import Charts
import SwiftUI

@available(iOS 16, *)
struct PreviewSubview: View {
    
    @ObservedObject var tree: Node

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    
    var body: some View {
        viewForNodeType
            .id(tree.id)
            .padding(nodeTracker.isSelected(node: tree) ? 2 : 0)
            .border(Color.secondary, width: nodeTracker.isSelected(node: tree) ? 2 : 0)
    }
    
    @ViewBuilder
    private var viewForNodeType: some View {
        if let containerNode = tree as? ContainerNode {
            // AnyView seems to fix a compiler hang, without it the app never builds
            // I don't really understand why it works this way, but maybe it changes the type
            // and that's what gets the compiler unstuck?
            AnyView(TreePreviewer.drawContainer(tree: containerNode))
        } else if let textNode = tree as? TextNode {
            if textNode.isInsideButton {
                previewTextView(textNode: textNode)
            } else {
                previewTextView(textNode: textNode)
                    .onTapGesture {
                        nodeTracker.toggleSelection(node: tree)
                    }
            }

        } else if let imageNode = tree as? SystemImageNode {
            if imageNode.isInsideButton {
                previewImageView(imageNode: imageNode)
            } else {
                previewImageView(imageNode: imageNode)
                    .onTapGesture {
                        nodeTracker.toggleSelection(node: tree)
                    }
            }

        } else if tree is SpacerNode {
            if tree.isInsideButton {
                Spacer()
            } else {
                Spacer()
                    .onTapGesture {
                        nodeTracker.toggleSelection(node: tree)
                    }
            }
        }
    }
    
    private func previewTextView(textNode: TextNode) -> some View {
        PreviewTextView(textNode: textNode,
                        textSizeModification: textNode.textSizeModification,
                        textBoldModification: textNode.textBoldModification,
                        textColorModification: textNode.textColorModification)
    }
    
    private func previewImageView(imageNode: SystemImageNode) -> some View {
        PreviewImageView(imageNode: imageNode,
                         imageSizeModification: imageNode.imageSizeModification,
                         imageColorModification: imageNode.imageColorModification)
    }
}

@available(iOS 16, *)
private struct PreviewTextView: View {
    
    @ObservedObject var textNode: TextNode
    @ObservedObject var textSizeModification: TextSizeModification
    @ObservedObject var textBoldModification: TextBoldModification
    @ObservedObject var textColorModification: TextColorModification

    var body: some View {
        Text(textNode.displayText)
            .font(textSizeModification.selectedTextSize.font)
            .bold(textBoldModification.isBold)
            .foregroundColor(textColorModification.textColor.color)
    }
}

@available(iOS 16, *)
private struct PreviewImageView: View {
    
    @ObservedObject var imageNode: SystemImageNode
    @ObservedObject var imageSizeModification: ImageSizeModification
    @ObservedObject var imageColorModification: ImageColorModification

    var body: some View {
        Image(systemName: imageNode.systemImageName)
            .resizable()
            .frame(width: imageSizeModification.imageSize,
                   height: imageSizeModification.imageSize)
            .foregroundColor(imageColorModification.imageColor.color)
    }
}

@available(iOS 16, *)
struct PreviewBarMark: ChartContent {

    @ObservedObject var barMarkNode: BarMarkNode
    @ObservedObject var barColorModification: BarColorModification

    var body: some ChartContent {
        BarMark(x: .value("Type", barMarkNode.label),
                y: .value("Value", barMarkNode.value))
            .foregroundStyle(barColorModification.barColor.color)
    }
}

@available(iOS 16, *)
struct PreviewSubview_Previews: PreviewProvider {
    static var previews: some View {
        PreviewSubview(tree: TextNode(displayText: "123"))
    }
}
