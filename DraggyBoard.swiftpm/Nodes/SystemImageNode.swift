import Foundation

class SystemImageNode: Node {
    
    @Published var systemImageName: String
    let imageSizeModification = ImageSizeModification()
    let imageColorModification = ImageColorModification()

    init(systemImageName: String, imageColor: TextColor = .primary, imageSize: CGFloat = 20) {
        self.systemImageName = systemImageName
        imageSizeModification.imageSize = imageSize
        imageColorModification.imageColor = imageColor
        super.init(nodeType: .image, subNodes: nil)
    }
    
    override func asCode(indentLevel: Int = 0) -> String {
        let firstLine = "\(indentation(indentLevel))Image(systemName: \"\(systemImageName)\")"
        var allCode = firstLine
        if imageSizeModification.imageSize != 20 {
            let size = imageSizeModification.imageSize
            let resizableModificationLine = "\(indentation(indentLevel + 1)).resizable()"
            let imageSizeModificationLine = "\(indentation(indentLevel + 1)).frame(width: \(size), height: \(size))"
            allCode += "\n" + resizableModificationLine + "\n" + imageSizeModificationLine
        }
        if imageColorModification.imageColor != .primary {
            let imageColorModificationLine = "\(indentation(indentLevel + 1)).foregroundColor(.\(imageColorModification.imageColor.rawValue))"
            allCode += "\n" + imageColorModificationLine
        }
        return allCode
    }
}
