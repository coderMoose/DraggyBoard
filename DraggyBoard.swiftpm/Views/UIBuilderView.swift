import SwiftUI

@available(iOS 16, *)
struct UIBuilderView: View {

    @ObservedObject var tree: AppNode
    let currentLesson: Lesson
    @Binding var showNotification: Bool
    @Binding var notificationText: String
    @Binding var showDragHint: Bool

    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller

    @State private var modificationsEditorHasAppeared = false

    var body: some View {
        uiBuilderSide
    }
    
    private var uiBuilderSide: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                Text("UI Building Blocks")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                    .padding(.bottom)
                draggableViewItems
                    .padding(.bottom)
                dragHint
                if currentLesson.allTasksAreComplete {
                    VStack {
                        Text("Great Job!")
                            .bold()
                            .font(.title)
                    }
                    .background(Color(.systemGroupedBackground))
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                nodeTracker.deselectAnthingThatIsSelected()
            }
            treeView
        }
        .background(Color(.systemGroupedBackground))
    }
    
    @ViewBuilder
    private var dragHint: some View {
        if showDragHint {
            Text("Drag one of the boxes above on to the VStack below")
                .font(.title3)
                .bold()
                .multilineTextAlignment(.center)
                .transition(.scale.combined(with: .opacity))
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity)
        } else if !modificationsEditorHasAppeared {
            VStack {
                Text("Tap on the blue arrow beside VStack to expand it. You can tap any item on the UI Board to change how it looks.")
                    .font(.title3)
                    .bold()
                    .transition(.scale.combined(with: .opacity))
                    .padding(.horizontal)
                    .padding(.top, 20)
                HStack {
                    Spacer()
                    Image(systemName: "arrow.down")
                        .imageScale(.large)
                        .padding(.trailing)
                        .padding(.trailing)
                }
            }
        }
    }
    
    private var treeView: some View {
        List {
            Section("UI Board") {
                outlineGroup
            }
            if let completionMessage = currentLesson.currentCompletionMessage {
                HStack {
                    Text(Image(systemName: "checkmark.message.fill")).foregroundColor(.green) +
                    Text(" " + completionMessage)
                }
                .imageScale(.large)
                .transition(.slide)
            }
            if !currentLesson.tasks.isEmpty {
                Section("To Do List") {
                    todoListSection
                }
                .onTapGesture {
                    nodeTracker.deselectAnthingThatIsSelected()
                }
            }
            // This rectangle is intentionally invisible, but provides an area
            // the user can tap to deselect a cell or dismiss the keyboard
            Rectangle()
                .foregroundColor(Color(.systemGroupedBackground))
                .background(Color(.systemGroupedBackground))
                .listRowBackground(Color(.systemGroupedBackground))
                .onTapGesture {
                    nodeTracker.deselectAnthingThatIsSelected()
                }
                .frame(height: 900)
        }
        .font(.title2)
    }
    
    private var outlineGroup: some View {
        // Andrew: use drag and drop APIs to build the feature by yourself
        
        // otherwise use this:
//        List(tree.rootContainerNode, children: \.subNodes) { node in
//            
//        }
        OutlineGroup(tree.rootContainerNode, children: \.subNodes) { node in
            VStack {
                treeItem(for: node)
                    .padding(.top, nodeTracker.isSelected(node: node) ? 10 : 0)
                if nodeTracker.isSelected(node: node) {
                    ModificationsEditorView(node: node, modificationsEditorHasAppeared: $modificationsEditorHasAppeared) {
                        withAnimation {
                            redrawEverything()
                        }
                    }
                    .onTapGesture {
                        nodeTracker.hideKeyboard()
                    }
                    .id(node.id)
                    .transition(.push(from: .leading).combined(with: .opacity).animation(.linear.delay(0.4)))
                }
            }
        }
    }
    
    private var todoListSection: some View {
        ForEach(currentLesson.tasks) { task in
            LessonTaskView(task: task)
        }
    }
    
    private func treeItem(for node: Node) -> some View {
        TreeItemView(node: node) {
            redrawEverything()
        }
        .padding(2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contextMenu {
            reverseItemsButton(for: node)
            if node.isMovable {
                moveUpButton(for: node)
                moveDownButton(for: node)
            }
            deleteButton(for: node)
        }
        // Allow a tap anywhere in the row, not just on the Text
        // Learned this trick from:  https://www.hackingwithswift.com/quick-start/swiftui/how-to-control-the-tappable-area-of-a-view-using-contentshape
        .contentShape(Rectangle())
        .onTapGesture {
            nodeTracker.toggleSelection(node: node)
            codeScroller.currentCodeNodeId = node.id
        }
        .font(.title2)
        .opacity(nodeTracker.selectedNodeId == nil ? 1.0 : nodeTracker.isSelected(node: node) ? 1.0 : 0.3)
        .dropDestination(for: String.self) { items, location in
            guard let nodeTypeRawValue = items.first else {
                return false
            }
            guard let containerNode = node as? ContainerNode else {
                // For example, can't add an Image view to a Text view. It would have to be added to container view like an HStack.
                let nodeTypeBeingDraggedIn = NodeType(rawValue: nodeTypeRawValue)!
                showWrongNodeTypeNotification(from: nodeTypeBeingDraggedIn, to: node.nodeType)
                return false
            }
            let nodeTypeBeingDraggedIn = NodeType(rawValue: nodeTypeRawValue)!
            if nodeTypeBeingDraggedIn == .barMark && containerNode.nodeType != .chart {
                showWrongNodeTypeNotification(from: nodeTypeBeingDraggedIn, to: containerNode.nodeType)
                return false
            }
            if containerNode.nodeType == .chart && nodeTypeBeingDraggedIn != .barMark {
                showWrongNodeTypeNotification(from: nodeTypeBeingDraggedIn, to: containerNode.nodeType)
                return false
            }
            let wasSuccessful = addNewView(ofType: nodeTypeRawValue, to: containerNode)
            return wasSuccessful
        }
    }
    
    private func showWrongNodeTypeNotification(from fromNodeType: NodeType, to toNodeType: NodeType) {
        let destinationNodeText = fromNodeType == .barMark ? "a Chart" : "an HStack or VStack"
        notificationText = "Oops! \(fromNodeType.capitalizedName) views can't be added to \(toNodeType.capitalizedName) views - try adding it to \(destinationNodeText) instead."
        withAnimation(.linear(duration: 0.8)) {
            showNotification = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                withAnimation(.linear(duration: 0.8)) {
                    showNotification = false
                }
            }
        }
    }
    
    private func addNewView(ofType nodeTypeRawValue: String, to containerNode: ContainerNode) -> Bool {
        guard let nodeType = NodeType(rawValue: nodeTypeRawValue) else {
            return false
        }
        withAnimation {
            let idForNewNode = containerNode.addNewNode(ofType: nodeType)
            codeScroller.currentCodeNodeId = idForNewNode
            redrawEverything()
            hideDragHint()
        }
        return true
    }
    
    private var draggableViewItems: some View {
        // When hiding the side view, the LazyVGrid doesn't animate correctly.
        // Found this workaround (put it in a ScrollView):
        // https://stackoverflow.com/questions/71277099/swiftui-lazyvgrid-transition-animation-not-as-expected
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.fixed(114)),
                                GridItem(.fixed(114)),
                                GridItem(.fixed(114))]) {
                ForEach(currentLesson.viewsAllowed, id: \.self) { nodeType in
                    draggableView(for: nodeType)
                        .draggable(nodeType.rawValue) {
                            ZStack {
                                Color(.quaternaryLabel)
                                draggableView(for: nodeType)
                            }
                        }
                        .onTapGesture {
                            _ = addNewView(ofType: nodeType.rawValue, to: tree.rootContainerNode)
                        }
                        .padding(.horizontal, 4)
                }
            }
        }
        .frame(height: 46.0 * CGFloat(rows))
    }
    
    private var rows: Int {
        if currentLesson.viewsAllowed.count % 3 == 0 {
            return currentLesson.viewsAllowed.count / 3
        }
        // Round up
        return (currentLesson.viewsAllowed.count / 3) + 1
    }
    
    private func draggableView(for nodeType: NodeType) -> some View {
        HStack {
            Image(systemName: nodeType.systemImageName)
                .imageScale(.large)
            Text(nodeType.capitalizedName)
                .font(.title3)
                .bold()
        }
        .frame(width: 104, height: 30)
        .padding(5)
        .background(Color.blue)
        .cornerRadius(10)
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    private func reverseItemsButton(for node: Node) -> some View {
        if node.nodeType.isContainer && node.hasAtLeastTwoSubNodes {
            Button {
                withAnimation {
                    (node as? ContainerNode)?.reverseItems()
                    redrawEverything()
                }
            } label: {
                Label("Reverse Items", systemImage: "arrow.left.arrow.right")
            }
        }
    }
    
    private func moveUpButton(for node: Node) -> some View {
        Button {
            withAnimation {
                node.moveUp()
                redrawEverything()
            }
        } label: {
            Label("Move Up", systemImage: "arrow.up")
        }
    }

    private func moveDownButton(for node: Node) -> some View {
        Button {
            withAnimation {
                node.moveDown()
                redrawEverything()
            }
        } label: {
            Label("Move Down", systemImage: "arrow.down")
        }
    }
    
    private func deleteButton(for node: Node) -> some View {
        Button(role: .destructive) {
            withAnimation {
                node.delete()
                nodeTracker.selectedNodeId = nil
                redrawEverything()
            }
        } label: {
            Label("Delete", systemImage: "trash")
        }
    }
    
    private func hideDragHint() {
        guard showDragHint else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showDragHint = false
            }
        }
    }
    
    // Everything (i.e. the device preview view and the code view) is observing the root node.
    // But changes to subnodes aren't being observed automatically. So when I change a subnode,
    // I call redrawEverything, which forces the root node (tree) to republish, which causes
    // the entire screen to redraw
    func redrawEverything() {
        tree.redrawEverything()
        currentLesson.checkTaskCompletion(appNode: tree)
    }
}

@available(iOS 16, *)
struct UIBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        UIBuilderView(tree: AppNode(rootNode: VStackNode(subNodes: nil)),
                      currentLesson: LessonManager.allLessons[0],
                      showNotification: .constant(false),
                      notificationText: .constant(""),
                      showDragHint: .constant(false))
            .environmentObject(NodeSelectionTracker())
    }
}
