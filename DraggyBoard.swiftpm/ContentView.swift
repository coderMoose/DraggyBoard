import SwiftUI

/*
 

 
 
 Hello! Welcome to DraggyBoard!


 ***

 Please note, sometimes when you tap the Play button, Swift Playgrounds just displays a blank screen.

 If you see a blank screen, please tap the restart button, it always seems to work after that.

 ***
 
 
 
 
*/

@available(iOS 16, *)
struct ContentView: View {
    
    let currentLesson: Lesson
    @Binding var colorScheme: ColorScheme
    
    @StateObject private var tree = buildBasicVStack()
    @StateObject private var nodeTracker = NodeSelectionTracker()
    @StateObject private var codeScroller = CodeScroller()
    @State private var showNotification = false
    @State private var notificationText = ""
    @State private var showBuilderSide = false
    @State private var draggedAmount = 0.0
    @State private var finishedLessonIntroAnimation = false
    @State private var showDragHint = true

    var body: some View {
        allContent
            .preferredColorScheme(colorScheme)
            .environmentObject(nodeTracker)
            .environmentObject(codeScroller)
            .onAppear {
                startLessonIntroAnimation()
                TreePreviewer.nodeTracker = nodeTracker
            }
    }
    
    private var allContent: some View {
        ZStack {
            mainContent
                .blur(radius: showNotification ? 10.0 : 0)
            NotificationView(notificationText: notificationText, showNotification: $showNotification)
        }
    }
    
    private var mainContent: some View {
        HStack {
            if showBuilderSide {
                UIBuilderView(tree: tree,
                              currentLesson: currentLesson,
                              showNotification: $showNotification,
                              notificationText: $notificationText,
                              showDragHint: $showDragHint)
                .frame(width: 400)
                .transition(.asymmetric(insertion: .slide,
                                        removal: .push(from: .trailing)))
            }
            previewSide
                .contentShape(Rectangle())
                .onTapGesture {
                    nodeTracker.deselectAnthingThatIsSelected()
                }
        }
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    withAnimation {
                        showBuilderSide.toggle()
                    }
                } label: {
                    Label("Hide", systemImage: "sidebar.left")
                }
                .padding(.leading, 20)
                .opacity(finishedLessonIntroAnimation ? 1.0 : 0.0)
            }
            ToolbarItem(placement: .secondaryAction) {
                copyCodeButton
            }
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    withAnimation {
                        colorScheme = colorScheme == .light ? .dark : .light
                    }
                } label: {
                    Label("Switch to \(colorScheme == .light ? "Dark" : "Light") Mode", systemImage: colorScheme == .light ? "lightbulb" : "lightbulb.fill")
                }
            }
        }
    }
    
    private var copyCodeButton: some View {
        Button {
            UIPasteboard.general.string = tree.asCode()
        } label: {
            Label("Copy Code to Clipboard", systemImage: "list.clipboard")
        }
    }
    
    private var previewSide: some View {
        VStack(spacing: 0) {
            Text("Preview")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.vertical)
            DevicePreviewView(tree: tree, draggedAmount: $draggedAmount)
            // This bar is draggable so that the user can have the code take up more or less space, as they wish
            Rectangle()
                .foregroundColor(Color(.tertiaryLabel))
                .frame(height: 5)
                .gesture(
                    DragGesture(coordinateSpace: .global)
                        .onChanged { gestureValue in
                            dump(gestureValue)
                            withAnimation {
                                let screenHeight = UIScreen.main.bounds.height
                                let limit = screenHeight * 0.14
                                var amountToChange = gestureValue.location.y - gestureValue.startLocation.y
                                if amountToChange > limit {
                                    amountToChange = limit
                                }
                                if amountToChange < -limit {
                                    amountToChange = -limit
                                }
                                draggedAmount = amountToChange
                            }
                        }
                    )
                .padding(.top)
            RootCodeLinesView(node: tree)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .font(showBuilderSide ? .title3.monospaced() : .title.monospaced())
                .contextMenu {
                    copyCodeButton
                }
        }
    }
    
    private func startLessonIntroAnimation() {
        let timePerNode = 0.9
        let newTree = currentLesson.introAnimationTree
        
        animateIndividualNodes(newTree: newTree, timePerNode: timePerNode)
        
        let numNodes = (newTree.rootContainerNode.subNodes ?? []).count
        let finalAnimationDelay = 1.5 + timePerNode * CGFloat(numNodes)
        startHideIntroCodeAnimation(delay: finalAnimationDelay)
    }
    
    private func animateIndividualNodes(newTree: AppNode, timePerNode: Double) {
        var animationDelay = 1.5

        // This actually starts out as nil, so ensure we have an array
        tree.rootContainerNode.subNodes = []
        
        for node in newTree.rootContainerNode.subNodes ?? [] {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDelay) {
                withAnimation(.linear(duration: 0.5)) {
                    tree.rootContainerNode.subNodes?.append(node)
                    codeScroller.currentCodeNodeId = node.id
                    tree.redrawEverything()
                }
            }
            animationDelay += timePerNode
        }
    }
    
    private func startHideIntroCodeAnimation(delay: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay + 2) {
            withAnimation {
                tree.rootContainerNode.subNodes = []
                tree.redrawEverything()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                withAnimation {
                    showBuilderSide = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        finishedLessonIntroAnimation = true
                    }
                }
            }
        }
    }
}

@available(iOS 16, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(currentLesson: LessonManager.allLessons[0],
                    colorScheme: .constant(.light))
    }
}
