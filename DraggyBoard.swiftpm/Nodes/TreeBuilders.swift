import Foundation

// This was used for testing to make things faster, but is not currently used
func buildBasicTree() -> AppNode {
    AppNode(rootNode:
        VStackNode(subNodes: [
            HStackNode(subNodes: [
                TextNode(displayText: "This is an image"),
                SystemImageNode(systemImageName: "folder")
            ]),
            HStackNode(subNodes: [
                TextNode(displayText: "This is an image"),
                SystemImageNode(systemImageName: "folder")
            ])
        ])
    )
}

func buildBasicVStack() -> AppNode {
    // Don't set parentNode on VStackNode so that user can't delete it
    AppNode(rootNode: VStackNode(subNodes: nil))
}
