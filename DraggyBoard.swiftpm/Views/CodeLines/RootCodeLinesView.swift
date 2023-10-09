import SwiftUI

/**
 When I first started building this, I just used a simple SwiftUI TextEditor to show the code.
 It was a nice start, but I wanted to be able to add colors, and have new lines animate in.
 I didn't know how to do that with a TextEditor, so instead I decided to just stack a bunch
 of Text views together and show the code that way. Since each view is separate, I can
 use different colors and animate in different pieces at different times.
 */

@available(iOS 16, *)
struct RootCodeLinesView: View {
    
    @ObservedObject var node: AppNode
    @EnvironmentObject private var codeScroller: CodeScroller

    var body: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                AppCodeLineView(node: node)
                    .lineLimit(1)
                    .padding(.bottom, 50)
                    .onChange(of: codeScroller.currentCodeNodeId) { newValue in
                        withAnimation {
                            scrollView.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
    }
}

@available(iOS 16, *)
private struct AppCodeLineView: View {
    
    @ObservedObject var node: AppNode

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text("import")
                    .foregroundColor(colorScheme.codeColors.keywordColor)
                Text(" SwiftUI")
                    .foregroundColor(colorScheme.codeColors.frameworkColor)
            }
            .blur(radius: nodeTracker.blurForNonNode())
            .padding(.top)
            Text(" ")
            HStack(spacing: 0) {
                Text("struct")
                    .foregroundColor(colorScheme.codeColors.keywordColor)
                Text(" ContentView")
                    .foregroundColor(colorScheme.codeColors.propertyName)
                Text(": ")
                Text("View")
                    .foregroundColor(colorScheme.codeColors.typeName)
                Text(" {")
            }
            .blur(radius: nodeTracker.blurForNonNode())
            HStack(spacing: 0) {
                Text("    var")
                    .foregroundColor(colorScheme.codeColors.keywordColor)
                Text(" body")
                    .foregroundColor(colorScheme.codeColors.propertyName)
                Text(": ")
                Text("some ")
                    .foregroundColor(colorScheme.codeColors.keywordColor)
                Text("View")
                    .foregroundColor(colorScheme.codeColors.typeName)
                Text(" {")
            }
            .blur(radius: nodeTracker.blurForNonNode())
            ContainerNodeCodeLineView(containerNode: node.rootContainerNode, indentLevel: 2)
            Text("    }")
                .blur(radius:nodeTracker.blurForNonNode())
            Text("}")
                .blur(radius:nodeTracker.blurForNonNode())
        }
    }
}

@available(iOS 16, *)
struct RootCodeLinesView_Previews: PreviewProvider {
    static var previews: some View {
        RootCodeLinesView(node: AppNode(rootNode: VStackNode(subNodes: [])))
    }
}
