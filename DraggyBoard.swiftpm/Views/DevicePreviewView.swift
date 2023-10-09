import SwiftUI

/**
 This file is reponsible for drawing the preview view in the top right corner
 */

@available(iOS 16, *)
struct DevicePreviewView: View {
    
    @ObservedObject var tree: AppNode
    @Binding var draggedAmount: Double

    // iPhone 14 Pro: 2556x1179
    let aspectRatio = 117.9 / 255.6
    
    @State private var deviceHeight = 255.6
    @State private var isRotated = false

    var body: some View {
        VStack {
            TreePreviewer.drawContainer(tree: tree.rootContainerNode)
                .frame(maxWidth: deviceWidth,
                       maxHeight: deviceHeight + draggedAmount)
                .padding()
                .padding(.horizontal)
                .clipped()
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.label).opacity(0.9), lineWidth: 2)
                )
        }
        .frame(maxWidth: .infinity)
        HStack {
            Spacer()
            Button {
                withAnimation {
                    isRotated.toggle()
                }
            } label: {
                Image(systemName: "rotate.left")
                    .imageScale(.large)
            }
        }
        .padding(.trailing)
    }
    
    private var deviceWidth: CGFloat {
        if isRotated {
            return (deviceHeight + draggedAmount) / aspectRatio
        } else {
            return (deviceHeight + draggedAmount) * aspectRatio
        }
    }
}

@available(iOS 16, *)
struct DevicePreviewView_Previews: PreviewProvider {
    static var previews: some View {
        DevicePreviewView(tree: AppNode(rootNode: VStackNode(subNodes: nil)), draggedAmount: .constant(0))
    }
}
