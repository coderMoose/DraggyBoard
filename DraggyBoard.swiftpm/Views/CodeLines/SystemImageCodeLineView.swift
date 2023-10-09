import SwiftUI

@available(iOS 16, *)
struct SystemImageCodeLineView: View {

    @ObservedObject var systemImageNode: SystemImageNode
    let indentLevel: Int
    
    @EnvironmentObject private var nodeTracker: NodeSelectionTracker
    @EnvironmentObject private var codeScroller: CodeScroller

    @Environment(\.colorScheme) private var colorScheme: ColorScheme

    @State private var imageTextAngle = 180.0
    @State private var showImageName = false
    @State private var showBraces = false
    
    var body: some View {
        VStack(alignment: .leading) {
            mainCodeLine
            if nodeTracker.isSelected(node: systemImageNode) {
                ExplanationView(explanation: systemImageNode.nodeType.explanation)
            }
            imageSizeModifications
        }
        .blur(radius: nodeTracker.blur(for: systemImageNode))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    imageTextAngle = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showImageName = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    showBraces = true
                }
            }
        }
    }
    
    private var mainCodeLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: indentLevel * 4))
                .fixedSize()
            Text("Image")
                .foregroundColor(colorScheme.codeColors.typeName)
                .rotation3DEffect(Angle.degrees(imageTextAngle), axis: (x: 0.0, y: 1.0, z: 0.0))
                .transition(.scale.combined(with: .opacity))
                .onTapGesture {
                    nodeTracker.toggleSelection(node: systemImageNode)
                    codeScroller.scroll(to: systemImageNode)
                }
            if showBraces {
                Text("(systemName: ")
                    .transition(.scale.combined(with: .opacity))
            }
            if showImageName {
                Text("\"" + systemImageNode.systemImageName + "\"")
                    .foregroundColor(colorScheme.codeColors.string)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            if showBraces {
                Text(")")
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
    
    @ViewBuilder
    private var imageSizeModifications: some View {
        ImageSizeCodeLineView(imageSizeModification: systemImageNode.imageSizeModification,
                             indentLevel: indentLevel)
        ImageColorCodeLineView(imageColorModification: systemImageNode.imageColorModification,
                              indentLevel: indentLevel)

    }
}

@available(iOS 16, *)
private struct ImageSizeCodeLineView: View {

    @ObservedObject var imageSizeModification: ImageSizeModification
    let indentLevel: Int
    
    var body: some View {
        if imageSizeModification.imageSize != 20.0 {
            modificationLine
                .transition(.scale.combined(with: .opacity))
        }
    }

    @ViewBuilder
    private var modificationLine: some View {
        let imageSize = Int(imageSizeModification.imageSize).description
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                    .fixedSize()
                Text(".resizable()")
            }
            HStack(spacing: 0) {
                Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                    .fixedSize()
                Text(".frame(width: ")
                Text(imageSize)
                    .id(UUID())
                    .transition(.scale.combined(with: .opacity))
                Text(", height: ")
                Text(imageSize)
                    .id(UUID())
                    .transition(.scale.combined(with: .opacity))
                Text(")")
            }
        }
    }
}

@available(iOS 16, *)
private struct ImageColorCodeLineView: View {

    @ObservedObject var imageColorModification: ImageColorModification
    let indentLevel: Int
    
    @Environment(\.colorScheme) private var colorScheme: ColorScheme
    
    var body: some View {
        if imageColorModification.imageColor != .primary {
            modificationLine
                .transition(.scale.combined(with: .opacity))
        }
    }

    private var modificationLine: some View {
        HStack(spacing: 0) {
            Text(String(repeating: " ", count: (indentLevel + 1) * 4))
                .fixedSize()
            Text(".foregroundColor(")
            HStack(spacing: 0) {
                Text(".")
                Text(imageColorModification.imageColor.rawValue)
            }
            .fontWeight(.semibold)
            .foregroundColor(colorScheme.codeColors.propertyName)
            .id(UUID())
            .transition(.scale.combined(with: .opacity))
            Text(")")
        }
    }
}

@available(iOS 16, *)
struct SystemImageCodeLineView_Previews: PreviewProvider {
    static var previews: some View {
        SystemImageCodeLineView(systemImageNode: SystemImageNode(systemImageName: "bicycle"), indentLevel: 0)
    }
}
